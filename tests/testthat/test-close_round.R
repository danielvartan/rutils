test_that("close_round() | General test", {
  close_round(1.999999, 5) |> expect_equal(2)
  close_round(1.000001, 5) |> expect_equal(1)
  close_round(1.001, 2) |> expect_equal(1)
  close_round(1.0001, 5) |> expect_equal(1.0001)
  close_round(c(1.000001, 1.999999, 1.11), 5) |> expect_equal(c(1, 2, 1.11))
})

test_that("close_round() | Error test", {
  close_round("", 1) |> expect_error("Assertion on 'x' failed")
  close_round(1, "") |> expect_error("Assertion on 'digits' failed")
})
