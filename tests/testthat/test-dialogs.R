# Sort tests by type or use the alphabetical order.

test_that("dialog_line_1() | general test", {
    # ## Don't forget to run devtools::load_all(".") and uncomment the variables
    # ## before trying to run the tests interactively.
    #
    # is_interactive <- mctq:::is_interactive
    # require_namespace <- mctq:::require_namespace
    # read_line <- mctq:::read_line

    mock <- function(.parent = parent.frame(), .env = topenv(.parent)) {
        mockr::with_mock(
            is_interactive = function(...) FALSE,
            dialog_line_1(1))
    }

    # mock()
    expect_null(mock())

    mock <- function(.parent = parent.frame(), .env = topenv(.parent)) {
        mockr::with_mock(
            is_interactive = function(...) TRUE,
            dialog_line_1(1, abort = TRUE))
    }

    # mock()
    expect_null(mock())

    mock <- function(.parent = parent.frame(), .env = topenv(.parent)) {
        mockr::with_mock(
            is_interactive = function(...) TRUE,
            require_namespace = function(...) TRUE,
            read_line = function(...) TRUE,
            dialog_line_1(1, combined_styles = "red", space_above = TRUE,
                        space_below = TRUE))
    }

    # mock()
    expect_equal(utils::capture.output(mock()), c("", "", "[1] TRUE"))
})

test_that("dialog_line_1() | error test", {
    expect_error(dialog_line_1(), "Assertion on 'list\\(...\\)' failed")
    expect_error(dialog_line_1(1, space_above = ""),
                 "Assertion on 'space_above' failed")
    expect_error(dialog_line_1(1, space_below = ""),
                 "Assertion on 'space_below' failed")
    expect_error(dialog_line_1(1, abort = ""),
                 "Assertion on 'abort' failed")
})
