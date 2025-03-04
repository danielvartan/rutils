# Sort functions by type or use the alphabetical order.

# library(checkmate, quietly = TRUE)
# library(cli, quietly = TRUE)

copy_file <- function(from,
                      to,
                      overwrite = TRUE,
                      recursive = FALSE,
                      copy.mode = TRUE,
                      copy.date = FALSE) {
  checkmate::assert_character(from)
  checkmate::assert_file_exists(from)
  checkmate::assert_character(to)
  checkmate::assert_flag(overwrite)
  checkmate::assert_flag(recursive)
  checkmate::assert_flag(copy.mode)
  checkmate::assert_flag(copy.date)

  status <- file.copy(
    from,
    to,
    overwrite = overwrite,
    recursive = recursive,
    copy.mode = copy.mode,
    copy.date = copy.date
  ) |>
    shush()

  for (i in seq_along(status)) {
    if (isFALSE(status[i])) {
      cli::cli_alert_warning(paste0(
        "The attempt to copy the file ",
        "{.strong {cli::col_blue(from[i])}} to ",
        "{.strong {cli::col_red(to[i])}} ",
        "was unsuccessful."
      ))
    }
  }

  invisible()
}

# library(checkmate, quietly = TRUE)
# library(cli, quietly = TRUE)

create_file <- function(file) {
  checkmate::assert_character(file)

  for (i in file) {
    checkmate::assert_directory_exists(dirname(i))
  }

  for (i in file) {
    if (checkmate::test_file_exists(i)) {
      cli::cli_alert_warning(
        paste0(
          "The file ",
          "{.strong {cli::col_red(i)}} ",
          "already exists."
        )
      )

      file <- file[!file == i]
    }
  }

  status <- file.create(file, showWarnings = FALSE) |> shush()

  for (i in seq_along(status)) {
    if (isFALSE(status[i])) {
      cli::cli_alert_warning(
        paste0(
          "The attempt to create the file ",
          "{.strong {cli::col_red(file[i])}} ",
          "was unsuccessful."
        )
      )
    }
  }

  invisible()
}

# library(checkmate, quietly = TRUE)
# library(cli, quietly = TRUE)

delete_dir <- function(...) {
  checkmate::assert_character(unlist(list(...)))
  checkmate::assert_directory_exists(unlist(list(...)))

  dir <- unlist(list(...))
  status <- unlink(dir, recursive = TRUE) |> shush()

  for (i in seq_along(status)) {
    if (status[i] == 1) {
      cli::cli_alert_warning(paste0(
        "The attempt to remove the directory ",
        "{.strong {cli::col_red(dir[i])}} ",
        "was unsuccessful."
      ))
    }
  }

  invisible()
}

# library(checkmate, quietly = TRUE)
# library(cli, quietly = TRUE)

delete_file <- function(...) {
  checkmate::assert_character(unlist(list(...)))
  checkmate::assert_file_exists(unlist(list(...)))

  file <- unlist(list(...))
  status <- suppressWarnings(file.remove(...)) |> shush()

  for (i in seq_along(status)) {
    if (isFALSE(status[i])) {
      cli::cli_alert_warning(paste0(
        "The attempt to remove the file ",
        "{.strong {cli::col_red(file[i])}} ",
        "was unsuccessful."
      ))
    }
  }

  invisible()
}

# library(tools)

find_absolute_path <- function(relative_path) {
  require_pkg("tools")

  vapply(
    relative_path, tools::file_path_as_absolute, character(1),
    USE.NAMES = FALSE
  )
}

# library(checkmate)
# library(here)

find_path <- function(dir, package = NULL) {
  checkmate::assert_string(dir)
  checkmate::assert_string(package, null.ok = TRUE)
  if (is.null(package)) package <- here::here() |> basename()

  root <- system.file(package = package)

  if (!stringr::str_detect(root, "inst/?$") &&
      any(stringr::str_detect("^inst$", list.files(root)), na.rm = TRUE)) {

    system.file(paste0("inst/", dir), package = package)
  } else {
    system.file(dir, package = package)
  }
}

# library(checkmate, quietly = TRUE)

list_files <- function(path = ".",
                       pattern = NULL,
                       all.files = FALSE,
                       full.names = FALSE,
                       recursive = FALSE,
                       ignore.case = FALSE,
                       include.dirs = FALSE,
                       no.. = FALSE) {
  checkmate::assert_string(path)
  checkmate::assert_directory_exists(path)
  checkmate::assert_string(pattern, null.ok = TRUE)
  checkmate::assert_flag(all.files)
  checkmate::assert_flag(full.names)
  checkmate::assert_flag(recursive)
  checkmate::assert_flag(ignore.case)
  checkmate::assert_flag(include.dirs)
  checkmate::assert_flag(no..)

  setdiff(
    list.files(
      path = path,
      pattern = pattern,
      all.files = all.files,
      full.names = full.names,
      recursive = recursive,
      ignore.case = ignore.case,
      include.dirs = include.dirs,
      no.. = no..
    ),
    list.dirs(
      path = path,
      full.names = full.names,
      recursive = recursive
    )
  )
}

# library(checkmate, quietly = TRUE)
# library(cli, quietly = TRUE)

rename_file <- function(from, to) {
  checkmate::assert_character(from)
  checkmate::assert_file_exists(from)

  status <- file.rename(from, to) |> shush()

  for (i in seq_along(status)) {
    if (isFALSE(status[i])) {
      cli::cli_alert_warning(paste0(
        "The attempt to rename the file ",
        "{.strong {cli::col_blue(from[i])}} to ",
        "{.strong {cli::col_red(to[i])}} ",
        "was unsuccessful."
      ))
    }
  }

  invisible()
}

require_pkg <- function(...) {
  out <- list(...)

  lapply(out, checkmate::assert_string,
         pattern = "^[A-Za-z][A-Za-z0-9.]+[A-Za-z0-9]$")

  if (!identical(unique(unlist(out)), unlist(out))) {
    cli::cli_abort("'...' cannot have duplicated values.")
  }

  pkg <- unlist(out)
  namespace <- vapply(pkg, require_namespace, logical(1),
                      quietly = TRUE, USE.NAMES = FALSE)
  pkg <- pkg[!namespace]

  if (length(pkg) == 0) {
    invisible(NULL)
  } else {
    cli::cli_abort(
      paste0(
        "This function requires the {single_quote_(pkg)} package{?s} ",
        "to run. You can install {?it/them} by running:", "\n\n",
        "install.packages(c(",
        "{paste(double_quote_(pkg), collapse = ', ')}",
        "))"
      )
    )
  }
}

list_files <- function(dir = utils::choose.dir()) {
  list.files(dir, full.names = TRUE)[!(
    list.files(dir, full.names = TRUE) %in% list.dirs(dir, full.names = TRUE)
  )]
}
