# Sort functions by type or use the alphabetical order.

backtick_ <- function(x) paste0("`", x, "`")
single_quote_ <- function(x) paste0("'", x, "'")
double_quote_ <- function(x) paste0("\"", x, "\"")
single_underline_ <- function(x) paste0("_", x, "_")
double_underline_ <- function(x) paste0("__", x, "__")

enclosure <- function(x, type = "double quote") {
  choices <- c("single quote", "double quote", "round bracket",
               "curly bracket", "square bracket", "single underline",
               "double underline", "backtick")

  checkmate::assert_choice(type, choices)

  x <- as.character(x)

  if (type == "single quote") {
    paste0("'", x, "'")
  } else if (type == "double quote") {
    paste0("\"", x, "\"")
  } else if (type == "round bracket") {
    paste0("(", x, ")")
  } else if (type == "curly bracket") {
    paste0("{", x, "}")
  } else if (type == "square bracket") {
    paste0("[", x, "]")
  } else if (type == "single underline") {
    paste0("_", x, "_")
  } else if (type == "double underline") {
    paste0("__", x, "__")
  } else if (type == "backtick") {
    paste0("`", x, "`")
  }
}

escape_regex <- function(x) {
  checkmate::assert_atomic(x)

  gsub("([.|()\\^{}+$*?]|\\[|\\])", "\\\\\\1", x)
}

paste_collapse <- function(x, sep = "", last = sep) {
  checkmate::assert_string(sep)
  checkmate::assert_string(last)

  if (length(x) == 1) {
    x
  } else {
    paste0(paste(x[-length(x)], collapse = sep), last, x[length(x)])
  }
}

inline_collapse <- function(x, last = "and", single_quote = TRUE,
                            serial_comma = TRUE) {
  checkmate::assert_string(last)
  checkmate::assert_flag(single_quote)
  checkmate::assert_flag(serial_comma)

  if (isTRUE(single_quote)) x <- single_quote_(x)

  if (length(x) <= 2 || isFALSE(serial_comma)) {
    paste_collapse(x, sep = ", ", last = paste0(" ", last, " "))
  } else {
    paste_collapse(x, sep = ", ", last = paste0(", ", last, " "))
  }
}

rm_pattern <- function(x, pattern, ignore_case = TRUE) {
  checkmate::assert_atomic(x)
  checkmate::assert_string(pattern)
  checkmate::assert_flag(ignore_case)

  x[!grepl(pattern, x, ignore.case = ignore_case)]
}

str_extract_ <- function(string, pattern, ignore_case = FALSE, perl = TRUE,
                         fixed = FALSE, use_bytes = FALSE, invert = FALSE) {
  checkmate::assert_string(pattern)
  checkmate::assert_flag(ignore_case)
  checkmate::assert_flag(perl)
  checkmate::assert_flag(fixed)
  checkmate::assert_flag(use_bytes)
  checkmate::assert_flag(invert)

  match <- regexpr(pattern, string, ignore.case = ignore_case, perl = perl,
                   fixed = fixed, useBytes = use_bytes)
  out <- rep(NA, length(string))
  out[match != -1 & !is.na(match)] <- regmatches(string, match,
                                                 invert = invert)
  out
}

str_subset_ <- function(string, pattern, negate = FALSE, ignore_case = FALSE,
                        perl = TRUE, fixed = FALSE, use_bytes = FALSE) {
  checkmate::assert_string(pattern)
  checkmate::assert_flag(negate)
  checkmate::assert_flag(ignore_case)
  checkmate::assert_flag(perl)
  checkmate::assert_flag(fixed)
  checkmate::assert_flag(use_bytes)

  match <- grepl(pattern, string, ignore.case = ignore_case, perl = perl,
                 fixed = fixed, useBytes = use_bytes)

  if (isTRUE(negate)) {
    out <- subset(string, !match)
  } else {
    out <- subset(string, match)
  }

  if (length(out) == 0) as.character(NA) else out
}

get_file_ext <- function(file_path) {
  checkmate::assert_string(file_path)

  file_path |>
    basename() |>
    stringr::str_extract("\\.[[:alnum:]]+$")
}

get_file_name_without_ext <- function(file_path) {
  checkmate::assert_string(file_path)

  ext <- get_file_ext(file_path)

  if (is.na(ext)) {
    file_path |> basename()
  } else {
    file_path |>
      basename() |>
      stringr::str_replace(paste0("\\", ext, "$"), "")
  }
}

extract_initials <- function(x, sep = ". ") {
  checkmate::assert_string(x)

  if (!grepl(" ", x)) {
    substr(x, 1, 1)
  } else {
    x <- gsub("(?<=[A-Z])[^A-Z]+", sep, x, perl = TRUE)
    trimws(x)
  }
}
