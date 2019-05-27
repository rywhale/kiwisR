#' Get values for time series id or list of time series ids.
#'
#' @export
#' @description Returns time series values for given time series id and date range.
#' @param hub The KiWIS database you are querying. Either one of the defaults or a URL.
#'  See \href{https://github.com/rywhale/kiwisR}{README}.
#' @param ts_id Either: a single time series id or a vector of time series ids.
#'  Time series ids can be found using the ki_timeseries_list function
#' @param start_date A date string formatted "YYYY-MM-DD". Defaults to yesterday.
#' @param end_date A date string formatted "YYYY-MM-DD". Defaults to today.
#' @return A tibble with following columns: Timestamp, Value, ts_name, Units, station_name
#' @examples
#' ki_timeseries_values(
#'   hub = "swmc",
#'   ts_id = "1125831042",
#'   start_date = "2015-12-01",
#'   end_date = "2018-01-01"
#' )
#'

ki_timeseries_values <- function(hub, ts_id, start_date, end_date) {

  # Default to past 24 hours
  if (missing(start_date) || missing(end_date)) {
    message("No start or end date provided, trying to return data for past 24 hours")
    start_date <- Sys.Date() - 1
    end_date <- Sys.Date()
  } else {
    check_date(start_date, end_date)
  }

  # Identify hub
  api_url <- check_hub(hub)

  if (missing(ts_id)) {
    stop("Please enter a valid ts_id.")
  } else {
    # Account for multiple ts_ids
    ts_id_string <- paste(ts_id, collapse = ",")
  }

  # Metadata to return
  ts_meta <- paste(c(
    "ts_unitname",
    "ts_unitsymbol",
    "ts_name",
    "stationparameter_name",
    "station_name"
  ),
  collapse = ","
  )

  api_query <- list(
    service = "kisters",
    type = "queryServices",
    request = "getTimeseriesValues",
    format = "json",
    kvp = "true",
    ts_id = ts_id_string,
    from = start_date,
    to = end_date,
    metadata = "true",
    md_returnfields = ts_meta
  )

  # Send request
  raw <- tryCatch({
    httr::GET(
      url = api_url,
      query = api_query,
      httr::timeout(60)
    )
  }, error = function(e) {
    return(e)
  })

  # Check for query error
  if(sum(grepl("error", class(raw)))){
    stop("Query returned error: ", raw$message)
  }

  # Parse response
  raw_content <- httr::content(raw)

  # Check for timeout / 404
  if(grepl("Timeout", raw_content) || class(raw_content) != "list"){
    stop("Check that KiWIS hub is accessible via a web browser.")
  }

  # Parse text
  json_content <- jsonlite::fromJSON(httr::content(raw, "text"))

  if (length(names(json_content)) == 3) {
    stop(json_content$message)
  }
  if ("rows" %in% names(json_content)) {
    num_rows <- sum(as.numeric(json_content$rows))
    if (num_rows == 0) {
      stop("No data available for selected ts_id(s).")
    }
  }

  # Grab data for each ts id
  content_dat <- lapply(1:length(json_content$data), function(x) {

    # Convert to data frame
    current_dat <- tibble::as_tibble(json_content$data[[x]], .name_repair = "minimal")

    if (nrow(current_dat) >= 1) {
      # Add column names
      colnames(current_dat) <- c(
        "Timestamp",
        "Value"
      )

      current_dat <- dplyr::mutate(
        current_dat,
        Timestamp = lubridate::ymd_hms(current_dat$Timestamp),
        Value = as.numeric(current_dat$Value),
        ts_name = json_content$ts_name[[x]],
        Units = json_content$ts_unitsymbol[[x]],
        station_name = json_content$station_name[[x]]
      )
    }
    current_dat
  })


  content_dat <- dplyr::bind_rows(content_dat)

  return(content_dat)
}
