# Push the a GitHub release to Zenodo via webhook

`zenodo_webhook_push()` provides an interface to the [Zenodo REST
API](https://developers.zenodo.org/) to deposit the latest release of
your GitHub repository using the provided webhook token for
authentication. This is especially useful in cases when you need to
manually trigger the Zenodo webhook.

Please note that the function assumes that the GitHub repository is
already [linked to
Zenodo](https://help.zenodo.org/docs/github/enable-repository/) and that
a release exists.

I recommend testing this action in the [Zenodo
Sandbox](https://sandbox.zenodo.org) instance before using it with the
main Zenodo platform to avoid unintended data submissions.

## Usage

``` r
zenodo_webhook_push(
  user,
  repository,
  webhook_token = askpass::askpass("Enter Zenodo webhook token: "),
  release_tag = "latest",
  sandbox = FALSE
)
```

## Arguments

- user:

  A [`character`](https://rdrr.io/r/base/character.html) string with the
  GitHub username or organization name of the repository.

- repository:

  A [`character`](https://rdrr.io/r/base/character.html) string with the
  GitHub repository name.

- webhook_token:

  A [`character`](https://rdrr.io/r/base/character.html) string with the
  Zenodo webhook token to authenticate the deposit. This token can be
  found on the repository settings under *Webhooks* after [linking the
  GitHub repository to
  Zenodo](https://help.zenodo.org/docs/github/enable-repository/). If
  not provided, the function will prompt you to enter it interactively
  using the
  [`askpass`](https://r-lib.r-universe.dev/askpass/reference/askpass.html)
  function.

- release_tag:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  string with the GitHub release tag to push to Zenodo. If set to
  `"latest"` (default), the latest release will be pushed (default:
  `"latest"`).

- sandbox:

  (optional) A [`logical`](https://rdrr.io/r/base/logical.html) flag
  indicating whether to the webhook token is for the [Zenodo
  Sandbox](https://sandbox.zenodo.org) Instance or the main Zenodo
  platform (default: `FALSE`).

## Value

An [invisible](https://rdrr.io/r/base/invisible.html) `NULL`. This
function is called for its side effects.

## Details

Based on Pieter Huybrechts' script, found
[here](https://github.com/zenodo/zenodo/issues/1463#issuecomment-2812815208).

## Examples

``` r
if (FALSE) { # \dontrun{
  zenodo_webhook_push(
    user = "danielvartan",
    repository = "actverse",
    webhook_token = "your_zenodo_webhook_token_here",
    release_tag = "latest",
    sandbox = FALSE
  )
} # }
```
