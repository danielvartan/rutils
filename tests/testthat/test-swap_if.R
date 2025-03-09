test_that("swap_if() | General test", {
  swap_if(x = 5, y = 1, condition = TRUE) |>
    expect_equal(list(x = 1, y = 5))

  swap_if(x = 1, y = 5, condition = 1 > 5) |>
    expect_equal(list(x = 1, y = 5))

  swap_if(x = 5, y = 1, condition = 2 > 1) |>
    expect_equal(list(x = 1, y = 5))

  swap_if(letters, LETTERS, rep(TRUE, length(letters))) |>
    expect_equal(list(x = LETTERS, y = letters))
})

test_that("swap_if() | Error test", {
  # if (class(x) != class(y)) ...
  swap_if(x = 1, y = "1", condition = TRUE) |>
    expect_error()

  # if (length(x) != length(y) || length(x) != length(condition)) ...
  swap_if(x = 1, y = 1:2, condition = TRUE) |>
    expect_error()

  # checkmate::assert_logical(condition)
  swap_if(x = 1, y = 1, condition = 1) |>
    expect_error("Assertion on 'condition' failed")
})
