#' getTimeseriesValues
#'
#' @author Ryan Whaley
#' @return Dataframe containing values for the specified date range and timeseries.
#' @param hub The location of the API service. Default options include 'swmc', 'grand' and 'quinte'. See the README for adding additional hubs.
#' @param ts_id Timeseries identifier. Can be found using getTimeseriesList().
#' @param from The start of the date range. Defaults to yesterday.
#' @param to The end of the date range. Defaults to today.
#' @import lubridate
#' @export
#' @examples
#' \dontrun{
#' ts.dat <- getTimeseriesValues(ts_id = "948603042")
#'}
#'

getTimeseriesValues <- function(hub,
                                ts.id,
                                from = NA,
                                to = NA,
                                date.format = "yyyy-MM-dd HH:mm:ss") {

  # Default date range to past 24-hours
  if(is.na(from) & is.na(to)){
    from <- today() - 1
    to <- today()
  }

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
  if(!hub %in% default_hubs){
    if(!http_error(hub)){
      base.url <- hub
    }else{
      return("HTTP error encountered while trying to reach user-defined hub.")
    }
  }

  # Query url
  url <- paste0(base.url,
                "KiWIS/KiWIS?service=kisters&",
                "type=queryServices",
                "&request=getTimeseriesValues",
                "&datasource=0",
                "&format=csv",
                "&ts_id=", ts.id,
                "&from=", from,
                "&to=", to,
                "&dateformat=", date.format,
                "&metadata=true",
                "&md_returnfields=ts_unitname")

  # Try to read file
  status <- suppressWarnings(try(read.csv(url), silent = T))

  # Check for status error
  if(class(status) != "try-error"){
    # Read file
    ts.dat <- suppressWarnings(read.csv(url,
                                        sep = ";",
                                        stringsAsFactors = F,
                                        header = FALSE))

    # Get parameters units
    ts_unit <- ts.dat[1,2]

    # Column names
    names(ts.dat) <- c("Timestamp", paste0("Value(", ts_unit, ")"))

    # Cull metadata rows
    ts.dat <- ts.dat[-c(1,2,3),]

      # Check if table has data
      if(!nrow(ts.dat) == 0){

      # Convert Timestamps to POSIXct
      ts.dat$Timestamp <- ymd_hms(ts.dat$Timestamp)

      # Reset row numbers
      row.names(ts.dat) <- NULL

      return(ts.dat)

    }else{
      return("No values available for that selection.")
    }

  }else{
    # Error message
    return("The ts_id or date range is invalid.")
  }
}
