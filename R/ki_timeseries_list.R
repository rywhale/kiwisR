#' Get list of available time series for station or
#' list of stations.
#'
#' @export
#' @param hub The KiWIS database you are querying. Default options are 'swmc', 'grand', 'quinte'.
#' See README for more details.
#' @param station_id Either a single station id or a vector of station id. Can be string or numeric.
#' Station ids can be found using the ki_station_list function.
#' @return A data frame containing all available time series for selected stations.
#' @examples
#' ki_timeseries_list(hub = 'swmc', station_id = "144659")
#' ki_timeseries_list(hub = 'swmc', station_id = c("144659", "144342"))
#'

ki_timeseries_list <- function(hub, station_id){

  if(missing(station_id)){
    return("No station id provided.")
  }

  # Identify hub
  default_hubs <- c("swmc",
                    "grand",
                    "quinte")

  # Hub selection
  if(missing(hub) | !is.character(hub)){
    return("No hub selected! Please select 'swmc', 'grand', 'quinte' or input your own URL.")
  }
  if(hub=="swmc"){
    api_url<-"http://204.41.16.133/KiWIS/KiWIS?"
  }
  if(hub=="grand"){
    api_url<-"http://kiwis.grandriver.ca/KiWIS/KiWIS?"
  }
  if(hub=="quinte"){
    api_url<-"http://waterdata.quinteconservation.ca/KiWIS/KiWIS?"
  }
  if(hub %in% default_hubs == FALSE){
    # Non-default KiWIS URL
    api_url <- hub
  }

  # Account for multiple station_ids
  station_id <- paste(station_id, collapse = ",")

  api_query <- list(service = "kisters",
                    type = "queryServices",
                    request = "getTimeseriesList",
                    format = "json",
                    kvp = "true",
                    returnfields = "coverage,station_name,station_id,ts_id,ts_name",
                    station_id = station_id)

  # Call API
  raw <- httr::GET(url = api_url, query = api_query)

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
