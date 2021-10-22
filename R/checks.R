# Sort functions by type or use the alphabetical order.

test_has_length <- function(x) if (length(x) >= 1) TRUE else FALSE

check_has_length <- function(x, any.missing = TRUE,
                             name = deparse(substitute(x))) {
    checkmate::assert_flag(any.missing)

    if (any(is.na(x)) && isFALSE(any.missing)) {
        paste0(single_quote_(name), " cannot have missing values")
    } else if (!test_has_length(x)) {
        paste0(single_quote_(name), " must have length greater than zero")
    } else {
        TRUE
    }
}

assert_has_length <- checkmate::makeAssertionFunction(check_has_length)

assert_identical <- function(..., type = "value", any.missing = TRUE,
                             null.ok = FALSE) {

    if (!checkmate::test_list(list(...), min.len = 2)) {
        cli::cli_abort("'...' must have 2 or more elements.")
    }

    checkmate::assert_choice(type, c("value", "length", "class"))
    checkmate::assert_flag(any.missing)
    checkmate::assert_flag(null.ok)

    names <- get_names(...)
    out <- list(...)

    if (type == "length") {
        error_message <- paste0("Assertion failed: {single_quote_(names)} ",
                                " must have identical lengths.")
        check <- length(unique(vapply(out, length, integer(1)))) == 1
    } else if (type == "class") {
        error_message <- paste0("Assertion failed: {single_quote_(names)} ",
                                " must have identical classes.")
        check <- length(unique(lapply(out, class))) == 1
    } else {
        error_message <- paste0("Assertion failed: {single_quote_(names)} ",
                                " must be identical.")
        check <- length(unique(out)) == 1
    }

    if (any(unlist(lapply(out, is.null)), na.rm = TRUE) && isTRUE(null.ok)) {
        invisible(TRUE)
    } else if (any(is.na(unlist(out))) && isFALSE(any.missing)) {
        cli::cli_abort("{names} cannot have missing values.")
    } else if (any(is.null(unlist(out)), na.rm = TRUE) && isFALSE(null.ok)) {
        cli::cli_abort("{names} cannot have 'NULL' values.")
    } else if (isFALSE(check)) {
        cli::cli_abort(error_message)
    } else {
        invisible(TRUE)
    }
}

assert_interactive <- function(){
    if (!is_interactive()) {
        stop("You must be in a interactive R session to use this function",
             call. = FALSE)
    }

    invisible(TRUE)
}

test_length_one <- function(x) if (length(x) == 1) TRUE else FALSE

check_length_one <- function(x, name = deparse(substitute(x))) {
    if (!(test_length_one(x))) {
        paste0(single_quote_(name), " must have length 1, not length ",
               length(x))
    } else {
        TRUE
    }
}

assert_length_one <- checkmate::makeAssertionFunction(check_length_one)

test_namespace <- function(x) {
    checkmate::assert_string(x)
    require_namespace(x, quietly = TRUE)
}

check_namespace <- function(x, null.ok = FALSE, name = deparse(substitute(x))) {
    checkmate::assert_string(x, null.ok = TRUE)
    checkmate::assert_flag(null.ok)

    if (is.null(x) && isTRUE(null.ok)) {
        TRUE
    } else if (is.null(x) && isFALSE(null.ok)) {
        paste0(single_quote_(name), " cannot have 'NULL' values")
    } else if (isFALSE(test_namespace(x))) {
        paste0("There's no namespace called ",  single_quote_(x))
    } else {
        TRUE
    }
}

assert_namespace <- checkmate::makeAssertionFunction(check_namespace)

test_whole_number <- function(x, any.missing = TRUE, null.ok = FALSE,
                              tol = .Machine$double.eps^0.5) {
    checkmate::assert_flag(any.missing)
    checkmate::assert_flag(null.ok)
    checkmate::assert_number(tol)

    if (is.null(x) && isTRUE(null.ok)) {
        TRUE
    } else if (any(is.na(x)) && isFALSE(any.missing)) {
        FALSE
    } else if (!checkmate::test_numeric(x) || !identical(x, abs(x))) {
        FALSE
    } else {
        all(abs(x - round(x)) < tol, na.rm = any.missing)
    }
}

check_whole_number <- function(x, any.missing = TRUE, null.ok = FALSE,
                               name = deparse(substitute(x))) {
    checkmate::assert_flag(any.missing)
    checkmate::assert_flag(null.ok)

    if (is.null(x) && isTRUE(null.ok)) {
        TRUE
    } else if (any(is.na(x)) && isFALSE(any.missing)) {
        paste0(single_quote_(name), " cannot have missing values")
    } else if (is.null(x) && isFALSE(null.ok)) {
        paste0(single_quote_(name), " cannot have 'NULL' values")
    } else  if (!test_whole_number(x)) {
        paste0(single_quote_(name), " must consist of whole numbers")
    } else {
        TRUE
    }
}

assert_whole_number <- checkmate::makeAssertionFunction(check_whole_number)
