## Deal with hub selection
#' @noRd
#' @keywords internal
#' @export

check_hub <- function(hub) {
  # Identify default hubs
  default_hubs <- c(
    "swmc",
    "grand",
    "quinte",
    "creditvalley"
  )
  # Hub selection
  if (!is.character(hub)) {
    stop("Hub should be a URL.")
  }
  if (hub == "swmc") {
    api_url <- "https://www.swmc.mnr.gov.on.ca/KiWIS/KiWIS?"
  }
  if (hub == "grand") {
    api_url <- "http://kiwis.grandriver.ca/KiWIS/KiWIS?"
  }
  if (hub == "quinte") {
    api_url <- "http://waterdata.quinteconservation.ca/KiWIS/KiWIS?"
  }
  if (hub == "creditvalley") {
    api_url <- "https://waterinfo.creditvalleyca.ca:8443/KiWIS/KiWIS?"
  }
  if (!hub %in% default_hubs) {
    message("You are using non-default hub.")
    # Non-default KiWIS URL
    api_url <- hub
  }

  return(api_url)
}
