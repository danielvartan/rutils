testthat::test_that("nullify_list() | General test", {
  nullify_list(list(a = 1, b = "", c = 3)) |>
    testthat::expect_equal(list(a = 1, b = NULL, c = 3))
})

testthat::test_that("nullify_list() | Error test", {
  # checkmate::assert_multi_class(list, c("list", "pairlist"))
  nullify_list("a") |> testthat::expect_error()
  nullify_list(1) |> testthat::expect_error()
  nullify_list(data.frame(a = 1)) |> testthat::expect_error()

  # checkmate::assert_list(as.list(list), names = "named")
  nullify_list(list(1, 2, 3)) |> testthat::expect_error()
})
