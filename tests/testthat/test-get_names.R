test_that("get_names() | general test", {
  get_names(x, y, z) |> expect_equal(c("x", "y", "z"))
})
