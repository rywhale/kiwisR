#' Get list of available time series for station or
#' list of stations.
#'
#' @export
#' @param hub The KiWIS database you are querying. Default options are 'swmc', 'grand', 'quinte' and 'creditvalley'.
#' See README for more details.
#' @param station_id Either a single station id or a vector of station id. Can be string or numeric.
#' Station ids can be found using the ki_station_list function.
#' @param ts_name (Optional) A specific time series short name to search for. E.g. 'TAir.1.O'
#' Supports the use of "*" as a wildcard.
#' @return A tibble containing all available time series for selected stations.
#' @examples
#' ki_timeseries_list(hub = 'swmc', station_id = "144659")
#' ki_timeseries_list(hub = 'swmc', station_id = c("144659", "144342"))
#'

ki_timeseries_list <- function(hub, station_id, ts_name){
  # Check for no input
  if(missing(station_id) & missing(ts_name)){
    stop("No station_id or ts_name search term provided.")
  }

  # Identify hub
  api_url <- check_hub(hub)

  api_query <- list(service = "kisters",
                    type = "queryServices",
                    request = "getTimeseriesList",
                    format = "json",
                    kvp = "true",
                    returnfields = paste0("coverage,",
                                          "station_name,",
                                          "station_id,",
                                          "ts_id,",
                                          "ts_name"))

  if(!missing(station_id)){
    # Account for multiple station_ids
    station_id <- paste(station_id, collapse = ",")
    api_query[['station_id']] <- station_id
  }

  # Check for ts_name search
  if(!missing(ts_name)){
    api_query[['ts_name']] <- ts_name
  }

  # Call API
  raw <- httr::GET(url = api_url,
                   query = api_query)

  # Check for 404
  if(raw$status_code == 404){
    return("Selected hub unavailable!")
  }

  # Parse text
  json_content <- jsonlite::fromJSON(httr::content(raw, "text"))

  # Convert to  tibble
  content_dat <- tibble::as_tibble(json_content[-1, ])

  # Add column names
  colnames(content_dat) <- json_content[1, ]

  # Cast date columns
  content_dat$from <- lubridate::ymd_hms(content_dat$from)
  content_dat$to <- lubridate::ymd_hms(content_dat$to)

  return(content_dat)
}
