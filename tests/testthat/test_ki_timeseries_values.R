context("Testing time series value retrieval and filters")

test_that("ki_timeseries_values throws error when no hub specified", {
  expect_error(ki_timeseries_values(hub = "", ts_id = "1234"))
})

test_that("ki_timeseries_values throws error when no ts_id specified", {
  expect_error(ki_timeseries_values(hub = "kisters"))
})

test_that("ki_timeseries_values returns error if ts_id doesn't exist", {
  expect_error(ki_timeseries_values(hub = "kisters", ts_id = "FAKE"))
})

test_that("ki_timeseries_values returns error if no data for specified dates", {
  test_ts <- "623042"
  # Past 24 hours by default
  expect_error(ki_timeseries_values(hub = "kisters", ts_id = test_ts))
  # Specified dates
  expect_error(ki_timeseries_values(hub = "kisters",
                                    ts_id = test_ts,
                                    start_date = Sys.Date(),
                                    end_date = Sys.Date() + 1))
})

test_that("ki_timeseries_values returns table with data", {
  test_ts <- "623042"
  ts_vals <- ki_timeseries_values(hub = "kisters",
                                  ts_id = test_ts,
                                  start_date = "2000-02-01",
                                  end_date = "2005-02-01")
  expect_is(ts_vals, "tbl_df")
})

test_that("ki_timeseries_values can take a vector of ts_ids and return list of tables", {
  test_ts <- c("623042","2134042")
  ts_vals <- ki_timeseries_values(hub = "kisters",
                                  ts_id = test_ts,
                                  start_date = "2000-02-01",
                                  end_date = Sys.Date())
  expect_is(ts_vals, "list")
  expect_is(ts_vals[[1]], "tbl_df")
  expect_is(ts_vals[[2]], "tbl_df")
})
