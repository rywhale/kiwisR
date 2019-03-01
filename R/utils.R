## Deal with hub selection
#' @noRd
#' @description Function to handle default hubs. Not intended for external use.
#' @keywords internal

check_hub <- function(hub) {
  # Identify default hubs
  default_hubs <- c(
    "kisters",
    "swmc",
    "quinte"
  )
  # Hub selection
  if (!is.character(hub)) {
    stop("Hub should be a URL.")
  }
  if(hub == "kisters"){
    api_url <- "http://kiwis.kisters.de/KiWIS/KiWIS?"
  }
  if (hub == "swmc") {
    api_url <- "https://www.swmc.mnr.gov.on.ca/KiWIS/KiWIS?"
  }
  if (hub == "quinte") {
    api_url <- "http://waterdata.quinteconservation.ca/KiWIS/KiWIS?"
  }
  if (!hub %in% default_hubs) {
    # Non-default KiWIS URL
    api_url <- hub
  }

  # Check if server returns error
  server_status <- httr::http_status(
    httr::GET(
      paste0(
        api_url, "datasource=0&service=kisters&type=queryServices&request=getrequestinfo"
        )
      )
  )

  if(server_status$category != "Success"){
    stop("Hub server returned error: ", server_status$message)
  }else{
    return(api_url)
  }
}
