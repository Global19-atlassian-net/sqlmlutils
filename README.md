# sqlmlutils

[![Build Status](https://travis-ci.com/Microsoft/sqlmlutils.svg?branch=master)](https://travis-ci.com/Microsoft/sqlmlutils)

sqlmlutils is a package designed to help users interact with SQL databases (SQL Server and Azure SQL Database) and execute R or Python code in SQL from an R/Python client. 
Currently, only the R version of sqlmlutils is supported in Azure SQL Database. Python support will be added later.

### Check out the README in each language folder for language-specific details and code examples!

# Installation

To install sqlmlutils, follow the instructions below for Python and R, respectively.

Python:
To install from PyPI:
Run
```
pip install sqlmlutils
```
To install from file:
```
pip install Python/dist/sqlmlutils-1.0.1.zip
```

R:

Windows:

From command prompt, run 
```
R.exe -e "install.packages('RODBCext', repos='https://mran.microsoft.com/snapshot/2019-02-01/')"
R.exe CMD INSTALL dist/sqlmlutils_0.7.2.zip
```
OR
To build a new package file and install, run
```
.\buildandinstall.cmd
```

Linux
```
R.exe -e "install.packages('RODBCext', repos='https://mran.microsoft.com/snapshot/2019-02-01/')"
R.exe CMD INSTALL dist/sqlmlutils_0.7.2.tar.gz
```

# Details

sqlmlutils contains 3 main parts:
- Execution of Python/R in SQL databases using sp_execute_external_script
- Creation and execution of stored procedures created from scripts and functions
- Install and manage packages in SQL databases

For more specifics and examples of how to use each language's API, look at the README in the respective folder.

## Execute in SQL

Execute in SQL provides a convenient way for the user to execute arbitrary Python/R code inside a SQL database using an sp_execute_external_script. The user does not have to know any t-sql to use this function. Function arguments are serialized into binary and passed into the t-sql script that is generated. Warnings and printed output will be printed at the end of execution, and any results returned by the function will be passed back to the client. 

## Stored Procedures (Sprocs)

The goal of this utility is to allow users to create and execute stored procedures on their database without needing to know the exact syntax of creating one. Functions and scripts are wrapped into a stored procedure and registered into a database, then can be executed from the Python/R client.

## Package Management

##### R and Python package management with sqlmlutils is supported in SQL Server 2019 CTP 2.4 and later.

With package management users can install packages to a remote SQL database from a client machine. The packages are downloaded on the client and then sent over to SQL databases where they will be installed into library folders. The folders are per-database so packages will always be installed and made available for a specific database. The package management APIs provided a PUBLIC and PRIVATE folders. Packages in the PUBLIC folder are accessible to all database users. Packages in the PRIVATE folder are only accessible by the user who installed the package.
