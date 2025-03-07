test_that("str_extract_() | general test", {
  expect_equal(str_extract_(
    string = "test123", pattern = "\\d+$", ignore_case = TRUE, perl = TRUE,
    fixed = FALSE, use_bytes = FALSE, invert = FALSE
  ),
  regmatches("test123", regexpr("\\d+$", "test123", perl = TRUE))
  )

  expect_equal(str_extract_(
    string = "test123", pattern = "^0$", ignore_case = TRUE, perl = TRUE,
    fixed = FALSE, use_bytes = FALSE, invert = FALSE
  ),
  as.character(NA)
  )
})

test_that("str_extract_() | error test", {
  # checkmate::assert_string(pattern)
  expect_error(str_extract_(
    string = 1, pattern = TRUE, ignore_case = TRUE, perl = TRUE,
    fixed = TRUE, use_bytes = TRUE, invert = TRUE
  ),
  "Assertion on 'pattern' failed"
  )

  # checkmate::assert_flag(ignore_case)
  expect_error(str_extract_(
    string = 1, pattern = "a", ignore_case = "", perl = TRUE, fixed = TRUE,
    use_bytes = TRUE, invert = TRUE
  ),
  "Assertion on 'ignore_case' failed"
  )

  # checkmate::assert_flag(perl)
  expect_error(str_extract_(
    string = 1, pattern = "a", ignore_case = TRUE, perl = "", fixed = TRUE,
    use_bytes = TRUE, invert = TRUE
  ),
  "Assertion on 'perl' failed"
  )

  # checkmate::assert_flag(fixed)
  expect_error(str_extract_(
    string = 1, pattern = "a", ignore_case = TRUE, perl = TRUE, fixed = "",
    use_bytes = TRUE, invert = TRUE
  ),
  "Assertion on 'fixed' failed"
  )

  # checkmate::assert_flag(use_bytes)
  expect_error(str_extract_(
    string = 1, pattern = "a", ignore_case = TRUE, perl = TRUE,
    fixed = TRUE,  use_bytes = "", invert = TRUE
  ),
  "Assertion on 'use_bytes' failed"
  )

  # checkmate::assert_flag(invert)
  expect_error(str_extract_(
    string = 1, pattern = "a", ignore_case = TRUE, perl = TRUE,
    fixed = TRUE,  use_bytes = TRUE, invert = ""
  ),
  "Assertion on 'invert' failed"
  )
})
