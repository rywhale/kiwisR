context("Testing time series value retrieval and filters")

test_that("ki_timeseries_values throws error when no hub specified", {
  skip_if_net_down()
  skip_if_exp_down()

  expect_error(ki_timeseries_values(hub = "", ts_id = "1234"))
})

test_that("ki_timeseries_values throws error if provided hub in not reachable", {
  skip_if_net_down()
  skip_if_exp_down()

  expect_error(ki_timeseries_values(hub = "https://xxxx", ts_id = "1234"))
})

test_that("ki_timeseries_values throws error when no ts_id specified", {
  skip_if_net_down()
  skip_if_exp_down()

  expect_error(ki_timeseries_values(hub = example_hub))
})

test_that("ki_timeseries_values returns error if ts_id doesn't exist", {
  skip_if_net_down()
  skip_if_exp_down()

  expect_error(ki_timeseries_values(hub = example_hub, ts_id = "FAKE"))
})

test_that("ki_timeseries_values returns error if no data for specified dates", {
  skip_if_net_down()
  skip_if_exp_down()

  # Past 24 hours by default
  expect_error(ki_timeseries_values(hub = example_hub, ts_id = test_ts_ids[[1]]))

  # Specified dates
  expect_error(ki_timeseries_values(
    hub = example_hub,
    ts_id = test_ts_ids[[1]],
    start_date = Sys.Date(),
    end_date = Sys.Date() + 1
  ))
})

test_that("ki_timeseries_values returns table with data", {
  skip_if_net_down()
  skip_if_exp_down()

  ts_vals <- ki_timeseries_values(
    hub = example_hub,
    ts_id = test_ts_ids[[1]],
    start_date = "2015-12-01",
    end_date = "2018-01-01"
  )
  expect_is(ts_vals, c("tbl_df", "tbl", "data.frame"))
})

test_that("ki_timeseries_values can take a vector of ts_ids and return list of tables", {
  skip_if_net_down()
  skip_if_exp_down()

  ts_vals <- ki_timeseries_values(
    hub = example_hub,
    ts_id = test_ts_ids,
    start_date = "2015-12-01",
    end_date = "2018-01-01"
  )

  expect_is(ts_vals, c("tbl_df", "tbl", "data.frame"))
  expect(
    length(unique(ts_vals$ts_name)) == 2,
    failure_message = "Timeseries values query for multiple ts_ids didn't return multiple ts_names"
  )
})

test_that("ki_timeseries_values returns three columns (two static) by default", {
  skip_if_net_down()
  skip_if_exp_down()

  ts_vals <- ki_timeseries_values(
    hub = example_hub,
    ts_id = test_ts_ids[[1]],
    start_date = "2015-12-01",
    end_date = "2018-01-01"
  )

  expect(
    sum(c("Timestamp", "Units") %in% names(ts_vals)) == 2,
    failure_message = "Timeseries values query did not return expected columns."
  )
})

test_that("ki_timeseries_values accepts custom return fields (vector or string)", {
  skip_if_net_down()
  skip_if_exp_down()

  cust_ret_str <- "Timeseries Comment"
  cust_ret_v <- c("Timeseries Comment")

  fake_ret_str <- "metadatathatdoesntactuallexist"

  ts_cust_retr <- ki_timeseries_values(
    hub = example_hub,
    ts_id = test_ts_ids[[1]],
    start_date = "2015-12-01",
    end_date = "2018-01-01",
    return_fields = cust_ret_str
  )

  ts_cust_retr2 <- ki_timeseries_values(
    hub = example_hub,
    ts_id = test_ts_ids[[1]],
    start_date = "2015-12-01",
    end_date = "2018-01-01",
    return_fields = cust_ret_str
  )

  expect_is(ts_cust_retr, c("tbl_df", "tbl", "data.frame"))
  expect_is(ts_cust_retr2, c("tbl_df", "tbl", "data.frame"))
  expect_equal(ts_cust_retr, ts_cust_retr2)

  expect_error(
    ts_cust_retr2 <- ki_timeseries_values(
      hub = example_hub,
      ts_id = test_ts_ids[[1]],
      start_date = "2015-12-01",
      end_date = "2018-01-01",
      return_fields = fake_ret_str
    )
  )
})
