#' Get list of available groups
#'
#' @export
#' @description Returns a tibble containing available groups. Allows users to query
#' ki_station_list for grouped stations.
#' @param hub The KiWIS database you are querying.
#' Default options are 'swmc', 'grand', 'quinte' and 'creditvalley'.
#' See README for more details.
#' @return A tibble with three columns: group_id, group_name and group_type
#' @examples
#' \dontrun{
#' ki_group_list(hub = 'swmc')
#' }

ki_group_list <- function(hub) {

  # Identify hub
  api_url <- check_hub(hub)

  api_query <- list(
    service = "kisters",
    type = "queryServices",
    request = "getGroupList",
    format = "json",
    kvp = "true"
  )

  # Send request
  raw <- tryCatch({
    httr::GET(
      url = api_url,
      query = api_query
    )}, error = function(e){
      return(e)
    })

  if(sum(grepl("error", class(raw)))){
    stop("Query returned error: ", raw$message)
  }

  # Check for 404
  if (raw$status_code == 404) {
    stop(
      "404 returned by selected hub.",
      "Check that you are able to access it via a web browser."
    )
  }

  # Parse to JSON
  json_content <- jsonlite::fromJSON(httr::content(raw, "text"))

  content_dat <- tibble::as_tibble(json_content[2:nrow(json_content), ])

  names(content_dat) <- json_content[1, ]

  return(content_dat)
}
