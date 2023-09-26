# library(checkmate)
# library(rbbt)
# library(stringr)

# See <https://github.com/paleolimbot/rbbt>.
bbt_write_quarto_bib <- function(bib_file, dir, pattern = "\\.qmd$") {
  checkmate::assert_string(bib_file)
  checkmate::assert_path_for_output(bib_file, overwrite = TRUE)
  checkmate::assert_character(dir)
  for (i in dir) checkmate::assert_directory_exists(i)
  checkmate::assert_string(pattern)

  bbt_types <- c(
    "article", "booklet", "conference", "inbook", "incollection",
    "inproceedings", "manual", "mastersthesis", "misc", "phdthesis",
    "proceedings", "techreport", "unpublished"
  )

  keys <-
    dir |>
    lapply(function(x) {
      setdiff(
        list.files(x, full.names = TRUE),
        list.dirs(x, recursive = FALSE, full.names = TRUE)
      ) |>
        stringr::str_subset(pattern)
    }) |>
    unlist() |>
    rbbt::bbt_detect_citations() |>
    sort()

  keys <-
    keys[!keys %in% bbt_types] |>
    stringr::str_subset("^fig-|^sec-", negate = TRUE)

  rbbt::bbt_write_bib(
    path = bib_file,
    keys = keys,
    overwrite = TRUE
  )

  invisible(NULL)
}

# library(checkmate, quietly = TRUE)
# library(here, quietly = TRUE)
# library(yaml, quietly = TRUE)

clean_quarto_mess <- function(wd = here::here(),
                              file = NULL,
                              dir = c(".temp"),
                              ext = c("aux", "cls", "loa", "log", "pdf", "tex"),
                              keep = NULL,
                              quarto_yaml = NULL) {
  checkmate::assert_string(wd)
  checkmate::assert_directory_exists(wd, access = "rw")
  checkmate::assert_character(file, null.ok = TRUE)
  checkmate::assert_character(dir, null.ok = TRUE)
  checkmate::assert_character(ext, null.ok = TRUE)
  checkmate::assert_character(keep, null.ok = TRUE)
  checkmate::assert_string(quarto_yaml, null.ok = TRUE)

  if (!is.null(quarto_yaml)) {
    checkmate::assert_file_exists(quarto_yaml, access = "r", extension = "yml")
    quarto_vars <- yaml::read_yaml("_quarto.yml")

    if (isTRUE(quarto_vars$format$`tesesusp-pdf`$`keep-tex`)) {
      keep <-
        keep |>
        append(list.files(wd, full.names = TRUE, pattern = ".tex$"))
    }
  }

  ext_files <- list.files(
    wd,
    pattern = paste0("\\.", ext[!ext %in% keep], "$", collapse = "|")
  )

  if (!length(ext_files) == 0) file <- file |> append(ext_files)

  for (i in file[!file %in% keep]) {
    if (checkmate::test_file_exists(file.path(wd, i))) {
      delete_file(i)
    }
  }

  for (i in dir[!dir %in% keep]) {
    if (checkmate::test_directory_exists(file.path(wd, i))) {
      delete_dir(i)
    }
  }

  invisible(NULL)
}

# library(cli, quietly = TRUE)

# use '#| output: asis'
quarto_status <- function(type) {
  status <- switch(
    type,
    polishing = paste0(
      "should be readable but is currently undergoing final polishing"
    ),
    restructuring = paste0(
      "is undergoing heavy restructuring and may be confusing or incomplete"
    ),
    drafting = paste0(
      "is currently a dumping ground for ideas, and I don't recommend", " ",
      "reading it"
    ),
    complete = "is largely complete and just needs final proof reading",
    cli::cli_abort("Invalid {.strong {cli::col_red('type')}}.")
  )

  class <- switch(
    type,
    polishing = "note",
    restructuring = "important",
    drafting = "important",
    complete = "note"
  )

  cat(paste0(
    "\n",
    "::: {.callout-", class, "}", "\n",
    "You are reading the work-in-progress of this thesis.", " ",
    "This chapter ", status, ".", "\n",
    ":::",
    "\n"
  ))
}
