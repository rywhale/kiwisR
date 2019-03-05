#' @title kiwisR: A wrapper for querying KISTERS WISKI Databases via the KiWIS API
#' @description kiwisR provides a simplified method for retrieving tidy data from KISTERS WISKI databases via KiWIS API.
#' @details A suggested workflow for using this package:
#' \itemize{
#'  \item Get station metadata using \code{ki_station_list()}
#'  \item Get time series metadata using \code{ki_timeseries_list()}
#'  \item Get time series data using \code{ki_timeseries_values()}
#' }
"_PACKAGE"
