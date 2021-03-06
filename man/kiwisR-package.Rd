% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/kiwisR-package.R
\docType{package}
\name{kiwisR-package}
\alias{kiwisR}
\alias{kiwisR-package}
\title{kiwisR: A wrapper for querying KISTERS WISKI Databases via the KiWIS API}
\description{
kiwisR provides a simplified method for retrieving tidy data from KISTERS WISKI databases via KiWIS API.
}
\details{
A suggested workflow for using this package:
\itemize{
 \item Get station metadata using \code{ki_station_list()}
 \item Get time series metadata using \code{ki_timeseries_list()}
 \item Get time series data using \code{ki_timeseries_values()}
}
}
\seealso{
Useful links:
\itemize{
  \item \url{https://github.com/rywhale/kiwisR}
  \item Report bugs at \url{https://github.com/rywhale/kiwisR/issues}
}

}
\author{
\strong{Maintainer}: Ryan Whaley \email{rdgwhaley@gmail.com}

Other contributors:
\itemize{
  \item Sam Albers \email{sam.albers@gov.bc.ca} [contributor]
}

}
