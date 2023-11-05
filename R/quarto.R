# library(checkmate)
# library(here)
# library(rbbt)
# library(stringr)

bbt_scan_citation_keys <- function(dir = c("", "qmd", "tex"),
                                   pattern = "\\.qmd$|\\.tex$",
                                   ignore = NULL,
                                   wd = here::here()) {
  checkmate::assert_string(wd)
  checkmate::assert_directory_exists(wd)
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

bbt_write_quarto_bib <- function(bib_file = "references.json",
                                 dir = c("", "qmd", "tex"),
                                 pattern = "\\.qmd$|\\.tex$",
                                 ignore = NULL,
                                 wd = here::here()) {
  checkmate::assert_string(wd)
  checkmate::assert_directory_exists(wd)
  checkmate::assert_string(bib_file)
  checkmate::assert_path_for_output(bib_file, overwrite = TRUE)
  checkmate::assert_character(dir)
  for (i in dir) checkmate::assert_directory_exists(file.path(wd, i))
  checkmate::assert_string(pattern)
  checkmate::assert_string(ignore, null.ok = TRUE)

  keys <- bbt_scan_citation_keys(
    dir = dir,
    pattern = pattern,
    ignore = ignore,
    wd = wd
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
  checkmate::assert_directory_exists(wd)

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
# library(here)
# library(stringr)

list_quarto_files <- function(dir = c("", "qmd"),
                              pattern = "\\.qmd$",
                              ignore = NULL,
                              wd = here::here()) {
  checkmate::assert_string(wd)
  checkmate::assert_directory_exists(wd)
  checkmate::assert_character(dir)
  for (i in dir) checkmate::assert_directory_exists(file.path(wd, i))
  checkmate::assert_string(pattern)
  checkmate::assert_string(ignore, null.ok = TRUE)

  out <- dir |>
    lapply(function(x) {
      setdiff(
        list.files(file.path(wd, x), full.names = TRUE),
        list.dirs(file.path(wd, x), recursive = FALSE, full.names = TRUE)
      ) |>
        stringr::str_subset(pattern)
    }) |>
    unlist()

  if (!is.null(ignore)) {
    out |> stringr::str_subset(ignore, negate = TRUE)
  } else {
    out
  }
}

# library(checkmate)
# library(dplyr)
# library(here)
# library(spelling)
# library(stringr)

gather_words_from_spell_check <- function(dir = c("", "qmd", "tex"),
                                          pattern = "\\.qmd$|\\.Rmd$|\\.tex$",
                                          ignore = NULL,
                                          wd = here::here()) {
  checkmate::assert_string(wd)
  checkmate::assert_directory_exists(wd)
  checkmate::assert_character(dir)
  for (i in dir) checkmate::assert_directory_exists(file.path(wd, i))
  checkmate::assert_string(pattern)
  checkmate::assert_string(ignore, null.ok = TRUE)

  # R CMD Check variable bindings fix (see <https://bit.ly/3z24hbU>)
  # nolint start: object_usage_linter.
  word <- NULL
  # nolint end

  files <- list_quarto_files(
    dir = dir,
    pattern = pattern,
    ignore = ignore,
    wd = wd
  )

  bbt_citations <-
    bbt_scan_citation_keys(
      dir = dir,
      pattern = pattern,
      ignore = NULL,
      wd = wd
    )

  files |>
    spelling::spell_check_files() |>
    dplyr::filter(!word %in% bbt_citations,!word == "")
}

# library(checkmate)
# library(cli)
# library(dplyr)
# library(here)

spell_check_quarto <- function(dir = c("", "qmd", "tex"),
                               pattern = c("\\.qmd$|\\.Rmd$|\\.tex$"),
                               ignore = NULL,
                               wordlist = "WORDLIST",
                               wd = here::here()) {
  checkmate::assert_string(wd)
  checkmate::assert_directory_exists(wd)
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
    dir = dir,
    pattern = pattern,
    ignore = ignore,
    wd = wd
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

update_quarto_wordlist <- function(dir = c("", "qmd", "tex"),
                                   pattern = c("\\.qmd$|\\.Rmd$|\\.tex$"),
                                   ignore = NULL,
                                   wordlist = "WORDLIST",
                                   wd = here::here()) {
  checkmate::assert_string(wd)
  checkmate::assert_directory_exists(wd)
  checkmate::assert_character(dir)
  for (i in dir) checkmate::assert_directory_exists(file.path(wd, i))
  checkmate::assert_string(pattern)
  checkmate::assert_string(ignore, null.ok = TRUE)
  checkmate::assert_string(wordlist, null.ok = TRUE)
  checkmate::assert_file_exists(file.path(wd, wordlist), "r")

  words <-
    gather_words_from_spell_check(
      dir = dir,
      pattern = pattern,
      ignore = ignore,
      wd = wd
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
    cli::cli_alert_info("No spelling errors were found. Good job! \U0001F389")
  }

  invisible()
}

# library(checkmate, quietly = TRUE)
# library(here, quietly = TRUE)
# library(yaml, quietly = TRUE)

clean_quarto_mess <- function(file = NULL,
                              dir = c(""),
                              ext = c("aux", "cls", "loa", "log"),
                              ignore = NULL,
                              wd = here::here()) {
  checkmate::assert_string(wd)
  checkmate::assert_directory_exists(wd)
  checkmate::assert_character(file, null.ok = TRUE)
  checkmate::assert_character(dir)
  checkmate::assert_character(ext, null.ok = TRUE)
  checkmate::assert_character(ignore, null.ok = TRUE)

  ext_files <- list.files(
    wd,
    pattern = paste0("\\.", ext, "$", collapse = "|")
  )

  if (!length(ext_files) == 0) file <- file |> append(ext_files)

  if (!is.null(ignore)) {
    file <- file |> stringr::str_subset(ignore, negate = TRUE)
  }

  for (i in file) {
    if (checkmate::test_file_exists(file.path(wd, i))) {
      delete_file(i)
    }
  }

  for (i in dir) {
    if (checkmate::test_directory_exists(file.path(wd, i))) {
      delete_dir(i)
    }
  }

  invisible()
}

# library(cli, quietly = TRUE)

# Use '#| output: asis'
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

apply_on_value_between_tags <- function(
    dir = c("", "qmd"),
    pattern = "\\.qmd$",
    ignore = "^_",
    begin_tag = "%:::% .common h1 begin %:::%",
    end_tag = "%:::% .common h1 end %:::%",
    fun = stringr::str_to_upper,
    wd = here::here()
    ) {
  checkmate::assert_string(wd)
  checkmate::assert_directory_exists(wd)
  checkmate::assert_character(dir)
  for (i in dir) checkmate::assert_directory_exists(file.path(wd, i))
  checkmate::assert_string(pattern)
  checkmate::assert_string(ignore, null.ok = TRUE)
  checkmate::assert_string(begin_tag)
  checkmate::assert_string(end_tag)
  checkmate::assert_function(fun)

  list_quarto_files(
    dir = dir,
    pattern = pattern,
    ignore = ignore,
    wd = wd
  ) |>
    lapply(function(x) {
      swap_value_between_tags(
        x = readLines(here::here(x)),
        value = fun,
        begin_tag = begin_tag,
        end_tag = end_tag
      ) |>
        writeLines(x)

      invisible()
    })

  invisible()
}

# library(checkmate)
# library(cli)

get_value_between_tags <- function(
    x,
    begin_tag = "%:::% .common h1 begin %:::%",
    end_tag = "%:::% .common h1 end %:::%") {
  checkmate::assert_character(x)
  checkmate::assert_string(begin_tag)
  checkmate::assert_string(end_tag)

  if (length(x) == 1 && checkmate::test_file_exists(x)) x <- readLines(x)

  begin_index <- grep(begin_tag, x = x)
  end_index <- grep(end_tag, x = x)

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

  x[inbetween_integers(begin_index, end_index)]
}

# library(checkmate)
# library(cli)

swap_value_between_tags <- function(
    x,
    value,
    begin_tag = "%:::% .common h1 begin %:::%",
    end_tag = "%:::% .common h1 end %:::%") {
  checkmate::assert_character(x)
  checkmate::assert_multi_class(value, c("character", "function"))
  checkmate::assert_string(begin_tag)
  checkmate::assert_string(end_tag)

  if (length(x) == 1 && checkmate::test_file_exists(x)) x <- readLines(x)

  begin_index <- grep(begin_tag, x = x)
  end_index <- grep(end_tag, x = x)

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

  if (inherits(value, "function")) {
    value <- x[inbetween_integers(begin_index, end_index)] |> value()
  }

  x[seq(1, begin_index)] |>
    append(value) |>
    append(x[seq(end_index, length(x))])
}

# library(checkmate)
# library(dplyr)
# library(stringr)

swap_value_between_files <- function(from,
                                     to = from,
                                     begin_tag,
                                     end_tag,
                                     value,
                                     quarto_render = FALSE,
                                     cite_method = "biblatex") {
  checkmate::assert_string(from)
  checkmate::assert_file_exists(from, "r")
  checkmate::assert_string(to)
  checkmate::assert_file_exists(to, "rw")
  checkmate::assert_string(begin_tag)
  checkmate::assert_string(end_tag)
  checkmate::assert_multi_class(
    value, c("character", "function"), null.ok = TRUE
    )
  checkmate::assert_flag(quarto_render)
  checkmate::assert_choice(cite_method, c("citeproc", "biblatex", "natbib"))

  # nolint start: object_usage_linter.
  from_format <- to_format  <- NULL
  # nolint end

  if (!identical(from, to) && is.null(value)) {
    value <- get_value_between_tags(
      x = from,
      begin_tag = begin_tag,
      end_tag = end_tag
    )
  }

  if (isTRUE(quarto_render) &&
      stringr::str_detect(from, "\\.tex$", negate = TRUE) &&
      stringr::str_detect(to, "\\.tex$")) {
    value <- object_quarto_render(
      x = value,
      output_format = "latex",
      cite_method = "biblatex"
    )
  }

  swap_value_between_tags(
    x = to,
    value = value,
    begin_tag = begin_tag,
    end_tag = end_tag
  )|>
    writeLines(to)

  invisible()
}

# library(checkmate)
# library(quarto)

# object_quarto_render("Hello [World](http://www.test.com). @test")
object_quarto_render <- function(x,
                                 output_format = "latex",
                                 cite_method = "biblatex") {
  checkmate::assert_character(x, min.len = 1)
  checkmate::assert_choice(output_format, c("html", "latex"))
  checkmate::assert_choice(cite_method, c("citeproc", "biblatex", "natbib"))

  ext <- switch(
    output_format,
    html = ".html",
    latex = ".tex"
  )

  in_file <- tempfile(fileext = ".qmd")
  out_file <- file.path(
    dirname(in_file),
    paste0(get_file_name_without_ext(in_file), ext)
    )

  if (output_format == "latex") {
    begin_tag <- "%:::% clip start %:::%"
    end_tag <- "%:::% clip end %:::%"
  } else {
    begin_tag <- "<-- %:::% clip start %:::% -->"
    end_tag <- "<--%:::% clip end %:::% -->"
  }

  fake_content <- c(
    "---",
    "format:",
    paste0("  ", output_format, ":"),
    paste0("    cite-method: ", cite_method),
    "---",
    "",
    "# Placeholder",
    "",
    ifelse(output_format == "latex", "```{=latex}", ""),
    begin_tag,
    ifelse(output_format == "latex", "```", ""),
    "",
    x,
    "",
    ifelse(output_format == "latex", "```{=latex}", ""),
    end_tag,
    ifelse(output_format == "latex", "```", "")
  )

  writeLines(fake_content, in_file)
  quarto::quarto_render(input = in_file, quiet = TRUE)

  get_value_between_tags(
    x = readLines(out_file),
    begin_tag = begin_tag,
    end_tag = end_tag
  )
}

# library(checkmate)
# library(rmarkdown)

# object_pandoc_convert("Hello [World](https://www.teste.com.br/)")
object_pandoc_convert <- function(x,
                                  from = "markdown",
                                  to = "latex",
                                  citeproc = FALSE,
                                  options = NULL,
                                  verbose = FALSE) {
  checkmate::assert_character(x)
  checkmate::assert_string(from, null.ok = TRUE)
  checkmate::assert_string(to, null.ok = TRUE)
  checkmate::assert_flag(citeproc)
  checkmate::assert_character(options, null.ok = TRUE)
  checkmate::assert_flag(verbose)

  in_file <- tempfile()
  out_file <- tempfile()
  writeLines(x, in_file)

  rmarkdown::pandoc_convert(
    input = in_file,
    to = to,
    from = from,
    output = out_file,
    citeproc = citeproc,
    options = options,
    verbose = verbose,
    wd = tempdir()
  ) |>
    shush()

  readLines(out_file)
}

# library(checkmate)
# library(stringr)

convert_quarto_ref_to_latex <- function(x) {
  checkmate::assert_character(x, min.len = 1)

  stringr::str_replace_all(
    x,
    "@.+",
    ~ paste0("\\textcite{", substring(.x, 2), "}")
  )
}

# library(checkmate)
# library(cli)
# library(stringr)

check_missing_dollar_signs <- function(file) {
  checkmate::assert_file_exists(file, "r")

  data <- file |> readLines()
  out <- character()

  for (i in seq_along(data)) {
    signs <-
      data[i] |>
      stringr::str_extract_all("\\$") |>
      unlist()

    if (!length(signs) %% 2 == 0) {
      out <- out |> append(i)

      cli::cli_alert_warning(paste0(
        "A missing dollar sign was found on line ",
        "{.strong {cli::col_red(i)}}."
      ))
    }
  }

  out
}

# library(checkmate)
# library(cli)
# library(stringr)

check_missing_dollar_signs_in_dir <- function(
    dir = c("_extensions", "_extensions/tex"),
    pattern = "\\.tex$",
    ignore = NULL,
    wd = here::here()) {
  checkmate::assert_string(wd)
  checkmate::assert_directory_exists(wd)
  checkmate::assert_character(dir)
  for (i in dir) checkmate::assert_directory_exists(file.path(wd, i))
  checkmate::assert_string(pattern)
  checkmate::assert_string(ignore, null.ok = TRUE)

  files <- dir |>
    lapply(function(x) {
      setdiff(
        list.files(file.path(wd, x), full.names = TRUE),
        list.dirs(file.path(wd, x), recursive = FALSE, full.names = TRUE)
      ) |>
        stringr::str_subset(pattern)
    }) |>
    unlist()

  if (!is.null(ignore)) {
    files <- files |> stringr::str_subset(ignore, negate = TRUE)
  } else {
    files
  }

  for (i in files) {
    test <- shush(check_missing_dollar_signs(i))

    if (!length(test) == 0) {
      cli::cli_h1(paste0("File ", basename(i)))
      check_missing_dollar_signs(i)
    }
  }

  invisible()
}

# library(checkmate)

unfreeze_quarto_file <- function(
    file,
    unfreeze_tag = "<!-- %:::% unfreeze-tag %:::% -->"
    ) {
  checkmate::assert_file_exists(file, "rw")
  checkmate::assert_string(unfreeze_tag)

  data <- readLines(file)

  if (data[1] == unfreeze_tag) {
    data <- data[-1]
  } else {
    data <- append(data, unfreeze_tag, 0)
  }

  data |> writeLines(file)

  invisible()
}

# library(checkmate)
# library(yaml)

add_or_update_env_var <- function(var,
                                  yml_file = here::here("_variables.yml")) {
  checkmate::assert_list(var, min.len = 1)

  if (!checkmate::test_file_exists(yml_file)) {
    checkmate::assert_path_for_output(yml_file, overwrite = TRUE)
    create_file(yml_file)
  }

  yml_file_vars <- yaml::read_yaml(yml_file)
  if (is.null(yml_file_vars)) yml_file_vars <- list()

  for (i in names(var)) yml_file_vars[[i]] <- var[[i]]

  yml_file_vars |> yaml::write_yaml(yml_file)

  invisible()
}
