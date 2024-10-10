#' Get list of available time series for station or
#' list of stations.
#'
#' @export
#' @param hub The KiWIS database you are querying. Either one of the defaults or a URL.
#'  See \href{https://github.com/rywhale/kiwisR}{README}.
#' @param station_id Either a single station id or a vector of station ids. Can be string or numeric.
#' Station ids can be found using the ki_station_list function.
#' @param ts_name (Optional) A specific time series short name to search for. Supports the use of "*" as a wildcard.
#' @param coverage (Optional) Whether or not to return period of record columns.
#' Defaults to TRUE, change to FALSE for faster queries.
#' @param group_id (Optional) A time series group id (see ki_group_list).
#' @param return_fields (Optional) Specific fields to return. Consult your KiWIS hub services documentation for available options.
#' Should be a comma separate string or a vector.
#' @param datasource (Optional) The data source to be used, defaults to 0.
#' @return A tibble containing all available time series for selected stations.
#' @examples
#' \dontrun{
#' ki_timeseries_list(hub = "swmc", station_id = "146775")
#' ki_timeseries_list(hub = "swmc", ts_name = "Vel*")
#'}
#'

ki_timeseries_list <- function(hub, station_id, ts_name, coverage = TRUE, group_id,
                               return_fields, datasource = 0) {
  # Check for no input
  if (missing(station_id) & missing(ts_name) & missing(group_id)) {
    stop("No station_id, ts_name or group_id provided.")
  }

  # Account for user-provided return fields
  if(missing(return_fields)){
    # Default
    return_fields <- "station_name,station_id,ts_id,ts_name"
  }else{
    if(!inherits(return_fields, "character")){
      stop(
        "User supplied return_fields must be comma separated string or vector of strings"
      )
    }

    # Account for user listing coverage in return_fields
    if(length(grepl("coverage", return_fields))){
      return_fields <- gsub(
        ",coverage|coverage,",
        "",
        return_fields
      )
    }
  }

  # Identify hub
  api_url <- check_hub(hub)

  api_query <- list(
    service = "kisters",
    datasource = datasource,
    type = "queryServices",
    request = "getTimeseriesList",
    format = "json",
    kvp = "true",
    returnfields = paste(
      return_fields,
      collapse = ","
      )
    )

  if (!missing(station_id)) {
    # Account for multiple station_ids
    station_id <- paste(station_id, collapse = ",")
    api_query[["station_id"]] <- station_id
  }

  if(coverage == TRUE){
    # Turn coverage columns on
    api_query[['returnfields']] <- paste0(
      api_query[['returnfields']],
      ",coverage"
    )
  }

  # Check for ts_name search
  if (!missing(ts_name)) {
    api_query[["ts_name"]] <- ts_name
  }

  # Check for group_id
  if(!missing(group_id)){
    api_query[["timeseriesgroup_id"]] <- group_id

  }

  req <- httr2::request(api_url) |>
    httr2::req_user_agent("kiwisR") |>
    httr2::req_url_query(!!!api_query)

  resp <- httr2::req_perform(req)

  httr2::resp_check_status(resp)

  # Parse JSON response
  json_content <- httr2::resp_body_json(resp, simplifyVector = TRUE)

  # Check for special case single ts return
  if(nrow(json_content) == 2){
    content_dat <- tibble::as_tibble(
      json_content,
      .name_repair = "minimal"
      )[-1, ]
  }else{
    # Convert to  tibble
    content_dat <- tibble::as_tibble(
      json_content[-1, ],
      .name_repair = "minimal"
      )
  }

  # Add column names
  names(content_dat) <- json_content[1, ]

  # Cast lat/lon columns if they exist
  content_dat <- suppressWarnings(
    dplyr::mutate_at(
      content_dat,
      dplyr::vars(
        dplyr::one_of(c("station_latitude", "station_longitude"))
      ),
      as.double
    )
  )

  # Cast coverage columns if the exist
  content_dat <- suppressWarnings(
    dplyr::mutate_at(
      content_dat,
      dplyr::vars(
        dplyr::one_of(c("from", "to"))
        ),
      lubridate::ymd_hms
    )
  )

 content_dat
}
