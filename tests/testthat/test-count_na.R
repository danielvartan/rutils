test_that("count_na() | General test", {
  count_na(x = c(1, NA, 1, NA)) |> expect_equal(2)
})
