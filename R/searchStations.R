#' searchStations()
#'
#' @author Ryan Whaley
#' @description Returns a dataframe of stations with names matching the search string.
#' @param  search.trm String to search station names for. Can use * as wildcard.
#' @return Dataframe containing station information for stations with names matching search.trm
#' @export
#' @examples
#' \dontrun{
#' # All stations
#' station.A <- searchStations("A*")
#' head(station.A)
#'       station_name station_id station_latitude station_longitude
#'  1    ABBOTSFORD A     133535      49.03307961      -122.3666708
#'  2         ALERT A     132255      82.51666993       -62.2830803
#'  3      ALEXANDRIA     147654      45.31666964      -74.61666967
#'
#'}

searchStations <- function(hub, search.trm){
  # Common strings for culling bogus stations
  garbage <- c("^#", "^--", "testing",
               "^Template\\s", "\\sTEST$",
               "\\sTEMP$", "\\stest\\s")

  # Hub identification
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

  # Query url
  url <- paste0(base.url,
                "/KiWIS/KiWIS?service=kisters",
                "&type=queryServices",
                "&request=getStationList",
                "&datasource=0",
                "&format=csv",
                "&station_name=", search.trm)

  # Try to read file
  status <- suppressWarnings(try(read.csv(url), silent = T))
  if(class(status) != "try-error"){
    # Read file
    stn.dat <- suppressWarnings(read.csv(url,
                                        sep = ";",
                                        stringsAsFactors = F,
                                        header = FALSE))

    # Column names
    names(stn.dat) <- stn.dat[1,]

    # Get rid of header row and station_no column
    stn.dat <- stn.dat[-1, ] %>%
      within(rm("station_no"))

    # Row names
    row.names(stn.dat) <- NULL

    return(stn.dat)

  }else{
    # Error message
    return(paste0("No results matching ",
                  search.trm))
  }
}
