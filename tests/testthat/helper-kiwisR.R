# Set example hub for testing
example_hub <- "swmc"

# Test metadata configuration
if(example_hub == "kisters"){
  test_group_id = '21219'
  test_ts_group_id = "11919"
  test_stn_id = '23438'
  test_ts_ids = c("231042", "244042")
}

if(example_hub == "swmc"){
  test_group_id = '518247'
  test_ts_group_id = "499612"
  test_stn_id = '146775'
  test_ts_ids = c("1125831042","908195042")
}

# Skip if no internet connection
skip_if_net_down <- function(){
  if(has_internet()){
    return()
  }
  testthat::skip("No internet")
}

# Skip if unable to connect to example KiWIS server
skip_if_exp_down <- function(exp = example_hub){
  if(exp_live(exp_hub = exp)){
    return()
  }
  testthat::skip("Example KiWIS server offline.")
}

