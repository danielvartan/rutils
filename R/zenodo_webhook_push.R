#' Push the a GitHub release to Zenodo via webhook
#'
#' @description
#'
#' `zenodo_webhook_push()` provides an interface to the [Zenodo REST
#' API](https://developers.zenodo.org/) to deposit the latest release of your
#' GitHub repository using the provided webhook token for authentication. This
#' is especially useful in cases when you need to manually trigger the Zenodo
#' webhook.
#'
#' Please note that the function assumes that the GitHub repository is already
#' [linked to Zenodo](https://help.zenodo.org/docs/github/enable-repository/)
#' and that a release exists.
#'
#' I recommend testing this action in the [Zenodo
#' Sandbox](https://sandbox.zenodo.org) instance before using it with the main
#' Zenodo platform to avoid unintended data submissions.
#'
#' @details
#'
#' Based on Pieter Huybrechts' script, found
#' [here](https://github.com/zenodo/zenodo/issues/1463#issuecomment-2812815208).
#'
#' @param user A [`character`][base::character()] string with the GitHub
#'   username or organization name of the repository.
#' @param repository A [`character`][base::character()] string with the GitHub
#'   repository name.
#' @param webhook_token A [`character`][base::character()] string with the
#'   Zenodo webhook token to authenticate the deposit. This token can be found
#'   on the repository settings under *Webhooks* after [linking the GitHub
#'   repository to
#'   Zenodo](https://help.zenodo.org/docs/github/enable-repository/).
#'   If not provided, the function will prompt you to enter it
#'   interactively using the [`askpass`][askpass::askpass()] function.
#' @param release_tag (optional) A [`character`][base::character()] string with
#'   the GitHub release tag to push to Zenodo. If set to `"latest"` (default),
#'   the latest release will be pushed (default: `"latest"`).
#' @param sandbox (optional) A [`logical`][base::logical()] flag indicating
#'   whether to the webhook token is for the [Zenodo
#'   Sandbox](https://sandbox.zenodo.org) Instance or the main Zenodo platform
#'   (default: `FALSE`).
#'
#' @return An [invisible][base::invisible()] `NULL`. This function is called for
#'   its side effects.
#'
#' @family API functions
#' @export
#'
#' @examples
#' \dontrun{
#'   zenodo_webhook_push(
#'     user = "danielvartan",
#'     repository = "actverse",
#'     webhook_token = "your_zenodo_webhook_token_here",
#'     release_tag = "latest",
#'     sandbox = FALSE
#'   )
#' }
zenodo_webhook_push <- function(
  user,
  repository,
  webhook_token = askpass::askpass("Enter Zenodo webhook token: "),
  release_tag = "latest",
  sandbox = FALSE
) {
  checkmate::assert_string(user)
  checkmate::assert_string(repository)
  checkmate::assert_string(webhook_token, n.chars = 60)
  checkmate::assert_string(release_tag)
  checkmate::assert_flag(sandbox)

  repository_response <-
    httr2::request("https://api.github.com/repos") |>
    httr2::req_url_path_append(user) |>
    httr2::req_url_path_append(repository) |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  release_response <-
    httr2::request("https://api.github.com/repos") |>
    httr2::req_url_path_append(user) |>
    httr2::req_url_path_append(repository) |>
    httr2::req_url_path_append("releases") |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  sender_response <-
    httr2::request("https://api.github.com/users") |>
    httr2::req_url_path_append(user) |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  if (release_tag == "latest") {
    release_response <- release_response |> magrittr::extract2(1)
  } else {
    release_response <- Filter(
      \(x) x$tag_name == release_tag,
      release_response
    ) |>
      magrittr::extract2(1)

    if (is.null(release_response)) {
      cli::cli_abort(
        "Release with tag {.val {release_tag}} not found in
        repository {.val {user}/{repository}}."
      )
    }
  }

  cli::cli_progress_step(
    "Pushing release {.val {release_response$tag_name}} to Zenodo"
  )

  payload <- list(
    action = "published",
    release = release_response,
    repository = repository_response,
    sender = sender_response
  )

  if (isTRUE(sandbox)) {
    api_url <- "https://sandbox.zenodo.org/api/hooks/receivers/github/events/"
  } else {
    api_url <- "https://zenodo.org/api/hooks/receivers/github/events/"
  }

  api_url |>
    httr2::request() |>
    httr2::req_url_query(access_token = webhook_token) |>
    httr2::req_body_json(payload) |>
    httr2::req_perform()

  cli::cli_progress_done()

  invisible()
}
