# Copyright(c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT license.

library(sqlmlutils)
library(methods)
library(testthat)

options(keep.source = TRUE)
Sys.setenv(TZ='GMT')

Sysname <- Sys.info()['sysname']
cat("INFO: sysname=", Sysname, "\n", sep = "")

# Set this environment variable to run tests
runTests = TRUE
if(Sys.getenv("RUN_TESTS") == '') runTests <- FALSE

Driver <- Sys.getenv("DRIVER")
if (Driver == ''){
    if(Sysname == "Windows"){
        Driver <- "SQL Server"
    } else {
        Driver <- "ODBC Driver 17 for SQL Server"
    }
}
cat("INFO: Driver=", Driver, "\n", sep = "")


Server <- Sys.getenv("SERVER")
if (Server == '') Server <- "."

Database <- Sys.getenv("DATABASE")
if (Database == '') Database <- "AirlineTestDB"

Uid <- Sys.getenv("USER")
Pwd <- Sys.getenv("PASSWORD")
PwdAirlineUserdbowner <- Sys.getenv("PASSWORD_AIRLINE_USER_DBOWNER")
PwdAirlineUser <- Sys.getenv("PASSWORD_AIRLINE_USER")

if(Uid == '') Uid = NULL
if(Pwd == '') Pwd = NULL
if(PwdAirlineUserdbowner == '') PwdAirlineUserdbowner = NULL
if(PwdAirlineUser == '') PwdAirlineUser = NULL

sqlcmd_path <- Sys.getenv("SQLCMD")
if (sqlcmd_path == '') sqlcmd_path <- "sqlcmd"

cnnstr <- connectionInfo(driver=Driver, server=Server, database=Database, uid=Uid, pwd=Pwd)

testthatDir <- getwd()
R_Root <- file.path(testthatDir, "../..")
scriptDirectory <- file.path(testthatDir, "scripts")
dataDirectory <- file.path(testthatDir, "data")

options(repos = c(CRAN="https://cran.microsoft.com", CRANextra = "http://www.stats.ox.ac.uk/pub/RWin"))
cat("INFO: repos = ", getOption("repos"), sep="\n")

TestArgs <- list(
    # Compute context specifications
    gitRoot = R_Root,
    testDirectory = testthatDir,
    scriptDirectory = scriptDirectory,
    dataDirectory = dataDirectory,
    driver=Driver,
    server=Server,
    database=Database,
    uid=Uid,
    pwd=Pwd,
    pwdAirlineUserdbowner = PwdAirlineUserdbowner,
    pwdAirlineUser = PwdAirlineUser,
    connectionString = cnnstr,
    sqlcmd = sqlcmd_path,
	runTests = runTests
)

options(TestArgs = TestArgs)
rm(TestArgs)
