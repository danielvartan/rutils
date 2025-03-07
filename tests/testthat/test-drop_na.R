test_that("drop_na() | General test", {
  drop_na(c(NA, 1)) |> expect_equal(1)
})
