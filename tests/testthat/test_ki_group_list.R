context("Testing group metadata retrieval and filtering")

test_that("ki_group_list returns a tibble with three columns", {
  skip_if_net_down()
  skip_if_exp_down()

  group_test <- ki_group_list(hub = example_hub)
  static_names <- c("group_name", "group_id", "group_type")


  expect_type(group_test, "list")
  expect(
    sum(static_names %in% names(group_test)) == 3,
    failure_message = "Group metadata doesn't contain expected columns"
    )
})

test_that("ki_group_list throws error if no hub specified", {
  skip_if_net_down()
  expect_error(ki_group_list())
})

test_that("ki_group_list throws error if provided hub in not reachable", {
  skip_if_net_down()
  expect_error(ki_group_list(hub = "https://xxxxx"))
})
