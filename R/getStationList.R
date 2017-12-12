#' getStationList
#'
#' @author Ryan Whaley
#' @description Returns a dataframe with station information. Can limit results with bounding box.
#' @param bounding.box (Optional) A comma separated string in the following format: min_x, min_y, max_x, max_y
#' @param hub The location of the API service. Default options include 'swmc', 'grand' and 'quinte'. See the README for adding additional hubs.
#' @return Dataframe containing station information to be passed to other functions (e.g. getTimeseriesList)
#' @import dplyr httr
#' @export
#' @examples
#' \dontrun{
#' # All stations
#' station.dat <- getStationList()
#'
#' # With bbox
#' station.dat <- getStationList(bounding.box = "-81.0269,43.4583,-79.0025,44.8189")
#'}

getStationList <- function(hub, bounding.box = NA){
  # Common strings for culling bogus stations
  garbage <- c("^#", "^--", "testing",
               "^Template\\s", "\\sTEST$",
               "\\sTEMP$", "\\stest\\s")
  # Identify hub
  default_hubs <- c("swmc",
                    "grand",
                    "quinte")
  if(nchar(hub) == 0 ){
    return("No hub selected! Please select 'swmc', 'grand', 'quinte' or input your own URL.")
  }
  if(hub=="swmc"){
    base.url<-"http://204.41.16.133/"}
  if(hub=="grand"){
    base.url<-"http://kiwis.grandriver.ca/"
  }
  if(hub=="quinte"){
    base.url<-"http://waterdata.quinteconservation.ca/"
  }

  # Custom hub
  if(! hub %in% default_hubs){
    if(!http_error(hub)){
      base.url <- hub
    }else{
      return("HTTP error encountered while trying to reach user-defined hub.")
    }
  }

  if(is.na(bounding.box)){
    # Query url
    url <- paste0(base.url,
                  "KiWIS/KiWIS?service=kisters",
                  "&type=queryServices",
                  "&request=getStationList",
                  "&datasource=0",
                  "&format=csv")

    # Read and filter
    stn.dat <- read.csv(url, sep = ";", stringsAsFactors = F) %>%
      filter(!grepl(paste(garbage, collapse = "|"), station_name)) %>%
      within(rm("station_no"))

    return(stn.dat)

  }else{

    # Check for bounding.box formatting
    if(!is.character(bounding.box)){
      return(paste0("Bounding box should be a comma separated string ",
                    "in the following format: min_x, min_y, max_x, max_y"))
    }else{

      # Query url (with bounding.box)
      url <- paste0(base.url,
                    "KiWIS/KiWIS?service=kisters",
                    "&type=queryServices",
                    "&request=getStationList",
                    "&datasource=0",
                    "&format=csv",
                    "&bbox=", bounding.box)

      # Read and filter
      station.dat <- read.csv(url, sep = ";") %>%
        filter(!grepl(paste(garbage, collapse = "|"), station_name)) %>%
        within(rm("station_no"))

      return(station.dat)
    }
  }
}

