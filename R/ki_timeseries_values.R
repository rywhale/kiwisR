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
#' @param return_fields (Optional) Specific fields to return. Consult your KiWIS hub services documentation for available options.
#' Should be a comma separate string or a vector.
#' @return A tibble with following columns by default: Timestamp, Value, ts_name, Units, station_name
#' @examples
#' \dontrun{
#' ki_timeseries_values(
#'   hub = "swmc",
#'   ts_id = "1125831042",
#'   start_date = "2015-12-01",
#'   end_date = "2018-01-01"
#' )
#' }
#'
ki_timeseries_values <- function(hub, ts_id, start_date, end_date, return_fields) {

  # Default to past 24 hours
  if (missing(start_date) || missing(end_date)) {
    message("No start or end date provided, trying to return data for past 24 hours")
    start_date <- Sys.Date() - 1
    end_date <- Sys.Date()
  } else {
    check_date(start_date, end_date)
  }

  # Account for user-provided return fields
  if (missing(return_fields)) {
    return_fields <- "Timestamp,Value"
  } else {
    if (!is.vector(return_fields) & !is.character(return_fields)) {
      stop(
        "User supplied return_fields must be comma separate string or vector of fields."
      )
    }
    return_fields <- c("Timestamp", "Value", return_fields)
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
    "ts_id",
    "stationparameter_name",
    "station_name",
    "station_id"
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
    md_returnfields = ts_meta,
    returnfields = paste(
      return_fields,
      collapse = ","
    )
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
  if (sum(grepl("error", class(raw)))) {
    stop("Query returned error: ", raw$message)
  }

  # Parse response
  raw_content <- httr::content(raw)

  # Check for timeout / 404
  if (class(raw) != "response" | class(raw_content) != "list") {
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

  ts_cols <- unlist(strsplit(json_content$columns[[1]], ","))


  content_dat <- purrr::map_df(
    1:length(json_content$data),
    function(ts_chunk) {
      ts_data <- tibble::as_tibble(
        json_content$data[[ts_chunk]],
        .name_repair = "minimal",
      )

      colnames(ts_data) <- ts_cols

      dplyr::mutate(
        ts_data,
        Timestamp = lubridate::ymd_hms(ts_data$Timestamp),
        Value = as.numeric(ts_data$Value),
        ts_name = json_content$ts_name[[ts_chunk]],
        ts_id = json_content$ts_id[[ts_chunk]],
        Units = json_content$ts_unitsymbol[[ts_chunk]],
        station_name = json_content$station_name[[ts_chunk]],
        station_id = json_content$station_id[[ts_chunk]]
      )
    }
  )

  return(content_dat)
}
