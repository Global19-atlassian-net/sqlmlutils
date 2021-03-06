% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/executeInSQL.R
\name{executeSQLQuery}
\alias{executeSQLQuery}
\title{Execute a script in SQL}
\usage{
executeSQLQuery(
  connectionString,
  sqlQuery,
  getScript = FALSE,
  languageName = "R"
)
}
\arguments{
\item{connectionString}{character string. The connectionString to the database}

\item{sqlQuery}{character string. The query to execute}

\item{getScript}{boolean. Return the tsql script that would be run on the server instead of running it}

\item{languageName}{string. Use a language name other than the default R, if using an EXTERNAL LANGUAGE.}
}
\value{
The data frame returned by the query to the database
}
\description{
Execute a script in SQL
}
\examples{
\dontrun{
connection <- connectionInfo(database="AirlineTestDB")
executeSQLQuery(connection, sqlQuery="SELECT top 1 * from airline5000")
}


}
