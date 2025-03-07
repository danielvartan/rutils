# library(checkmate)

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

backtick_ <- function(x) paste0("`", x, "`")
single_quote_ <- function(x) paste0("'", x, "'")
double_quote_ <- function(x) paste0("\"", x, "\"")
single_underline_ <- function(x) paste0("_", x, "_")
double_underline_ <- function(x) paste0("__", x, "__")
