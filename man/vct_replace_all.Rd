% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/vct_replace_all.R
\name{vct_replace_all}
\alias{vct_replace_all}
\title{Replace values in a vector}
\usage{
vct_replace_all(x, replacement = na_as(x), except = NULL, preserve_nas = FALSE)
}
\arguments{
\item{x}{An \code{\link[checkmate:checkAtomic]{atomic}} vector.}

\item{replacement}{(Optional) A single value to replace the values in \code{x}
(Default: \code{na_as(x)}).}

\item{except}{(Optional) A vector of values to exclude from replacement.}

\item{preserve_nas}{(Optional) A \code{\link[base:logical]{logical}} flag to
indicating if the function must preserve \code{NA} values in \code{x}
(Default: \code{FALSE}).}
}
\value{
The same type of object in \code{x} with the values replaced.
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#maturing}{\figure{lifecycle-maturing.svg}{options: alt='[Maturing]'}}}{\strong{[Maturing]}}

\code{vct_replace_all()} replaces values in a vector with a specified value.
}
\examples{
vct_replace_all(1:10)
#> [1] NA NA NA NA NA NA NA NA NA NA

vct_replace_all(1:10, replacement = 0L, except = 5:7)
#> [1] 0 0 0 0 5 6 7 0 0 0

vct_replace_all(c("a", "b", NA, "c"), replacement = "d", preserve_nas = TRUE)
#> [1] "d" "d" NA  "d"
}
\seealso{
Other conditional functions: 
\code{\link{swap_if}()}
}
\concept{conditional functions}
