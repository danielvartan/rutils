testthat::test_that("clean_arg_list() | General test", {
  clean_arg_list(list(a = 1, b = "", c = 3)) |>
    testthat::expect_equal(list(a = 1, b = NULL, c = 3))

  clean_arg_list(pairlist(a = 1, a = "")) |>
    testthat::expect_equal(list(a = 1))
})

testthat::test_that("clean_arg_list() | Error test", {
  # checkmate::assert_multi_class(list, c("list", "pairlist"))
  clean_arg_list("a") |> testthat::expect_error()
  clean_arg_list(1) |> testthat::expect_error()
  clean_arg_list(data.frame(a = 1)) |> testthat::expect_error()

  # checkmate::assert_list(as.list(list), names = "named")
  clean_arg_list(list(1, 2, 3)) |> testthat::expect_error()
})
