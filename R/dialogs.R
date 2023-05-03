# Sort functions by type or use the alphabetical order.

clipboard <- function(..., space_above = FALSE, quiet = FALSE) {
    assert_has_length(list(...))
    checkmate::assert_flag(space_above)
    checkmate::assert_flag(quiet)
    require_pkg("utils")

    utils::writeClipboard(as.character(
        unlist(list(...), use.names = FALSE)))

    if (isFALSE(quiet)) {
        if (isTRUE(space_above)) cli::cat_line()
        cli::cli_inform("{cli::col_silver('[Copied to clipboard]')}")
    }
}

# Use the `cli` package instead.
dialog_line <- function(..., space_above = TRUE, space_below = TRUE,
                        abort = FALSE) {
    assert_has_length(list(...))
    checkmate::assert_flag(space_above)
    checkmate::assert_flag(space_below)
    checkmate::assert_flag(abort)

    if (!is_interactive()) return(invisible(NULL))
    if (isTRUE(abort)) return(invisible(NULL))

    line <- vapply(list(...), paste0, character(1), collapse = "")
    line <- paste0(line, collapse = "")
    line <- paste0(paste(strwrap(line), collapse = "\n"), " ")

    if (isTRUE(space_above)) cli::cat_line()
    out <- read_line(line)
    if (isTRUE(space_below)) cli::cat_line()

    out
}

printer <- function(..., print = TRUE, clipboard = TRUE, abort = FALSE) {
    assert_has_length(list(...))
    checkmate::assert_flag(print)
    checkmate::assert_flag(clipboard)
    checkmate::assert_flag(abort)

    if (isTRUE(abort)) return(invisible(NULL))

    styler <- function(x) cli::col_red(x) %>% cli::style_bold()
    log <- unlist(list(...)) %>%
        vapply(styler, character(1), USE.NAMES = FALSE)

    if (isTRUE(print)) cat(log, sep = "\n\n")
    if (isTRUE(clipboard)) clipboard(..., space_above = TRUE, quiet = FALSE)

    invisible(NULL)
}

shush <- function(x, quiet = TRUE) {
    if (isTRUE(quiet)) {
        suppressMessages(suppressWarnings(x))
    } else {
        x
    }
}
