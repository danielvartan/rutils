# library(checkmate)
# library(cli)

cli_color_function <- function(color, type = "col", as_string = TRUE) {
  checkmate::assert_choice(color, cli_color_choices())
  checkmate::assert_choice(type, c("col", "bg"))
  checkmate::assert_flag(as_string)

  fun_name <- switch(
    color,
    black = paste0(type, "_black"),
    blue = paste0(type, "_blue"),
    cyan = paste0(type, "_cyan"),
    green = paste0(type, "_green"),
    magenta = paste0(type, "_magenta"),
    red = paste0(type, "_red"),
    white = paste0(type, "_white"),
    yellow = paste0(type, "_yellow")
  )

  if (isTRUE(as_string)) {
    paste0("cli::", fun_name)
  } else {
    envir <- loadNamespace("cli")

    fun_name |> get(envir = envir)
  }
}

cli_color_choices <- function() {
  c(
    "black", "blue", "cyan", "green", "magenta", "red",
    "white", "yellow"
  )
}
