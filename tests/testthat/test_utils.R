context("Testing functions in utils.R")

test_that("check_hub accepts certain character strings for default hubs", {
  skip_if_net_down()

  expect_is(check_hub("kisters"), "character")
  expect_is(check_hub("swmc"), "character")
  expect_is(check_hub("quinte"), "character")
})

test_that("check_hub returns error if server/url is unreachable", {
  expect_error(check_hub("http://xxxxx"))
})

test_that("check_hub returns error if hub is not a character", {
  expect_error(check_hub(1234))
})

test_that("check_date returns error if start/end date cannot be parsed", {
  expect_error(check_date("2019-0222-01", "2018-01-01"))
  expect_error(check_date("2019-01-01", "2019-0222-01"))
  expect_error(check_date("2019-0222-01", "2019-02222-05"))
})

test_that("check_date returns error if start_date > end_date", {
  expect_error(check_date("2019-01-01", "2018-01-01"))
})