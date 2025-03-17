testthat::test_that("to_title_case_pt() | General test", {
  to_title_case_pt("Desterro de Entre Rios") |>
    testthat::expect_equal("Desterro de entre Rios")

  to_title_case_pt("Pablo Del Rei") |>
    testthat::expect_equal("Pablo del Rei")

  to_title_case_pt("Sant'ana do Livramento") |>
    testthat::expect_equal("Sant'Ana do Livramento")

  to_title_case_pt("Alta Floresta d'Oeste") |>
    testthat::expect_equal("Alta Floresta D'Oeste")

  to_title_case_pt("Abadia que trás") |>
    testthat::expect_equal("Abadia que trás")

  to_title_case_pt("Antônio Senão de Souza") |>
    testthat::expect_equal("Antônio senão de Souza")
})

testthat::test_that("to_title_case_pt() | Error test", {
  # checkmate::assert_character(string)
  to_title_case_pt(
    x = 1,
    articles = TRUE,
    conjunctions = TRUE,
    oblique_pronouns = TRUE,
    prepositions = TRUE,
    custom_rules = "a"
  ) |>
    testthat::expect_error()

  # checkmate::assert_flag(articles)
  to_title_case_pt(
    x = "a",
    articles = "a",
    conjunctions = TRUE,
    oblique_pronouns = TRUE,
    prepositions = TRUE,
    custom_rules = "a"
  ) |>
    testthat::expect_error()

  # checkmate::assert_flag(conjunctions)
  to_title_case_pt(
    x = "a",
    articles = TRUE,
    conjunctions = "a",
    oblique_pronouns = TRUE,
    prepositions = TRUE,
    custom_rules = "a"
  ) |>
    testthat::expect_error()

  # checkmate::assert_flag(oblique_pronouns)
  to_title_case_pt(
    x = "a",
    articles = TRUE,
    conjunctions = TRUE,
    oblique_pronouns = "a",
    prepositions = TRUE,
    custom_rules = "a"
  ) |>
    testthat::expect_error()

  # checkmate::assert_flag(prepositions)
  to_title_case_pt(
    x = "a",
    articles = TRUE,
    conjunctions = TRUE,
    oblique_pronouns = TRUE,
    prepositions = "a",
    custom_rules = "a"
  ) |>
    testthat::expect_error()

  # checkmate::assert_character(custom_rules, null.ok = TRUE)
  to_title_case_pt(
    x = "a",
    articles = TRUE,
    conjunctions = TRUE,
    oblique_pronouns = TRUE,
    prepositions = TRUE,
    custom_rules = 1
  ) |>
    testthat::expect_error()
})
