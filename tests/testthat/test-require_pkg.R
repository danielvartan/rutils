test_that("require_pkg() | general test", {
  expect_null(require_pkg("base"))
  expect_error(require_pkg("test65464564"))
  expect_error(require_pkg("test1654654", "test265464564"))

  mock <- function(.parent = parent.frame(), .env = topenv(.parent)) {
    mockr::with_mock(
      require_namespace = function(...) TRUE,
      {
        require_pkg("test")
      }
    )
  }

  expect_null(mock())
})

test_that("require_pkg() | error test", {
  # lapply(out, checkmate::assert_string,
  #        pattern = "^[A-Za-z][A-Za-z0-9.]+[A-Za-z0-9]$")
  expect_error(require_pkg(1), "Assertion on 'X\\[\\[i\\]\\]' failed")
  expect_error(require_pkg(".test"), "Assertion on 'X\\[\\[i\\]\\]' failed")
  expect_error(require_pkg("test."), "Assertion on 'X\\[\\[i\\]\\]' failed")
  expect_error(require_pkg("tes_t"), "Assertion on 'X\\[\\[i\\]\\]' failed")
  expect_error(require_pkg("tést"), "Assertion on 'X\\[\\[i\\]\\]' failed")

  # (!identical(unique(unlist(out)), unlist(out)))
  expect_error(require_pkg(
    "test", "test"
  ),
  "'...' cannot have duplicated values."
  )
})
