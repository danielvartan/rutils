class_collapse <- function(x) {
  single_quote_(paste0(class(x), collapse = "/"))
}
