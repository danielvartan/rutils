testthat::test_that("grab_fun_par() | General test", {
  foo <- function(a = 1) grab_fun_par()
  foo() |> testthat::expect_equal(list(a = 1))

  foo <- function(...) grab_fun_par()
  foo(a = 1) |> testthat::expect_equal(list(a = 1))

  foo <- function(..., a = 1) grab_fun_par()
  foo() |> testthat::expect_equal(list(a = 1))

  foo <- function(...) grab_fun_par()
  foo(1) |> testthat::expect_equal(list())
})
