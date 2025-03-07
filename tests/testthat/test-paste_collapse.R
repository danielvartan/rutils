test_that("paste_collapse() | general test", {
  expect_equal(paste_collapse(1), 1)
  expect_equal(paste_collapse(1:2), "12")
  expect_equal(paste_collapse(1:2, sep = " "), "1 2")
  expect_equal(paste_collapse(1:2, sep = " ", last = ""), "12")
  expect_equal(paste_collapse(1:2, sep = " ", last = " or "), "1 or 2")
  expect_equal(paste_collapse(1:3, sep = ", ", last = ", or "), "1, 2, or 3")
})

test_that("paste_collapse() | error test", {
  # checkmate::assert_string(sep)
  expect_error(paste_collapse(x = 1:2, sep = 1, last = ""),
               "Assertion on 'sep' failed")

  # checkmate::assert_string(last)
  expect_error(paste_collapse(x = 1:2, sep = "", last = 1),
               "Assertion on 'last' failed")
})
