test_that("str_subset_() | general test", {
  expect_equal(str_subset_(month.name, "^J.+", perl = TRUE, negate = FALSE),
               subset(month.name, grepl("^J.+", month.name, perl = TRUE)))
  expect_equal(str_subset_(month.name, "^J.+", perl = TRUE, negate = TRUE),
               subset(month.name, !grepl("^J.+", month.name, perl = TRUE)))
  expect_equal(str_subset_(month.name, "^z$", perl = TRUE, negate = FALSE),
               as.character(NA))
})

test_that("str_subset_() | error test", {
  expect_error(str_subset_(1, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE),
               "Assertion on 'pattern' failed")
  expect_error(str_subset_(1, "a", "", TRUE, TRUE, TRUE, TRUE),
               "Assertion on 'negate' failed")
  expect_error(str_subset_(1, "a", TRUE, "", TRUE, TRUE, TRUE),
               "Assertion on 'ignore_case' failed")
  expect_error(str_subset_(1, "a", TRUE, TRUE, "", TRUE, TRUE),
               "Assertion on 'perl' failed")
  expect_error(str_subset_(1, "a", TRUE, TRUE, TRUE, "", TRUE),
               "Assertion on 'fixed' failed")
  expect_error(str_subset_(1, "a", TRUE, TRUE, TRUE, TRUE, ""),
               "Assertion on 'use_bytes' failed")
})
