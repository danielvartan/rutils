% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/raw_data.R
\name{raw_data_1}
\alias{raw_data_1}
\title{Get paths to \verb{[INSERT PACKAGE NAME]} raw data}
\usage{
raw_data_1(file = NULL, package = NULL)
}
\arguments{
\item{file}{(optional) A \code{\link[base:character]{character}} vector indicating
the file name(s) of the raw data. If \code{NULL}, all raw data file names will
be returned (Default: \code{NULL}).}

\item{package}{(optional) A \code{\link[base:character]{character}} string indicating
the package with the database data. If \code{NULL}, the function will try to
use the basename of the working directory (Default: \code{NULL}).}
}
\value{
If \code{file == NULL}, a \code{\link[=character]{character}} vector with all file
names available. Else, a string with the file name path.
}
\description{
\code{raw_data_1()} returns the raw data paths of the \verb{[INSERT PACKAGE NAME]}
package.
}
\examples{
if (interactive()) {
## To list all raw data file names available

  raw_data_1()

## To get the file path from a specific raw data

  raw_data_1(raw_data()[1])
}
}
\seealso{
Other R package functions: 
\code{\link{raw_data_2}()},
\code{\link{update_pkg_versions}()},
\code{\link{update_pkg_year}()}
}
\concept{R package functions}
\keyword{internal}
