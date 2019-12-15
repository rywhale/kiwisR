context("Testing station metadata retrieval and checks")

test_that("ki_station_list throws error when no hub specified", {
  expect_error(ki_station_list(hub = ""))
})

test_that("ki_station_list throws error if provided hub in not reachable", {
  expect_error(ki_station_list(hub = "https://xxxxx"))
})

test_that("ki_station_list should return a tibble", {
  skip_if_net_down()
  skip_if_exp_down()

  stns <- ki_station_list(hub = example_hub)
  expect_type(stns, "list")
})

test_that("ki_station_list accepts search_term filters", {
  skip_if_net_down()
  skip_if_exp_down()

  stn_filt <- ki_station_list(hub = example_hub, search_term = "A*")
  stn_empty <- ki_station_list(hub = example_hub, search_term = "")

  expect_type(stn_filt, "list")
  expect_type(stn_empty, "list")
  expect(
    nrow(stn_empty) == 0,
    failure_message = "Providing empty search term should return no data"
    )
})

test_that("ki_station_list accepts bbox filter (vector or character)", {
  skip_if_net_down()
  skip_if_exp_down()

  stn_bbox_str <- "-131.7,-5.4,135.8,75.8"
  stn_bbox_v <- c("-131.7","-5.4","135.8","75.8")
  stn_bbox_filt <- ki_station_list(hub = example_hub, bounding_box = stn_bbox_str)
  stn_bbox_filt2 <- ki_station_list(hub = example_hub, bounding_box = stn_bbox_v)

  expect_type(stn_bbox_filt, "list")
  expect_type(stn_bbox_filt2, "list")
  expect_equal(stn_bbox_filt, stn_bbox_filt2)
})

test_that("ki_station_list accepts group_id filter", {
  skip_if_net_down()
  skip_if_exp_down()

  #test_group_id <- test_group_id
  stns_group <- ki_station_list(hub = example_hub, group_id = test_group_id)
  expect_type(stns_group, "list")
})

test_that("ki_station_list accepts custom return fields (vector or string)", {
  skip_if_net_down()
  skip_if_exp_down()

  cust_ret_str <- "station_name,station_id,station_no"
  cust_ret_v <- c("station_name", "station_id", "station_no")

  fake_ret_str <- "metadatathatdoesntactuallexist"

  stn_cust_retr <- ki_station_list(hub = example_hub, return_fields = cust_ret_str)
  stn_cust_retr2 <- ki_station_list(hub = example_hub, return_fields = cust_ret_v)

  expect_type(stn_cust_retr, "list")
  expect_type(stn_cust_retr2, "list")
  expect_equal(stn_cust_retr, stn_cust_retr2)

  expect_error(ki_station_list(hub = example_hub, return_fields = fake_ret_str))
})
