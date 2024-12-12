# library(chatgpt)
# library(glue)
# library(prettycheck) # github.com/danielvartan/prettycheck
# library(rutils) # github.com/danielvartan/rutils

extract_data_with_chatgpt <- function(
    data,
    extract = "city",
    complement = "address"
) {
  prettycheck:::assert_atomic(data)
  prettycheck:::assert_string(extract)
  prettycheck:::assert_string(complement)

  chatgpt::reset_chat_session(
    system_role = paste0(
      "Your role is to assist by fill in missing data in a R script. ",
      "Your answers must be exact (!important!). ",
      "Don't output comments or explanations. ",
      "If you don't know the answer, output a blank stirng (''). ",
      "NEVER output a answer using quotes."
    )
  )

  out <- character()

  for (i in data) {
    out <- c(
      out,
      glue::glue(
        "Extract and output ONLY the {extract} from the following: {i}."
      ) |>
        chatgpt::ask_chatgpt() |>
        rutils::shush()
    )
  }

  out
}
