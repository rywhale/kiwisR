#' Get list of available groups
#'
#' @export
#' @description Returns a tibble containing metadata available groups. This can be used to
#' further filter down other queries like `ki_station_list`
#' @param hub The KiWIS database you are querying. Either one of the defaults or a URL.
#'  See \href{https://github.com/rywhale/kiwisR}{README}.
#' @return A tibble with three columns: group_id, group_name and group_type
#' @examples
#' \dontrun{
#' ki_group_list(hub = 'swmc')
#' }
#'

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
      query = api_query,
      httr::timeout(15)
    )}, error = function(e){
      return(e)
    })

  check_ki_response(raw)

  # Parse response
  raw_content <- httr::content(raw, "text")

  # Parse text
  json_content <- jsonlite::fromJSON(raw_content)

  content_dat <- tibble::as_tibble(
    json_content[2:nrow(json_content), ],
    .name_repair = "minimal"
    )

  names(content_dat) <- json_content[1, ]

  return(content_dat)
}
