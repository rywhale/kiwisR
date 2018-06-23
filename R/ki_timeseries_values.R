#' Get values for time series id or list of time series ids.
#'
#' @export
#' @param hub The KiWIS database you are querying.
#' Default options are 'swmc', 'grand', 'quinte' and 'creditvalley'.
#' See README for more details.
#' @param ts_id Either: a single time series id or a vector of time series ids.
#' Time series ids
#' can be found using the ki_timeseries_list function
#' @param start_date A date string formatted "YYYY-MM-DD".
#' Defaults to yesterday. All timestamps are UTC.
#' @param end_date A date string formatted "YYYY-MM-DD".
#' Defaults to today. All timestamps are UTC.
#' @return Either: a single tibble or a list of tibbles
#' (each named according to station and timeseries)
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
  api_url <- check_hub(hub)

  if(missing(ts_id)){
    return("Please enter a valid ts_id.")
  }else{
    # Account for multiple ts_ids
    ts_id_string <- paste(ts_id, collapse = ",")
  }

  # Metadata to return
  ts_meta <- paste(c("ts_unitname",
                     "ts_unitsymbol",
                     "stationparameter_name",
                     "station_name"),
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
  raw <- httr::GET(url = api_url,
                   query = api_query)

  # Check for 404
  if(raw$status_code == 404){
    stop("Selected hub unavailable!")
  }

  # Parse to JSON
  json_content <- jsonlite::fromJSON(httr::content(raw, "text"))

  if(length(names(json_content)) == 3){
    return(json_content$message)
  }
  if("rows" %in% names(json_content)){
    num_rows <- sum(as.numeric(json_content$rows))
    if(num_rows == 0){
      stop("No data available for selected ts_id.")
    }
  }

  # Grab data for each ts id
  content_dat <- lapply(seq(length(ts_id)), function(x){

    # Convert to data frame
    current_dat <- tibble::as_tibble(json_content$data[[x]])

    if(nrow(current_dat) >= 1){
      # Add column names
      names(current_dat) <- c("Timestamp",
                              json_content$stationparameter_name[[x]])

      # Create units column
      current_dat$Units <- rep(json_content$ts_unitsymbol[[x]],
                               nrow(current_dat))

      # Cast date column
      current_dat$Timestamp <- lubridate::ymd_hms(current_dat$Timestamp)

      # Cast values column
      current_dat[[2]] <- as.numeric(current_dat[[2]])
    }
    return(current_dat)
  })

  # Name data frames in list
  if(sum(sapply(content_dat, tibble::is.tibble)) == length(content_dat)){
    names(content_dat) <- paste0(json_content$station_name, " (",
                                 json_content$stationparameter_name, ")")
  }

  # One time series returned
  if(length(content_dat) > 1){
    # Get rid of empty list items
    content_dat <- content_dat[!is.null(content_dat)]
  }

  # One ts_id
  if(length(ts_id) == 1){
    content_dat <- content_dat[[1]]
  }

  return(content_dat)

}
