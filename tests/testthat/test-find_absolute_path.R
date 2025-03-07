test_that("find_absolute_path() | general test", {
  expect_equal(
    find_absolute_path(list.files()[1]),
    file.path(getwd(), list.files()[1])
  )
})
