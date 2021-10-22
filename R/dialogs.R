# Sort functions by type or use the alphabetical order.

# Use the `cli` package instead.
alert <- function(..., combined_styles = c("bold", "red"), type = "message",
                  abort = FALSE) {
    assert_has_length(list(...))
    checkmate::assert_character(combined_styles, null.ok = TRUE)
    checkmate::assert_choice(type, c("cat", "message", "warning"))
    checkmate::assert_flag(abort)

    if (isTRUE(abort)) return(invisible(NULL))

    message <- vapply(list(...), paste0, character(1), collapse = "")
    message <- paste0(message, collapse = "")
    message <- paste(strwrap(message), collapse = "\n")

    if (require_namespace("crayon", quietly = TRUE) &&
        !is.null(combined_styles)) {
        message <- crayonize(message, combined_styles = combined_styles)
    }

    if (type == "cat") {
        cat(message)
    } else if (type == "message") {
        message(message)
    } else if (type == "warning") {
        warning(message, call. = FALSE)
    }

    invisible(NULL)
}

clipboard <- function(..., space_above = FALSE, quiet = FALSE) {
    assert_has_length(list(...))
    checkmate::assert_flag(space_above)
    checkmate::assert_flag(quiet)
    require_pkg("utils")

    utils::writeClipboard(as.character(
        unlist(list(...), use.names = FALSE)))

    if (isFALSE(quiet)) {
        if(isTRUE(space_above)) cli::cat_line()
        cli::cli_inform("{cli::col_silver('[Copied to clipboard]')}")
    }
}

# Use the `cli` package instead.
crayonize <- function(..., combined_styles = c("bold", "red"), abort = FALSE) {
    styles <- c("reset", "bold", "blurred", "italic", "underline", "inverse",
                "hidden", "strikethrough")
    color <- c("black", "red", "green", "yellow", "blue", "magenta", "cyan",
               "white", "silver")
    bg_colors <- c("bgBlack", "bgRed", "bgGreen", "bgYellow", "bgBlue",
                   "bgMagenta", "bgCyan", "bgWhite")

    assert_has_length(list(...))
    checkmate::assert_subset(combined_styles, c(styles, color, bg_colors),
                             empty.ok = TRUE)
    checkmate::assert_flag(abort)

    if (isTRUE(abort)) return(invisible(NULL))

    out <- unlist(list(...))

    if (require_namespace("crayon", quietly = TRUE)) {
        crayonize <- shush(crayon::combine_styles(combined_styles))
        out <- vapply(out, crayonize, character(1), USE.NAMES = FALSE)
    }

    out
}

# Use the `cli` package instead.
dialog_line_1 <- function(..., space_above = TRUE, space_below = TRUE,
                        abort = FALSE) {
    assert_has_length(list(...))
    checkmate::assert_flag(space_above)
    checkmate::assert_flag(space_below)
    checkmate::assert_flag(abort)

    if (!is_interactive()) return(NULL)
    if (isTRUE(abort)) return(NULL)

    line <- vapply(list(...), paste0, character(1), collapse = "")
    line <- paste0(line, collapse = "")
    line <- paste0(paste(strwrap(line), collapse = "\n"), " ")

    if(isTRUE(space_above)) cli::cat_line()
    out <- read_line(line)
    if(isTRUE(space_below)) cli::cat_line()

    out
}

# Use the `cli` package instead.
dialog_line_2 <- function(..., combined_styles = NULL,
                        space_above = TRUE, space_below = TRUE,
                        abort = FALSE) {
    assert_has_length(list(...))
    checkmate::assert_character(combined_styles, null.ok = TRUE)
    checkmate::assert_flag(space_above)
    checkmate::assert_flag(space_below)
    checkmate::assert_flag(abort)

    if (!is_interactive()) return(999)
    if (isTRUE(abort)) return(999)

    line <- vapply(list(...), paste0, character(1), collapse = "")
    line <- paste0(line, collapse = "")
    line <- paste0(paste(strwrap(line), collapse = "\n"), " ")

    if (require_namespace("crayon", quietly = TRUE) &&
        !is.null(combined_styles)) {
        line <- crayonize(line, combined_styles = combined_styles)
    }

    if(isTRUE(space_above)) cat("\n")
    answer <- read_line(line)
    if(isTRUE(space_below)) cat("\n")

    answer
}

# Avoid using this function. You can apply emojis using unicode.
emojinize <- function(aliases, alternative = "", left_space = FALSE,
                      right_space = FALSE) {
    checkmate::assert_string(aliases)
    checkmate::assert_string(alternative)
    checkmate::assert_flag(left_space)
    checkmate::assert_flag(right_space)

    if (require_namespace("emojifont", quietly = TRUE)) {
        out <- emojifont::emoji(aliases)

        if (isTRUE(left_space)) out <- paste0(" ", out)
        if (isTRUE(right_space)) out <- paste0(out, " ")

        out
    } else {
        alternative
    }
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