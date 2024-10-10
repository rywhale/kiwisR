#' Get list of available groups
#'
#' @export
#' @description Returns a tibble containing metadata available groups. This can be used to
#' further filter down other queries like `ki_station_list`.
#' @param hub The KiWIS database you are querying. Either one of the defaults or a URL.
#'  See \href{https://github.com/rywhale/kiwisR}{README}.
#' @param datasource (Optional) The data source to be used, defaults to 0.
#' @return A tibble with three columns: group_id, group_name and group_type.
#' @examples
#' \dontrun{
#' ki_group_list(hub = 'swmc')
#' }
#'

ki_group_list <- function(hub, datasource = 0) {

  # Identify hub
  api_url <- check_hub(hub)

  api_query <- list(
    service = "kisters",
    datasource = datasource,
    type = "queryServices",
    request = "getGroupList",
    format = "json",
    kvp = "true"
  )

  req <- httr2::request(api_url) |>
    httr2::req_user_agent("kiwisR") |>
    httr2::req_url_query(!!!api_query)

  resp <- httr2::req_perform(req)

  httr2::resp_check_status(resp)

  # Parse JSON response
  json_content <- httr2::resp_body_json(resp, simplifyVector = TRUE)

  # Convert to tibble
  content_dat <- tibble::as_tibble(
    json_content[2:nrow(json_content), ],
    .name_repair = "minimal"
    )

  names(content_dat) <- json_content[1, ]

  content_dat
}
