#' Convert to title case considering Portuguese rules
#'
#' @description
#'
#' `to_title_case_pt()` converts a character vector to title case, but
#' keeping some classes of words in lower case.
#'
#' In written Portuguese (PT), when converting to title case, it is not usual
#' to keep in title case some words, like prepositions, conjunctions,
#' articles and some kinds of pronouns. This function locates those
#' cases and converts them to lower case.
#'
#' (Adapted from the original function `to_title_case()` by **Jose de Jesus
#' Filho**)
#'
#' @param x A [`character`][base::character()] vector.
#' @param articles (Optional) A [`logical`][base::logical()] flag indicating if
#'   articles should be converted (default: `TRUE`).
#' @param conjunctions (Optional) A [`logical`][base::logical()] flag indicating
#'   if conjunctions should be converted (default: `TRUE`).
#' @param oblique_pronouns (Optional) A [`logical`][base::logical()] flag
#'   indicating if oblique pronouns should be converted (default: `TRUE`).
#' @param prepositions (Optional) A [`logical`][base::logical()] flag
#'   indicating if prepositions should be converted (default: `TRUE`).
#' @param custom_rules (Optional) A [`character`][base::character()] vector
#'   with custom rules to be applied. The syntax is
#'   `c("regex" = "replacement")`. The default is
#'   `c("(.)\\bD(el)\\b" = "\\1d\\2")`, which converts *Del* to *del*.
#'
#' @return A [`character`][base::character()] vector.
#'
#' @author Jose de Jesus Filho
#'
#' @family string functions.
#' @export
#'
#' @examples
#' to_title_case_pt("Desterro de Entre Rios")
#' #> [1] "Desterro de entre Rios" # Expected
#'
#' to_title_case_pt("Pablo Del Rei")
#' #> [1] "Pablo del Rei" # Expected
#'
#' to_title_case_pt("Sant'ana do Livramento")
#' #> [1] "Sant'Ana do Livramento" # Expected
#'
#' to_title_case_pt("Alta Floresta d'Oeste")
#' #> [1] "Alta Floresta D'Oeste" # Expected
to_title_case_pt <- function(
    x, #nolint
    articles = TRUE,
    conjunctions = TRUE,
    oblique_pronouns = TRUE,
    prepositions = TRUE,
    custom_rules = c("(.)\\bD(el)\\b" = "\\1d\\2") # Del
  ) {
  checkmate::assert_character(x)
  checkmate::assert_flag(articles)
  checkmate::assert_flag(conjunctions)
  checkmate::assert_flag(oblique_pronouns)
  checkmate::assert_flag(prepositions)
  checkmate::assert_character(custom_rules, null.ok = TRUE)

  # Use `stringi::stri_escape_unicode` to escape unicode characters.
  # stringi::stri_escape_unicode("")

  # Use `tools::showNonASCIIfile` to show non-ASCII characters.
  # tools::showNonASCIIfile(here::here("R", "to_title_case_pt.R"))

  # Using `c("regex" = "replacement")` syntax
  rules <- c(custom_rules)

  if (isTRUE(articles)) {
    rules <- c(
      rules,
      # A | As
      "(.)\\bA(s)?\\b" = "\\1a\\2",
      # O | Os
      "(.)\\bO(s)?\\b" = "\\1o\\2",
      # Um | Uns | Uma | Umas
      "(.)\\bU((m(a(s)?)?)|ns)\\b" = "\\1u\\2"
    )
  }

  if (isTRUE(conjunctions)) {
    rules <- c(
      rules,
      # Conforme | Conquanto | Contudo
      "(.)\\bC(on(forme|quanto|tudo))\\b" = "\\1c\\2",
      # Durante
      "(.)\\bD(urante)\\b" = "\\1D\\2",
      # E | Embora | Enquanto | Entao | Entretanto | Exceto
      "(.)\\bE((mbora|n(quanto|t(\\u00e3o|retanto))|xceto)?)\\b" = "\\1e\\2",
      # Logo
      "(.)\\bL(ogo)\\b" = "\\1l\\2",
      # Mas
      "(.)\\bM(as)\\b" = "\\1m\\2",
      # Nem
      "(.)\\bN(em)\\b" = "\\1n\\2",
      # Ou | Ora
      "(.)\\bO(u|ra)\\b" = "\\1o\\2",
      # Pois | Porem | Porque | Porquanto | Portanto
      "(.)\\bP(o(is|r(\\u00e9m|qu(e|anto)|tanto)))\\b" = "\\1p\\2",
      # Quando | Quanto | Que
      "(.)\\bQ(u(an[dt]o|e))\\b" = "\\1q\\2",
      # Se | Senao
      "(.)\\bS(e(n\\u00e3o)?)\\b" = "\\1s\\2",
      # Todavia
      "(.)\\bT(odavia)\\b" = "\\1t\\2"
    )
  }

  if (isTRUE(oblique_pronouns)) {
    rules <- c(
      rules,
      # Lhe | Lhes
      "(.)\\bL(he(s)?)\\b" = "\\1l\\2",
      # Me | Meu | Meus | Mim | Minha | Minhas
      "(.)\\bM((e(u(s)?)?)|(i(m|(nha(s)?))))\\b" = "\\1m\\2",
      # Nos | Nosso | Nossa | Nossos | Nossas
      "(.)\\bN(os(s[ao](s)?)?)\\b" = "\\1n\\2",
      # Seu | Seus | Sua | Suas
      "(.)\\bS((e(u(s)?)?)|(ua(s)?))\\b" = "\\1s\\2",
      # Te | Teu | Teus | Ti | Tua | Tuas
      "(.)\\bT((e(u(s)?)?)|i|(ua(s)?))\\b" = "\\1t\\2",
      # Vos | Vosso | Vossa | Vossos | Vossas
      "(.)\\bV(os(s[ao](s)?)?)\\b" = "\\1v\\2"
    )
  }

  if (isTRUE(prepositions)) {
    rules <- c(
      rules,
      # Ao | Aos | Ante | Ate | Apos
      "(.)\\bA((o)(s)?|nte|t\\u00e9|p\\u00f3s)\\b" = "\\1a\\2",
      # As
      "(.)\\b\\u00c0(s)?\\b" = "\\1\\u00e0\\2",
      # Com | Contra
      "(.)\\bC(om|ontra)\\b" = "\\1c\\2",
      # Da | Das | Do | Dos | De | Desde
      "(.)\\bD(((a|o)(s)?)|(e(sde)?))\\b" = "\\1d\\2",
      # Em | Entre
      "(.)\\bE(m|ntre)\\b" =  "\\1e\\2",
      # Na | Nas | No | Nos
      "(.)\\bN((a|o)(s)?)\\b" = "\\1n\\2",
      # Para | Perante | Pela | Pelas | Pelo | Pelos | Por
      "(.)\\bP(ara|(e((l(a|o)(s)?)|rante))|or)\\b" = "\\1p\\2",
      # Sem | Sob | Sobre
      "(.)\\bS(em|(ob(re)?))\\b" = "\\1s\\2",
      # Tras
      "(.)\\bT(r\\u00e1s)\\b" = "\\1t\\2",
      # Del
      "(.)\\bD(el)\\b" = "\\1d\\2"
    )
  }

  out <-
    x |>
    stringr::str_to_title() |>
    stringr::str_replace_all(rules)

  # Deals with contractions like "Copo D'Agua" and "Sant'Ana do Livramento".
  out |>
    stringr::str_replace_all(
      "(\\b\\p{L}')\\p{Ll}|(\\p{Ll}')\\p{Ll}",
      function(m) paste0(substr(m, 1, 2), toupper(substr(m, 3, 3)))
    )
}
