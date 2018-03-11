#' Get tibble containing station information.
#' Returns all available stations by default and allows for search terms.
#'
#' @param hub The KiWIS database you are querying. Default options are 'swmc', 'grand', 'quinte'. See README for more details.
#' @param search_term (Optional) A station name to search for. Supports the use of * as a wildcard.
#' @param bounding_box (Optional) A bounding box to search withhin for stations. Should be a vector or comma separated string
#' with the following format: (min_x, min_y, max_x, max_y).
#' @return Tibble containing station id, name, latitude and longitude
#' @examples
#' ki_station_list(hub = 'swmc')
#' ki_station_list(hub = 'swmc', search_term = "A*")
#' ki_station_list(hub = 'swmc', search_term = "Lake Ontario at Toronto")
#'

ki_station_list <- function(hub, search_term, bounding_box = NA){
  # Common strings for culling bogus stations
  garbage <- c("^#", "^--", "testing",
               "^Template\\s", "\\sTEST$",
               "\\sTEMP$", "\\stest\\s")

  # Identify hub
  default_hubs <- c("swmc",
                    "grand",
                    "quinte")

  # Hub selection
  if(missing(hub) | !is.character(hub)){
    return("No hub selected! Please select 'swmc', 'grand', 'quinte' or input your own URL.")
  }
  if(hub=="swmc"){
    api_url<-"http://204.41.16.133/KiWIS/KiWIS?"
  }
  if(hub=="grand"){
    api_url<-"http://kiwis.grandriver.ca/KiWIS/KiWIS?"
  }
  if(hub=="quinte"){
    api_url<-"http://waterdata.quinteconservation.ca/KiWIS/KiWIS?"
  }
  if(hub %in% default_hubs == FALSE){
    # Non-default KiWIS URL
    api_url <- hub
  }

  # Base query
  api_query <- list(service = "kisters",
                    type = "queryServices",
                    request = "getStationList",
                    format = "json",
                    kvp = "true")

  # Check for search term
  if(!missing(search_term)){
    api_query[['station_name']] <- search_term
  }

  # Check for bounding box
  if(!missing(bounding_box)){
    bounding_box <- paste(bounding_box, collapse = ",")
    api_query[['bbox']] <- bounding_box
  }

  # Send request
  raw <- httr::GET(url = api_url, query = api_query)

  # Check for 404
  if(raw$status_code == 404){
    return("Selected hub unavailable!")
  }

  # Parse text
  json_content <- jsonlite::fromJSON(httr::content(raw, "text"))

  # Convert to tibble
  content_dat <- tibble::as_tibble(json_content[-1, ])

  # Add column names
  colnames(content_dat) <- json_content[1, ]

  # Eliminate unnecessary column
  content_dat <- content_dat[, -2]

  # Remove garbage stations
  content_dat <- content_dat[!grepl(paste(garbage, collapse = "|"), content_dat$station_name), ]

  return(content_dat)
}
