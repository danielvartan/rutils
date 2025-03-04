test_that("swap_if() | General test", {
  swap_if(x = 5, y = 1, condition = TRUE) |>
    expect_equal(list(x = 1, y = 5))

  swap_if(x = 1, y = 5, condition = 1 > 5) |>
    expect_equal(list(x = 1, y = 5))

  swap_if(x = 5, y = 1, condition = 2 > 1) |>
    expect_equal(list(x = 1, y = 5))
})

test_that("swap_if() | Error test", {
  # checkmate::assert_logical(condition)
  swap_if(x = 1, y = 1, condition = 1) |>
    expect_error("Assertion on 'condition' failed")
})
