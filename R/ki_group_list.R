#' Get list of available groups
#'
#' @export
#' @description Returns a tibble containing metadata available groups. This can be used to
#' further filter down other queries like `ki_station_list`
#' @param hub The KiWIS database you are querying. Either one of the defaults or a URL.
#'  See \href{https://github.com/rywhale/kiwisR}{README}.
#' @return A tibble with three columns: group_id, group_name and group_type
#' @examples
#' ki_group_list(hub = 'swmc')
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

  # Check for timeout / 404
  if(grepl("Timeout", raw)){
    stop("Check that KiWIS hub is accessible via a web browser.")
  }else if(raw$status_code == 404) {
    stop(
      "404 returned by selected hub.",
      "Check that you are able to access it via a web browser."
    )
  }

  # Check for query error
  if(sum(grepl("error", class(raw)))){
    stop("Query returned error: ", raw$message)
  }

  # Parse to JSON
  json_content <- jsonlite::fromJSON(httr::content(raw, "text"))

  content_dat <- tibble::as_tibble(json_content[2:nrow(json_content), ], .name_repair = "minimal")

  colnames(content_dat) <- json_content[1, ]

  return(content_dat)
}
