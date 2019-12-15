context("Testing time series metadata retrieval and checks")

test_that("ki_timeseries_list throws error when no hub specified", {
  skip_if_net_down()
  skip_if_exp_down()

  expect_error(ki_timeseries_list(hub = "", station_id = "12345"))
})

test_that("ki_timeseries_list throws error if provided hub in not reachable", {
  skip_if_net_down()
  skip_if_exp_down()

  expect_error(ki_timeseries_list(hub = "https://xxxx", ts_name = "A*"))
})

test_that("ki_timeseries_list throws error when no station_id, group_id or ts_name provided", {
  skip_if_net_down()
  skip_if_exp_down()

  expect_error(ki_timeseries_list(hub = example_hub))
  expect_error(ki_timeseries_list(hub = example_hub, station_id = ""))
  expect_error(ki_timeseries_list(hub = example_hub, ts_name = ""))
  expect_error(ki_timeseries_list(hub = example_hub, group_id = ""))
})

test_that("ki_timeseries_list accepts station_id for retrieving metadata", {
  skip_if_net_down()
  skip_if_exp_down()

  ts_meta <- ki_timeseries_list(hub = example_hub, station_id = test_stn_id)

  expect_type(ts_meta, "list")
})

test_that("ki_timeseries_list accepts ts_name for retrieving metadata", {
  skip_if_net_down()
  skip_if_exp_down()

  ts_meta <- ki_timeseries_list(hub = example_hub, ts_name = "Vel*")

  expect_type(ts_meta, "list")
})

test_that("ki_timeseries_list accepts group_id for retrieving metadata", {
  skip_if_net_down()
  skip_if_exp_down()

  ts_meta <- ki_timeseries_list(hub = example_hub, group_id = test_ts_group_id)

  expect_type(ts_meta, "list")
})

test_that("ki_timeseries_list returns coverage columns by default", {
  skip_if_net_down()
  skip_if_exp_down()

  ts_meta <- ki_timeseries_list(hub = example_hub, station_id = test_stn_id)
  expect(
    sum(c("from", "to") %in% names(ts_meta)) == 2,
    failure_message = "Timeseries metadata doesn't contain expected columns"
  )
})

test_that("ki_timeseries_list allows for turning coverage off increase query speed", {
  skip_if_net_down()
  skip_if_exp_down()

  ts_meta <- ki_timeseries_list(hub = example_hub, station_id = test_stn_id, coverage = FALSE)
  expect(
    sum(c("from", "to") %in% names(ts_meta)) == 0,
    failure_message = "Timeseries metadata doesn't contain expected columns"
  )
})

test_that("ki_timeseries_list allows for custom return fields (vector or string)", {
  skip_if_net_down()
  skip_if_exp_down()

  cust_ret_str <- "station_name,ts_name,ts_id"
  cust_ret_v <- c("station_name", "ts_name", "ts_id")

  fake_ret_str <- "metadatathatdoesntactuallyexist"

  stn_cust_retr <- ki_timeseries_list(
    hub = example_hub,
    station_id = test_stn_id,
    return_fields = cust_ret_str
  )
  stn_cust_retr2 <- ki_timeseries_list(
    hub = example_hub,
    station_id = test_stn_id,
    return_fields = cust_ret_v
  )

  expect_type(stn_cust_retr, "list")
  expect_type(stn_cust_retr2, "list")
  expect_equal(stn_cust_retr, stn_cust_retr2)

  expect_error(
    ki_timeseries_list(
      hub = example_hub,
      station_id = test_stn_id,
      return_fields = fake_ret_str
    )
  )
})
