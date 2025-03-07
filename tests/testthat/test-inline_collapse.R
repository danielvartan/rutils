test_that("inline_collapse() | general test", {
  expect_equal(inline_collapse(1:2), "'1' and '2'")
  expect_equal(inline_collapse(1:3), "'1', '2', and '3'")
  expect_equal(inline_collapse(1:3, last = "or"), "'1', '2', or '3'")
  expect_equal(inline_collapse(1:3, single_quote = FALSE), "1, 2, and 3")
  expect_equal(inline_collapse(1:3, serial_comma  = FALSE),
               "'1', '2' and '3'")

})

test_that("inline_collapse() | Error test", {
  # checkmate::assert_string(last)
  inline_collapse(
    x = 1:3,
    last = 1,
    single_quote = TRUE,
    serial_comma = TRUE
  ) |>
    expect_error("Assertion on 'last' failed")

  # checkmate::assert_flag(single_quote)
  inline_collapse(
    x = 1:3,
    last = "",
    single_quote = 1,
    serial_comma = TRUE
  ) |>
    expect_error("Assertion on 'single_quote' failed")

  # checkmate::assert_flag(serial_comma)
  inline_collapse(
    x = 1:3,
    last = "",
    single_quote = TRUE,
    serial_comma = 1
  ) |>
    expect_error("Assertion on 'serial_comma' failed")
})
