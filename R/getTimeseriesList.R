#' getTimeseriesList
#'
#' @author Ryan Whaley
#' @return Dataframe containing a list of timeseries for the chosen station.
#' @param station_id A station identifier code. Can be found with getStationList()
#' @param hub The location of the API service. Default options include 'swmc', 'grand' and 'quinte'. See the README for adding additional hubs.
#' @import dplyr
#' @export
#' @examples
#' \dontrun{
#'  stn.ts <- getTimeseriesList("133535")
#'  }
#'


getTimeseriesList <- function(hub, station.id){
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

  # Query url
  url <- paste0(base.url,
                "/KiWIS/KiWIS?service=kisters&",
                "type=queryServices",
                "&request=getTimeseriesList",
                "&datasource=0",
                "&format=csv",
                "&station_id=", station.id)
  
  # Try to read file
  status <- suppressWarnings(try(read.csv(url, row.names = NULL), silent = T))

  # Check for status error
  if(class(status) != "try-error"){
    # Read file
    suppressWarnings(ts.dat <- read.csv(url,
                                        sep = ";",
                                        stringsAsFactors = F,
                                        header = FALSE,
                                        row.names = NULL))

    # Column names
    names(ts.dat) <- ts.dat[1,]

    # Get rid of header row and subset
    ts.dat <- ts.dat[-1, ] %>%
      select('ts_name', 'ts_id')
    
    row.names(ts.dat) <- NULL
    
    return(ts.dat)

  }else{
    # Error message
    return("The station_id is invalid.")
  }
}
