#' Hub selection handling
#' @noRd
#' @description Checks input against defaults
#' @keywords internal
check_hub <- function(hub) {
  # Identify default hubs
  default_hubs <- list(
    "kisters" = "http://kiwis.kisters.de/KiWIS/KiWIS?",
    "swmc" = "https://www.swmc.mnr.gov.on.ca/KiWIS/KiWIS?",
    "quinte" = "http://waterdata.quinteconservation.ca/KiWIS/KiWIS?"
  )

  # Hub selection
  if (!is.character(hub) | nchar(hub) == 0) {
    stop(
      "`hub` argument must be a character- either a URL or one of the following defaults: ",
      paste(c("", names(default_hubs)), collapse = "\n"),
      "See https://github.com/rywhale/kiwisR for more information."
      )
  }

  if (!hub %in% names(default_hubs)) {
    # Non-default KiWIS URL
    api_url <- hub
  }else{
    api_url <- default_hubs[[which(names(default_hubs) == hub)]]
  }

  return(api_url)
}

#' User provided date string checking
#' @noRd
#' @description Checks user provided date strings to ensure they can be cast to yyyy-mm-dd
#' @keywords internal
check_date <- function(start_date, end_date){

  start_status <- tryCatch({
    lubridate::ymd(start_date)
  }, warning = function(w){
    stop("start_date must be in yyyy-mm-dd format", call. = FALSE)
  })

  end_status <- tryCatch({
    lubridate::ymd(end_date)
  }, warning = function(w){
    stop("end_date must be in yyyy-mm-dd format", call. = FALSE)
  })

  if(lubridate::ymd(start_date) > lubridate::ymd(end_date)){
    stop("start_date is greater than end_date")
  }

}

#' Checking if internet connection available
#' @noRd
#' @description Checks if connection to internet can be made. Useful to check before running API-related tests
#' @author Sam Albers
#' @keywords internal
has_internet <- function(){
  z <- try(suppressWarnings(
    readLines('https://www.google.ca', n = 1)
    ), silent = TRUE)
  !inherits(z, "try-error")
}

#' Checking if example hub is live before running tests
#' @noRd
#' @description Checks if connection to KiWIS example hub can be made.
#' @keywords internal
exp_live <- function(exp_hub){
  exp_hub_url <- paste0(
    check_hub(exp_hub),
    "datasource=0&service=kisters&type=queryServices&request=getstationlist&format=json"
  )
  z <- try(
    suppressWarnings(httr::GET(exp_hub_url, httr::timeout(5))),
    silent = TRUE
  )
  !inherits(z, "try-error") & !length(names(httr::content(z)))
}
