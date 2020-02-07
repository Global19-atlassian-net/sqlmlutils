# Copyright(c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT license.

import pyodbc
from pandas import DataFrame
from .connectioninfo import ConnectionInfo
from .sqlbuilder import SQLBuilder

"""This module is used to actually execute sql queries. It uses the pymssql module under the hood.

It is mostly setup to work with SQLBuilder objects as defined in sqlbuilder.
"""


# This function is best used to execute_function_in_sql a one off query
# (the SQL connection is closed after the query completes).
# If you need to keep the SQL connection open in between queries, you can use the _SQLQueryExecutor class below.
def execute_query(builder, connection: ConnectionInfo, out_file:str=None):
    with SQLQueryExecutor(connection=connection) as executor:
        return executor.execute(builder, out_file=out_file)


def execute_raw_query(conn: ConnectionInfo, query, params=()):
    with SQLQueryExecutor(connection=conn) as executor:
        return executor.execute_query(query, params)


def _sql_msg_handler(msgstate, severity, srvname, procname, line, msgtext):
    print(msgtext.decode())


class SQLQueryExecutor:
    """_SQLQueryExecutor objects keep a SQL connection open in order to execute_function_in_sql one or more queries.

    This class implements the basic context manager paradigm.
    """

    def __init__(self, connection: ConnectionInfo):
        self._connection = connection

    def execute(self, builder: SQLBuilder, out_file=None, getResults=True):
        df = DataFrame()
        try:
            if out_file is not None:
                with open(out_file,"a") as f:
                    if builder.params is not None:
                        script = builder.base_script.replace("?", "N'%s'")
                        f.write(script % builder.params)
                    else:
                        f.write(builder.base_script)
                    f.write("GO\n")
                    f.write("-----------------------------")
            else:    
                if builder.params is not None:
                    self._cursor.execute(builder.base_script, builder.params)
                else:
                    self._cursor.execute(builder.base_script)
                if getResults and self._cursor.description is not None:
                    column_names = [element[0] for element in self._cursor.description]
                    rows = [tuple(t) for t in self._cursor.fetchall()]
                    df = DataFrame(rows, columns=column_names)
        except Exception as e:
            raise RuntimeError("Error in SQL Execution") from e
        
        return df

    def execute_query(self, query, params, out_file=None):
        if out_file is not None:
            with open(out_file, "a") as f:
                if params is not None:
                    script = query.replace("?", "'%s'")
                    f.write(script % params)
                else:
                    f.write(query)
                f.write("GO\n")
                f.write("-----------------------------")

        if params is not None:
            self._cursor.execute(query, params)
        else:
            self._cursor.execute(query)

        df = DataFrame()

        if self._cursor.description is not None:
            column_names = [element[0] for element in self._cursor.description]
            rows = [tuple(t) for t in self._cursor.fetchall()]
            df = DataFrame(rows, columns=column_names)
        
        return df

    def __enter__(self):
        server=self._connection._server if self._connection._port == "" \
            else "{servername},{port}".format(servername=self._connection._server, port=self._connection._port)

        self._cnxn = pyodbc.connect(driver=self._connection._driver,
                                    server=server,
                                    user=self._connection.uid,
                                    password=self._connection.pwd,
                                    database=self._connection.database,
                                    autocommit=True)
        self._cursor = self._cnxn.cursor()
        return self

    def __exit__(self, exception_type, exception_value, traceback):
        self._cnxn.close()