% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ki_station_list.R
\name{ki_station_list}
\alias{ki_station_list}
\title{Get tibble containing station information.}
\usage{
ki_station_list(
  hub,
  search_term,
  bounding_box,
  group_id,
  return_fields,
  datasource = 0
)
}
\arguments{
\item{hub}{The KiWIS database you are querying. Either one of the defaults or a URL.
See \href{https://github.com/rywhale/kiwisR}{README}.}

\item{search_term}{(Optional) A station name to search for. Supports the use of * as a wildcard. Case doesn't matter.}

\item{bounding_box}{(Optional) A bounding box to search within for stations. Should be a vector or comma separated string.}

\item{group_id}{(Optional) A station group id (see ki_group_list).
with the following format: (min_x, min_y, max_x, max_y).}

\item{return_fields}{(Optional) Specific fields to return. Consult your KiWIS hub services documentation for available options.
Should be a comma separate string or a vector.}

\item{datasource}{(Optional) The data source to be used, defaults to 0.}
}
\value{
Tibble containing station metadata.
}
\description{
Returns all available stations by default and allows for search terms and other filters.
}
\examples{
\dontrun{
ki_station_list(hub = "swmc")
ki_station_list(hub = "swmc", search_term = "A*")
ki_station_list(hub = "swmc", bounding_box = "-131.7,-5.4,135.8,75.8")
ki_station_list(hub = "swmc", group_id = "518247")
}

}
