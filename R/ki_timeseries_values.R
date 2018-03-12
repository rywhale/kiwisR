#' Get values for time series id or list of time series ids.
#'
#' @export
#' @param hub The KiWIS database you are querying. Default options are 'swmc', 'grand', 'quinte'.
#' See README for more details.
#' @param ts_id Either: a single time series id or a vector of time series ids. Time series ids
#' can be found using the ki_timeseries_list function
#' @param start_date A date string formatted "YYYY-MM-DD". Defaults to yesterday. All timestamps are UTC.
#' @param end_date A date string formatted "YYYY-MM-DD". Defaults to today. All timestamps are UTC.
#' @return Either: a single data frame or a list of data frames (each named with its time series id)
#' @examples
#' ki_timeseries_values(hub = 'swmc', ts_id = "948928042", from = "2017-01-01", to = "2017-02-22)
#' ki_timeseries_values(hub = 'swmc', ts_id = c("948928042", "948603042"), from = "2017-01-01", to = "2017-02-22)

ki_timeseries_values <- function(hub, ts_id, start_date, end_date, time_zone){

  # Default to past 24 hours
  if(missing(start_date) & missing(end_date)){
    start_date <- Sys.Date() - 1
    end_date <- Sys.Date()
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

  # Account for multiple ts_ids
  ts_id_string <- paste(ts_id, collapse = ",")

  # Metadata to return
  ts_meta <- paste(c("ts_unitname", "ts_unitsymbol",
                     "stationparameter_name", "station_name"),
                   collapse = ",")

  api_query <- list(service = "kisters",
                    type = "queryServices",
                    request = "getTimeseriesValues",
                    format = "json",
                    kvp = "true",
                    ts_id = ts_id_string,
                    from = start_date,
                    to = end_date,
                    metadata = "true",
                    md_returnfields = ts_meta)

  # Call API
  raw <- httr::GET(url = api_url, query = api_query)

  # Check for 404
  if(raw$status_code == 404){
    return("Selected hub unavailable!")
  }

  # Parse to JSON
  json_content <- jsonlite::fromJSON(httr::content(raw, "text"))

  # Grab data for each ts id
  content_dat <- lapply(seq(length(ts_id)), function(x){

    # Convert to data frame
    current_dat <- tibble::as_tibble(json_content$data[[x]])

    # Add column names
    names(current_dat) <- c("Timestamp",
                            paste0(json_content$stationparameter_name[[x]],
                                   " (",
                                   json_content$ts_unitname[[x]],
                                   ")"))
    # Cast date column
    current_dat$Timestamp <- lubridate::ymd_hms(current_dat$Timestamp)

    # Cast values column
    current_dat[[2]] <- as.numeric(current_dat[[2]])

    return(current_dat)

  })

  # More than one ts id
  if(length(ts_id) > 1){
    # Name data frames in list
    names(content_dat) <- paste0(json_content$station_name, " (",
                                 json_content$stationparameter_name, ")")
  }else{
    content_dat <- content_dat[[1]]
  }

  return(content_dat)

}
