# library(checkmate)
# library(here)
# library(rbbt)
# library(stringr)

bbt_scan_citation_keys <- function(wd = here::here(),
                                   dir = c("", "qmd", "tex"),
                                   pattern = "\\.qmd$|\\.tex$",
                                   ignore = NULL) {
  checkmate::assert_string(wd)
  checkmate::assert_directory_exists(wd, access = "rw")
  checkmate::assert_character(dir)
  for (i in dir) checkmate::assert_directory_exists(file.path(wd, i))
  checkmate::assert_string(pattern)
  checkmate::assert_string(ignore, null.ok = TRUE)

  bbt_types <- c(
    "article", "booklet", "conference", "inbook", "incollection",
    "inproceedings", "manual", "mastersthesis", "misc", "phdthesis",
    "proceedings", "techreport", "unpublished"
  )

  out <- dir |>
    lapply(function(x) {
      setdiff(
        list.files(file.path(wd, x), full.names = TRUE),
        list.dirs(file.path(wd, x), recursive = FALSE, full.names = TRUE)
      ) |>
        stringr::str_subset(pattern)
    }) |>
    unlist() |>
    rbbt::bbt_detect_citations() |>
    sort()

  out <-
    out[!out %in% bbt_types] |>
    stringr::str_subset("^fig-|^sec-", negate = TRUE)

  if (!is.null(ignore)) {
    out |> stringr::str_subset(ignore, negate = TRUE)
  } else {
    out
  }
}

# library(checkmate)
# library(here)
# library(rbbt)

bbt_write_quarto_bib <- function(wd = here::here(),
                                 bib_file = "references.json",
                                 dir = c("", "qmd", "tex"),
                                 pattern = "\\.qmd$|\\.tex$",
                                 ignore = NULL) {
  checkmate::assert_string(wd)
  checkmate::assert_directory_exists(wd, access = "rw")
  checkmate::assert_string(bib_file)
  checkmate::assert_path_for_output(bib_file, overwrite = TRUE)
  checkmate::assert_character(dir)
  for (i in dir) checkmate::assert_directory_exists(file.path(wd, i))
  checkmate::assert_string(pattern)
  checkmate::assert_string(ignore, null.ok = TRUE)

  keys <- bbt_scan_citation_keys(
    wd = wd,
    dir = dir,
    pattern = pattern,
    ignore = ignore
  )

  rbbt::bbt_write_bib(
    path = bib_file,
    keys = keys,
    overwrite = TRUE
  )

  invisible()
}

# library(checkmate)
# library(cli)
# library(here)

set_quarto_speel_check <- function(wd = here::here()) {
  checkmate::assert_string(wd)
  checkmate::assert_directory_exists(wd, access = "rw")

  if (checkmate::test_file_exists("WORDLIST", "r")) {
    cli::cli_alert_info(
      paste0(
        "No need for setting. ",
        "You already have a {.strong {cli::col_blue('WORDLIST')}} ",
        "file on your project."
      )
    )
  } else {
    create_file(file.path(wd, "WORDLIST"))

    cli::cli_alert_success(
      paste0(
        "All set! The wordlist file was created on ",
        "{.strong {cli::col_blue(file.path(wd, 'WORDLIST'))}}. ",
        "Use {.strong `spell_check_quarto()`} and ",
        "{.strong `update_quarto_wordlist()`} ",
        "to check the spelling of your Quarto documents."
      )
    )
  }

  invisible()
}

# library(checkmate)
# library(dplyr)
# library(here)
# library(spelling)
# library(stringr)

gather_words_from_spell_check <- function(wd = here::here(),
                                          dir = c("", "qmd", "tex"),
                                          pattern = "\\.qmd$|\\.Rmd$|\\.tex$",
                                          ignore = NULL) {
  checkmate::assert_string(wd)
  checkmate::assert_directory_exists(wd, access = "rw")
  checkmate::assert_character(dir)
  for (i in dir) checkmate::assert_directory_exists(file.path(wd, i))
  checkmate::assert_string(pattern)
  checkmate::assert_string(ignore, null.ok = TRUE)

  # R CMD Check variable bindings fix (see <https://bit.ly/3z24hbU>)
  # nolint start: object_usage_linter.
  word <- NULL
  # nolint end

  files <- list_quarto_files(
    wd = wd,
    dir = dir,
    pattern = pattern,
    ignore = ignore
  )

  bbt_citations <-
    bbt_scan_citation_keys(
      wd = wd,
      dir = dir,
      pattern = pattern,
      ignore = NULL
    )

  out <-
    files |>
    spelling::spell_check_files() |>
    dplyr::filter(!word %in% bbt_citations,!word == "")

  if (!is.null(ignore)) {
    out |> dplyr::filter(stringr::str_detect(word, ignore, negate = TRUE))
  } else {
    out
  }
}

# library(checkmate)
# library(cli)
# library(dplyr)
# library(here)

spell_check_quarto <- function(wd = here::here(),
                               dir = c("", "qmd", "tex"),
                               pattern = c("\\.qmd$|\\.Rmd$|\\.tex$"),
                               ignore = NULL,
                               wordlist = "WORDLIST") {
  checkmate::assert_string(wd)
  checkmate::assert_directory_exists(wd, access = "rw")
  checkmate::assert_character(dir)
  for (i in dir) checkmate::assert_directory_exists(file.path(wd, i))
  checkmate::assert_string(pattern)
  checkmate::assert_string(ignore, null.ok = TRUE)
  checkmate::assert_string(wordlist, null.ok = TRUE)

  # R CMD Check variable bindings fix (see <https://bit.ly/3z24hbU>)
  # nolint start: object_usage_linter.
  word <- NULL
  # nolint end

  out <- gather_words_from_spell_check(
    wd = wd,
    dir = dir,
    pattern = pattern,
    ignore = ignore
  )

  if (!is.null(wordlist)) {
    if (checkmate::test_file_exists(file.path(wd, wordlist), "r")) {
      wordlist_char <- readLines(wordlist)

      out <- out |> dplyr::filter(!word %in% wordlist_char)
    } else {
      cli::cli_alert_warning(
        paste0(
          "Wordlist file not found. ",
          "You can create one with ",
          "{.strong `set_quarto_speel_check()`}. ",
          "Use `wordlist = NULL` to suppress this message."
        )
      )
    }
  }

  if (length(out$word) == 0) {
    cli::cli_alert_info(
      paste0(
        "No spelling errors were found. Good job! \U0001F389"
      )
    )
  } else {
    out
  }
}

# library(checkmate)
# library(cli)
# library(here)
# library(magrittr)

update_quarto_wordlist <- function(wd = here::here(),
                                   dir = c("", "qmd", "tex"),
                                   pattern = c("\\.qmd$|\\.Rmd$|\\.tex$"),
                                   ignore = NULL,
                                   wordlist = "WORDLIST") {
  checkmate::assert_string(wd)
  checkmate::assert_directory_exists(wd, access = "rw")
  checkmate::assert_character(dir)
  for (i in dir) checkmate::assert_directory_exists(file.path(wd, i))
  checkmate::assert_string(pattern)
  checkmate::assert_string(ignore, null.ok = TRUE)
  checkmate::assert_string(wordlist, null.ok = TRUE)
  checkmate::assert_file_exists(file.path(wd, wordlist), "r")

  words <-
    gather_words_from_spell_check(
      wd = wd,
      dir = dir,
      pattern = pattern,
      ignore = ignore
    )|>
    magrittr::extract2("word")

  wordlist_char <- readLines(wordlist)
  words_to_add <- words[is.na(match(words, wordlist_char))]
  words_to_remove <- wordlist_char[is.na(match(wordlist_char, words))]
  words_to_keep <- wordlist_char[!is.na(match(wordlist_char, words))]

  if (!length(words_to_add) == 0) {
    cli::cli_h1(
      paste0(
        "The following {length(words_to_add)} words will be ",
        "{.strong {cli::col_blue('added')}} to the ",
        "wordlist", "\n"
      )
    )
    cli::cli_ul(sort(words_to_add))

    ifelse(!length(words_to_remove) == 0, "", cli::cli_rule())
  }

  if (!length(words_to_remove) == 0) {
    cli::cli_h1(
      paste0(
        "The following {length(words_to_remove)} words will be ",
        "{.strong {cli::col_red('removed')}} from the ",
        "wordlist", "\n"
      )
    )
    cli::cli_ul(sort(words_to_remove))
    cli::cli_rule()
  }

  if (!length(words_to_add) == 0 || !length(words_to_remove) == 0) {
    decision <- readline("Do you want to proceed? [Y/n] ")

    while (!decision %in% c("Y", "n")) {
      decision <- readline("Do you want to proceed? [Y/n] ")
    }

    if (decision == "n") {
      return(invisible())
    } else {
      writeLines(sort(words), wordlist)
    }
  } else {
    cli::cli_alert_info(
      paste0(
        "No spelling errors were found. Good job! \U0001F389"
      )
    )
  }

  invisible()
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
# Credits: <https://github.com/hadley/r4ds/blob/main/_common.R>.
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

# library(checkmate)
# library(here)
# library(stringr)

list_quarto_files <- function(wd = here::here(),
                              dir = c("", "qmd"),
                              pattern = "\\.qmd$",
                              ignore = NULL) {
  checkmate::assert_string(wd)
  checkmate::assert_directory_exists(wd, access = "rw")
  checkmate::assert_character(dir)
  for (i in dir) checkmate::assert_directory_exists(file.path(wd, i))
  checkmate::assert_string(pattern)
  checkmate::assert_string(ignore, null.ok = TRUE)

  dir |>
    lapply(function(x) {
      setdiff(
        list.files(file.path(wd, x), full.names = TRUE),
        list.dirs(file.path(wd, x), recursive = FALSE, full.names = TRUE)
      ) |>
        stringr::str_subset(pattern)
    }) |>
    unlist() |>
    stringr::str_subset(ignore, negate = TRUE)
}

# library(checkmate)
# library(here)
# library(stringr)

find_between_tags_and_apply <- function(wd = here::here(),
                                        dir = c("", "qmd"),
                                        pattern = "\\.qmd$",
                                        ignore = "^_",
                                        begin_tag = "&&& title begin &&&",
                                        end_tag = "&&& title end &&&",
                                        fun = stringr::str_to_upper) {
  checkmate::assert_string(wd)
  checkmate::assert_directory_exists(wd, access = "rw")
  checkmate::assert_character(dir)
  for (i in dir) checkmate::assert_directory_exists(file.path(wd, i))
  checkmate::assert_string(pattern)
  checkmate::assert_string(ignore, null.ok = TRUE)
  checkmate::assert_string(begin_tag)
  checkmate::assert_string(end_tag)
  checkmate::assert_function(fun)

  list_quarto_files(
    wd = wd,
    dir = dir,
    pattern = pattern,
    ignore = ignore
  ) |>
    lapply(function(x) {
      new_content <- transform_value_between_tags(
        x = readLines(here::here(x)),
        fun = fun,
        begin_tag = begin_tag,
        end_tag = end_tag
      ) |>
        writeLines(x)
    })
}

# library(checkmate)
# library(cli)

transform_value_between_tags <- function(x,
                                         fun,
                                         begin_tag = "&&& title begin &&&$",
                                         end_tag = "&&& title end &&&") {
  checkmate::assert_character(x)
  checkmate::assert_multi_class(fun, c("character", "function"))
  checkmate::assert_string(begin_tag)
  checkmate::assert_string(end_tag)

  begin_index <- grep("&&& title begin &&&", x = x)
  end_index <- grep("&&& title end &&&", x = x)

  if (length(begin_index) == 0 || length(end_index) == 0) {
    cli::cli_abort("One or both of the tags were not found.")
  }

  if (!length(begin_index) == 1 || !length(end_index) == 1) {
    cli::cli_abort(
      paste0(
        "More than one tag with the same value was found. ",
        "Tags must be unique."
      )
    )
  }

  if (inherits(fun, "function")) {
    fun <- x[inbetween_integers(begin_index, end_index)] |> fun()
  }

  x[seq(1, begin_index)] |>
    append(fun) |>
    append(x[seq(end_index, length(x))])
}
