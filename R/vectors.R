# Sort functions by type or use the alphabetical order.

change_name <- function(x, new_name) {
    checkmate::assert_character(new_name, min.len = 1)
    assert_identical(names(x), new_name, type = "length")

    names(x) <- new_name

    x
}

class_collapse <- function(x) {
    single_quote_(paste0(class(x), collapse = "/"))
}

clear_names <- function(x) {
    names(x) <- NULL

    x
}

clear_row_names <- function(x) {
    checkmate::assert_data_frame(x, min.rows = 1)

    rownames(x) <- NULL

    x
}

close_round <- function(x, digits = 3) {
    checkmate::assert_numeric(x)
    checkmate::assert_number(digits)

    # nolint start: object_usage_linter.
    pattern_9 <- paste0("\\.", paste(rep(9, digits), collapse = ""))
    pattern_0 <- paste0("\\.", paste(rep(0, digits), collapse = ""))
    # nolint end

    dplyr::case_when(
        grepl(pattern_9, x) | grepl(pattern_0, x) ~ round(x),
        TRUE ~ x)
}

count_na <- function(x) {
    checkmate::assert_atomic(x)

    length(which(is.na(x)))
}

fix_character <- function(x) {
    checkmate::assert_character(x)

    x <- trimws(x)

    for (i in c("", "NA")) {
        x <- dplyr::na_if(x, i)
    }

    x
}

get_class <- function(x) {
    if (is.list(x)) {
        vapply(x, function(x) class(x)[1], character(1))
    } else {
        class(x)[1]
    }
}

get_names <- function(...) {
    out <- lapply(substitute(list(...))[-1], deparse) %>%
        vapply(unlist, character(1)) %>%
        noquote()

    gsub("\\\"", "", out)
}

na_replace <- function(x, replacement = "") {
    checkmate::assert_atomic(x, min.len = 1)
    checkmate::assert_atomic(replacement, len = 1)
    checkmate::assert_class(replacement, class(x))

    x[which(is.na(x))] <- replacement

    x
}

return_duplications <- function(x, rm_na = TRUE) {
    if (anyDuplicated(x) == 0) {
        NULL
    } else {
        out <- x[duplicated(x)]

        if (isTRUE(rm_na)) {
            rm_na(out)
        } else {
            x[duplicated(x)]
        }
    }
}

rm_na <- function(x) x[which(!is.na(x))]
