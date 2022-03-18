#' Get tibble containing station information.
#'
#' @export
#' @description Returns all available stations by default and allows for search terms and other filters.
#' @param hub The KiWIS database you are querying. Either one of the defaults or a URL.
#'  See \href{https://github.com/rywhale/kiwisR}{README}.
#' @param search_term (Optional) A station name to search for. Supports the use of * as a wildcard. Case doesn't matter.
#' @param bounding_box (Optional) A bounding box to search within for stations. Should be a vector or comma separated string.
#' @param group_id (Optional) A station group id (see ki_group_list).
#' with the following format: (min_x, min_y, max_x, max_y).
#' @param return_fields (Optional) Specific fields to return. Consult your KiWIS hub services documentation for available options.
#' Should be a comma separate string or a vector.
#' @param datasource (Optional) The data source to be used, defaults to 0.
#' @return Tibble containing station metadata.
#' @examples
#' \dontrun{
#' ki_station_list(hub = "swmc")
#' ki_station_list(hub = "swmc", search_term = "A*")
#' ki_station_list(hub = "swmc", bounding_box = "-131.7,-5.4,135.8,75.8")
#' ki_station_list(hub = "swmc", group_id = "518247")
#' }
#'
ki_station_list <- function(hub, search_term, bounding_box, group_id, return_fields, datasource=0) {
  # Common strings for culling bogus stations
  garbage <- c(
    "^#", "^--", "testing",
    "^Template\\s", "\\sTEST$",
    "\\sTEMP$", "\\stest\\s"
  )

  # Account for user-provided return fields
  if (missing(return_fields)) {
    return_fields <- "station_name,station_no,station_id,station_latitude,station_longitude"
  } else {
    if (!inherits(return_fields, "character")) {
      stop(
        "User supplied return_fields must be comma separated string or vector of strings"
      )
    }
  }

  # Identify hub
  api_url <- check_hub(hub)

  # Base query
  api_query <- list(
    service = "kisters",
    datasource = datasource,
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
  raw <- tryCatch(
    {
      httr::GET(
        url = api_url,
        query = api_query,
        httr::timeout(15)
      )
    },
    error = function(e) {
      return(e)
    }
  )

  check_ki_response(raw)

  # Parse response
  raw_content <- httr::content(raw, "text")

  # Parse text
  json_content <- jsonlite::fromJSON(raw_content)

  # Check for empty search results
  if (inherits(json_content, "character")) {
    return("No matches for search term.")
  }

  # Convert to tibble
  content_dat <- tibble::as_tibble(
    x = json_content,
    .name_repair = "minimal"
  )[-1, ]

  # Add column names
  names(content_dat) <- json_content[1, ]

  # Remove garbage stations
  if ("station_name" %in% names(content_dat)) {
    content_dat <- content_dat[!grepl(
      paste(garbage, collapse = "|"),
      content_dat$station_name
    ), ]
  }

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

  return(content_dat)
}
