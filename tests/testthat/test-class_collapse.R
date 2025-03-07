test_that("class_collapse() | general test", {
  expect_equal(class_collapse(
    x = "test"
  ),
  single_quote_(paste0(class("test"), collapse = "/"))
  )

  expect_equal(class_collapse(
    x = 1
  ),
  single_quote_(paste0(class(1), collapse = "/"))
  )

  expect_equal(class_collapse(
    x = lubridate::dhours()
  ),
  single_quote_(paste0(class(lubridate::dhours()), collapse = "/"))
  )
})
