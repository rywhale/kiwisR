#' Get tibble containing station information.
#'
#' @export
#' @description Returns all available stations by default and allows for search terms.
#' @param hub The KiWIS database you are querying. Default options are 'swmc', 'grand', 'quinte' and 'creditvalley'.
#' See README for more details.
#' @param search_term (Optional) A station name to search for. Supports the use of * as a wildcard. Case doesn't matter.
#' @param bounding_box (Optional) A bounding box to search withhin for stations. Should be a vector or comma separated string
#' @param group_id (Optional) A station group id (see ki_group_list).
#' with the following format: (min_x, min_y, max_x, max_y).
#' @param return_fields (Optional) Specific fields to return. Consult your KiWIS hub services documentation for available options.
#' Should be a comma separate string or a vector.
#' @return Tibble containing station id, name, latitude and longitude
#' @examples
#' ki_station_list(hub = 'swmc')
#' ki_station_list(hub = 'swmc', search_term = "A*")
#' ki_station_list(hub = 'swmc', search_term = "Lake Ontario at Toronto")
#' ki_station_list(hub = 'swmc', group_id = '169270')

ki_station_list <- function(hub, search_term, bounding_box, group_id, return_fields) {
  # Common strings for culling bogus stations
  garbage <- c(
    "^#", "^--", "testing",
    "^Template\\s", "\\sTEST$",
    "\\sTEMP$", "\\stest\\s"
  )

  # Account for user-provided return fields
  if(missing(return_fields)){
    return_fields <- "station_name,station_no,station_id,station_latitude,station_longitude"
  }else{
    if(!is.vector(return_fields) & !is.character(return_fields)){
      stop(
        "User supplied return_fields must be comma separate string or vector of fields."
        )
    }
  }

  # Identify hub
  api_url <- check_hub(hub)

  # Base query
  api_query <- list(
    service = "kisters",
    type = "queryServices",
    request = "getStationList",
    format = "json",
    kvp = "true",
    returnfields = paste(
      return_fields,
      collapse = ","
    )
  )

  # Check for search term
  if (!missing(search_term)) {
    search_term <- paste(search_term,
      toupper(search_term),
      tolower(search_term),
      sep = ","
    )
    api_query[["station_name"]] <- search_term
  }

  # Check for bounding box
  if (!missing(bounding_box)) {
    bounding_box <- paste(bounding_box, collapse = ",")
    api_query[["bbox"]] <- bounding_box
  }

  # Check for group_id
  if (!missing(group_id)) {
    api_query[["stationgroup_id"]] <- group_id
  }

  # Send request
  raw <- tryCatch({
    httr::GET(
      url = api_url,
      query = api_query
    )}, error = function(e){
    return(e)
  })

  if(sum(grepl("error", raw))){
    stop("Query returned error.")
  }

  # Check for 404
  if (raw$status_code == 404) {
    stop(
      "404 returned by selected hub.",
      "Check that you are able to access it via a web browser."
      )
  }

  # Parse text
  json_content <- jsonlite::fromJSON(httr::content(raw, "text"))

  # Check for empty search results
  if (class(json_content) == "character") {
    return("No matches for search term.")
  }

  # Convert to tibble
  content_dat <- tibble::as_tibble(json_content)[-1, ]

  # Add column names
  colnames(content_dat) <- json_content[1, ]

  # Remove garbage stations
  content_dat <- content_dat[!grepl(
    paste(garbage, collapse = "|"),
    content_dat$station_name
  ), ]

  # Cast lat/lon columns
  content_dat[which(grepl("lat|lon", names(content_dat)))] <- sapply(
    content_dat[which(grepl("lat|lon", names(content_dat)))],
    as.double)

  return(content_dat)
}
