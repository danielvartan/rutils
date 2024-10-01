# These functions are provided solely for backward compatibility.

# {lubritime} -----

flat_posixt <- function(posixt, base = as.Date("1970-01-01"),
                        force_tz = TRUE, tz = "UTC") {
  assert_posixt(posixt, null.ok = FALSE)
  checkmate::assert_date(base, len = 1, all.missing = FALSE)
  checkmate::assert_flag(force_tz)
  checkmate::assert_choice(tz, OlsonNames())

  lubridate::date(posixt) <- base

  if (isTRUE(force_tz)) {
    lubridate::force_tz(posixt, tz)
  } else {
    posixt
  }
}

midday_change <- function(time) {
  checkmate::assert_multi_class(time, c("hms", "POSIXct", "POSIXlt"))

  if (hms::is_hms(time)) time <- as.POSIXct(time)
  time <- flat_posixt(time)

  dplyr::case_when(
    lubridate::hour(time) < 12 ~ lubridate::`day<-`(time, 2),
    TRUE ~ time
  )
}

extract_seconds <- function(x) {
  classes <- c("Duration", "difftime", "hms", "POSIXct", "POSIXlt",
               "Interval")

  checkmate::assert_multi_class(x, classes)

  if (lubridate::is.POSIXt(x) || lubridate::is.difftime(x)) {
    as.numeric(hms::as_hms(x))
  } else {
    as.numeric(x)
  }
}

# {prettychecks} -----

test_has_length <- function(x) length(x) >= 1

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

assert_internet <- function() {
  if (isFALSE(has_internet())) {
    cli::cli_abort(paste0(
      "No internet connection was found. ",
      "You must have an internet connection to run this function."
    ))
  } else {
    invisible(TRUE)
  }
}

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
    cli::cli_abort("{names} cannot be 'NULL'.")
  } else if (isFALSE(check)) {
    cli::cli_abort(error_message)
  } else {
    invisible(TRUE)
  }
}

test_length_one <- function(x) length(x) == 1

check_length_one <- function(x, name = deparse(substitute(x))) {
  if (!(test_length_one(x))) {
    paste0(single_quote_(name), " must have length 1, not length ",
           length(x))
  } else {
    TRUE
  }
}

assert_length_one <- checkmate::makeAssertionFunction(check_length_one)

test_data <- function(data, package) {
  checkmate::assert_string(data)
  checkmate::assert_string(package)
  require_pkg("utils")

  assert_namespace(package)
  shush(utils::data(list = data, package = package, envir = environment()))

  data %in% ls()
}

assert_data <- function(data, package) {
  checkmate::assert_string(data)
  checkmate::assert_string(package)

  if (isFALSE(test_data(data, package))) {
    cli::cli_abort(paste0(
      "There's no {cli::col_red(data)} data in ",
      "{cli::col_blue(package)} namespace."
    ))
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
    paste0(single_quote_(name), " cannot be 'NULL'")
  } else  if (!test_whole_number(x)) {
    paste0(single_quote_(name), " must consist of whole numbers")
  } else {
    TRUE
  }
}

assert_whole_number <- checkmate::makeAssertionFunction(check_whole_number)

# `*_numeric_()` was created as a workaround to deal with cases like
# `is.numeric(lubridate::duration())`. See
# https://github.com/tidyverse/lubridate/issues/942 to learn more.

test_numeric_ <- function(x, lower = -Inf, upper = Inf, any.missing = TRUE,
                          null.ok = FALSE) {
  checkmate::assert_number(lower)
  checkmate::assert_number(upper)
  checkmate::assert_flag(any.missing)
  checkmate::assert_flag(null.ok)

  classes <- c("integer", "double", "numeric")

  if (is.null(x) && isTRUE(null.ok)) {
    TRUE
  } else if (any(is.na(x)) && isFALSE(any.missing)) {
    FALSE
  } else if (checkmate::test_subset(class(x)[1], classes) &&
             !all(x >= lower & x <= upper, na.rm = TRUE)) {
    FALSE
  } else {
    checkmate::test_subset(class(x)[1], classes)
  }
}

check_numeric_ <- function(x, lower = - Inf, upper = Inf, any.missing = TRUE,
                           null.ok = FALSE,
                           name = deparse(substitute(x))) {
  checkmate::assert_flag(any.missing)
  checkmate::assert_flag(null.ok)

  classes <- c("integer", "double", "numeric")

  if (is.null(x) && isTRUE(null.ok)) {
    TRUE
  } else if (any(is.na(x)) && isFALSE(any.missing)) {
    paste0(single_quote_(name), " cannot have missing values")
  } else if (is.null(x) && isFALSE(null.ok)) {
    paste0(single_quote_(name), " cannot be 'NULL'")
  } else if (checkmate::test_subset(class(x)[1], classes) &&
             !all(x >= lower, na.rm = TRUE)) {
    paste0("Element ", which(x < lower)[1], " is not >= ", lower)
  } else if (checkmate::test_subset(class(x)[1], classes) &&
             !all(x <= upper, na.rm = TRUE)) {
    paste0("Element ", which(x > upper)[1], " is not <= ", upper)
  } else  if (!test_numeric_(x)) {
    paste0("Must be of type 'numeric', not ", class_collapse(x))
  } else {
    TRUE
  }
}

assert_numeric_ <- checkmate::makeAssertionFunction(check_numeric_)

test_duration <- function(x, lower = - Inf, upper = Inf, any.missing = TRUE,
                          null.ok = FALSE) {
  checkmate::assert_flag(any.missing)
  checkmate::assert_flag(null.ok)

  if (is.null(x) && isTRUE(null.ok)) {
    TRUE
  } else if (any(is.na(x)) && isFALSE(any.missing)) {
    FALSE
  } else if (lubridate::is.duration(x) &&
             !all(x >= lower & x <= upper, na.rm = TRUE)) {
    FALSE
  } else {
    lubridate::is.duration(x)
  }
}

check_duration <- function(x, lower = - Inf, upper = Inf, any.missing = TRUE,
                           null.ok = FALSE,
                           name = deparse(substitute(x))) {
  checkmate::assert_flag(any.missing)
  checkmate::assert_flag(null.ok)

  if (is.null(x) && isTRUE(null.ok)) {
    TRUE
  } else if (any(is.na(x)) && isFALSE(any.missing)) {
    paste0(single_quote_(name), " cannot have missing values")
  } else if (is.null(x) && isFALSE(null.ok)) {
    paste0(single_quote_(name), " cannot be 'NULL'")
  } else if (lubridate::is.duration(x) && !all(x >= lower, na.rm = TRUE)) {
    paste0("Element ", which(x < lower)[1], " is not >= ", lower)
  } else if (lubridate::is.duration(x) && !all(x <= upper, na.rm = TRUE)) {
    paste0("Element ", which(x > upper)[1], " is not <= ", upper)
  } else  if (!test_duration(x)) {
    paste0("Must be of type 'Duration', not ", class_collapse(x))
  } else {
    TRUE
  }
}

assert_duration <- checkmate::makeAssertionFunction(check_duration)

test_period <- function(
    x,
    lower = - Inf,
    upper = Inf,
    any.missing = TRUE,
    null.ok = FALSE
  ) {
  checkmate::assert_flag(any.missing)
  checkmate::assert_flag(null.ok)

  if (is.null(x) && isTRUE(null.ok)) {
    TRUE
  } else if (any(is.na(x)) && isFALSE(any.missing)) {
    FALSE
  } else if (lubridate::is.period(x) &&
             !all(x >= lower & x <= upper, na.rm = TRUE)) {
    FALSE
  } else {
    lubridate::is.period(x)
  }
}

check_period <- function(
    x,
    lower = - Inf,
    upper = Inf,
    any.missing = TRUE,
    null.ok = FALSE,
    name = deparse(substitute(x))
  ) {
  checkmate::assert_flag(any.missing)
  checkmate::assert_flag(null.ok)

  if (is.null(x) && isTRUE(null.ok)) {
    TRUE
  } else if (any(is.na(x)) && isFALSE(any.missing)) {
    paste0(single_quote_(name), " cannot have missing values")
  } else if (is.null(x) && isFALSE(null.ok)) {
    paste0(single_quote_(name), " cannot be 'NULL'")
  } else if (lubridate::is.period(x) && !all(x >= lower, na.rm = TRUE)) {
    paste0("Element ", which(x < lower)[1], " is not >= ", lower)
  } else if (lubridate::is.period(x) && !all(x <= upper, na.rm = TRUE)) {
    paste0("Element ", which(x > upper)[1], " is not <= ", upper)
  } else  if (!test_period(x)) {
    paste0("Must be of type 'Period', not ", class_collapse(x))
  } else {
    TRUE
  }
}

assert_period <- checkmate::makeAssertionFunction(check_period)

test_hms <- function(x, lower = - Inf, upper = Inf, any.missing = TRUE,
                     null.ok = FALSE) {
  checkmate::assert_flag(any.missing)
  checkmate::assert_flag(null.ok)

  if (is.null(x) && isTRUE(null.ok)) {
    TRUE
  } else if (any(is.na(x)) && isFALSE(any.missing)) {
    FALSE
  } else if (hms::is_hms(x) &&
             !all(x >= lower & x <= upper, na.rm = TRUE)) {
    FALSE
  } else {
    hms::is_hms(x)
  }
}

check_hms <- function(x, lower = - Inf, upper = Inf, any.missing = TRUE,
                      null.ok = FALSE,
                      name = deparse(substitute(x))) {
  checkmate::assert_flag(any.missing)
  checkmate::assert_flag(null.ok)

  if (is.null(x) && isTRUE(null.ok)) {
    TRUE
  } else if (any(is.na(x)) && isFALSE(any.missing)) {
    paste0(single_quote_(name), " cannot have missing values")
  } else if (is.null(x) && isFALSE(null.ok)) {
    paste0(single_quote_(name), " cannot be 'NULL'")
  } else if (hms::is_hms(x) && !all(x >= lower, na.rm = TRUE)) {
    paste0("Element ", which(x < lower)[1], " is not >= ", lower)
  } else if (hms::is_hms(x) && !all(x <= upper, na.rm = TRUE)) {
    paste0("Element ", which(x > upper)[1], " is not <= ", upper)
  } else  if (!test_hms(x)) {
    paste0("Must be of type 'hms', not ", class_collapse(x))
  } else {
    TRUE
  }
}

assert_hms <- checkmate::makeAssertionFunction(check_hms)

test_posixt <- function(x, lower = - Inf, upper = Inf, any.missing = TRUE,
                        null.ok = FALSE) {
  checkmate::assert_flag(any.missing)
  checkmate::assert_flag(null.ok)

  if (is.null(x) && isTRUE(null.ok)) {
    TRUE
  } else if (any(is.na(x)) && isFALSE(any.missing)) {
    FALSE
  } else if (lubridate::is.POSIXt(x) &&
             !all(x >= lower & x <= upper, na.rm = TRUE)) {
    FALSE
  } else {
    lubridate::is.POSIXt(x)
  }
}

check_posixt <- function(x, lower = - Inf, upper = Inf, any.missing = TRUE,
                         null.ok = FALSE,
                         name = deparse(substitute(x))) {
  checkmate::assert_flag(any.missing)
  checkmate::assert_flag(null.ok)

  if (is.null(x) && isTRUE(null.ok)) {
    TRUE
  } else if (any(is.na(x)) && isFALSE(any.missing)) {
    paste0(single_quote_(name), " cannot have missing values")
  } else if (is.null(x) && isFALSE(null.ok)) {
    paste0(single_quote_(name), " cannot be 'NULL'")
  } else if (lubridate::is.POSIXt(x) && !all(x >= lower, na.rm = TRUE)) {
    paste0("Element ", which(x < lower)[1], " is not >= ", lower)
  } else if (lubridate::is.POSIXt(x) && !all(x <= upper, na.rm = TRUE)) {
    paste0("Element ", which(x > upper)[1], " is not <= ", upper)
  } else  if (!lubridate::is.POSIXt(x)) {
    paste0("Must be of type 'POSIXct' or 'POSIXlt', not ",
           class_collapse(x)
    )
  } else {
    TRUE
  }
}

assert_posixt <- checkmate::makeAssertionFunction(check_posixt)

test_interval <- function(x, lower = - Inf, upper = Inf, any.missing = TRUE,
                          null.ok = FALSE) {
  checkmate::assert_flag(any.missing)
  checkmate::assert_flag(null.ok)

  if (is.null(x) && isTRUE(null.ok)) {
    TRUE
  } else if (any(is.na(x)) && isFALSE(any.missing)) {
    FALSE
  } else if (lubridate::is.interval(x) &&
             !all(x >= lower & x <= upper, na.rm = TRUE)) {
    FALSE
  } else {
    lubridate::is.interval(x)
  }
}

check_interval <- function(x, lower = - Inf, upper = Inf, any.missing = TRUE,
                           null.ok = FALSE,
                           name = deparse(substitute(x))) {
  checkmate::assert_flag(any.missing)
  checkmate::assert_flag(null.ok)

  if (is.null(x) && isTRUE(null.ok)) {
    TRUE
  } else if (any(is.na(x)) && isFALSE(any.missing)) {
    paste0(single_quote_(name), " cannot have missing values")
  } else if (is.null(x) && isFALSE(null.ok)) {
    paste0(single_quote_(name), " cannot be 'NULL'")
  } else if (lubridate::is.interval(x) && !all(x >= lower, na.rm = TRUE)) {
    paste0("Element ", which(x < lower)[1], " is not >= ", lower)
  } else if (lubridate::is.interval(x) && !all(x <= upper, na.rm = TRUE)) {
    paste0("Element ", which(x > upper)[1], " is not <= ", upper)
  } else  if (!lubridate::is.interval(x)) {
    paste0("Must be of type 'Interval', not ", class_collapse(x))
  } else {
    TRUE
  }
}

assert_interval <- checkmate::makeAssertionFunction(check_interval)

test_temporal <- function(x, any.missing = TRUE, null.ok = FALSE, rm = NULL) {
  checkmate::assert_flag(any.missing)
  checkmate::assert_flag(null.ok)
  checkmate::assert_character(rm, any.missing = FALSE, null.ok = TRUE)

  if (is.null(x) && isTRUE(null.ok)) {
    TRUE
  } else if (any(is.na(x)) && isFALSE(any.missing)) {
    FALSE
  } else {
    classes <- c("Duration", "Period", "difftime", "hms", "Date", "POSIXct",
                 "POSIXlt", "Interval")

    if (!is.null(rm)) {
      rm <- paste0("^", rm, "$", collapse = "|")
      classes <- str_subset_(classes, rm, negate = TRUE)
    }

    checkmate::test_subset(class(x)[1], classes)
  }
}

check_temporal <- function(x, any.missing = TRUE, null.ok = FALSE,
                           name = deparse(substitute(x))) {
  checkmate::assert_flag(any.missing)
  checkmate::assert_flag(null.ok)

  if (is.null(x) && isTRUE(null.ok)) {
    TRUE
  } else if (any(is.na(x)) && isFALSE(any.missing)) {
    paste0(single_quote_(name), " cannot have missing values")
  } else if (is.null(x) && isFALSE(null.ok)) {
    paste0(single_quote_(name), " cannot be 'NULL'")
  } else if (!test_temporal(x)) {
    paste0("Must be a temporal object (see 'test_temporal()'), ",
           "not ", class_collapse(x))
  } else {
    TRUE
  }
}

assert_temporal <- checkmate::makeAssertionFunction(check_temporal)

# {grommr} -----

normalize_extdata <- function(package = NULL) {
  if (is.null(package)) package <- get_package_name()
  assert_namespace(package)

  extdata <- system.file("inst/extdata", package = package)
  path <- list.dirs(extdata)

  for (i in path) {
    i <- paste0(i, "/")

    if (length(list.files(i)) == 0) {
      next
    } else {
      new_name <- tolower(list.files(i))
      new_name <- stringr::str_replace_all(new_name, " - ", "_")
      new_name <- stringr::str_replace_all(new_name, " ", "-")
      file.rename(paste0(i, list.files(i)), paste0(i, new_name))
    }
  }

  invisible(NULL)
}

cutter <- function(x, index, between = NULL, rm_start = FALSE,
                   rm_end = FALSE) {
  checkmate::assert_atomic_vector(x, min.len = 1)
  checkmate::assert_integerish(index, lower = 1, upper = length(x),
                               any.missing = FALSE, all.missing = FALSE,
                               unique = TRUE)
  checkmate::assert_choice(between, c("left", "right"), null.ok = TRUE)
  checkmate::assert_flag(rm_start)
  checkmate::assert_flag(rm_end)

  if (is.null(between)) {
    x <- cut_by(x, index)
  } else {
    x <- cut_between(x, index, between)
  }

  if ((isTRUE(rm_start) || isTRUE(rm_end)) && length(x) == 1) {
    cli::cli_abort(paste0(
      "The cut process returned just one piece. In those cases, ",
      "{cli::col_blue('rm_start')} and {cli::col_blue('rm_end')} ",
      "cannot be {cli::col_red('TRUE')}."
    ))
  }

  if (isTRUE(rm_start) && !length(x) == 1) {
    x <- x[-1]
  }

  if (isTRUE(rm_end) && !length(x) == 1) {
    x <- x[-length(x)]
  }

  x
}

cut_into_parts <- function(x, n) {
  checkmate::assert_integerish(n, lower = 2)
  checkmate::assert_atomic(x, min.len = n)

  cut_size <- ceiling(length(x) / n)
  cut_indexes <- cut_size

  for (i in utils::head(seq(n)[-1], -1)) {
    cut_indexes <- append(
      cut_indexes,
      cut_indexes[length(cut_indexes)] + cut_size
    )
  }

  cutter(x, cut_indexes, between = "right")
}

cut_between <- function(x, index, between) {
  checkmate::assert_atomic_vector(x, min.len = 1)
  checkmate::assert_integerish(index, lower = 1, upper = length(x),
                               any.missing = FALSE, all.missing = FALSE,
                               unique = TRUE)
  checkmate::assert_choice(between, c("left", "right"))

  out <- list()

  if (between == "left") {
    for (i in index) {
      i_index <- which(index == i)
      j <- length(out) + 1

      if (i == index[1]) {
        if (!i == 1) {
          out[[1]] <- x[seq(1, i - 1)]
          j <- 2
        }

        if (length(index) == 1) {
          out[[j]] <- x[seq(i, length(x))]
        } else {
          out[[j]] <- x[seq(i, index[i_index + 1] - 1)]
        }
      } else if (i == index[length(index)]) {
        out[[j]] <- x[seq(i, length(x))]
      } else {
        out[[j]] <- x[seq(i, index[i_index + 1] - 1)]
      }
    }
  } else {
    for (i in index) {
      i_index <- which(index == i)
      j <- length(out) + 1

      if (i == index[1]) {
        out[[1]] <- x[seq(1, i)]

        if (length(index) == 1) {
          out[[2]] <- x[seq(i + 1, length(x))]
        }
      } else if (i == index[length(index)] && !i == length(x)) {
        out[[j]] <- x[seq(index[i_index - 1] + 1, i)]
        out[[j + 1]] <- x[seq(i + 1, length(x))]
      } else {
        out[[j]] <- x[seq(index[i_index - 1] + 1, i)]
      }
    }
  }

  out
}

cut_by <- function(x, index) {
  checkmate::assert_atomic_vector(x, min.len = 1)
  checkmate::assert_integerish(index, lower = 1, upper = length(x),
                               any.missing = FALSE, all.missing = FALSE,
                               unique = TRUE)

  if (index[1] == 1 || index[length(index)] == length(x)) {
    cli::cli_abort(paste0(
      "When {cli::col_red('between = NULL')}, an index cannot be ",
      "in the start or at the end of an object."
    ))
  }

  if (any(Reduce("-", index) == -1)) {
    cli::cli_abort(paste0(
      "When {cli::col_red('between = NULL')}, indexes must have at ",
      "least a distance of {cli::col_red(1)} between each other."
    ))
  }

  out <- list()

  for (i in index) {
    i_index <- which(index == i)
    j <- length(out) + 1

    if (i == index[1]) {
      out[[j]] <- x[seq(1, i - 1)]

      if (length(index) == 1) {
        out[[j + 1]] <- x[seq(i + 1, length(x))]
      } else {
        out[[j + 1]] <- x[seq(i + 1, index[i_index + 1] - 1)]
      }
    } else if (i == index[length(index)]) {
      out[[j]] <- x[seq(i + 1, length(x))]
    } else {
      out[[j]] <- x[seq(i + 1, index[i_index + 1] - 1)]
    }
  }

  out
}
