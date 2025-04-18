test_that("cluster_map() | General test", {
  x <- make_cluster(1)
  object <- cluster_map(x, function(x) TRUE, 1)
  stop_cluster(x)

  checkmate::expect_list(object)
})

test_that("make_cluster() | General test", {
  object <- make_cluster(1)
  stop_cluster(object)

  checkmate::expect_class(object, "cluster")
})

test_that("stop_cluster() | General test", {
  x <- make_cluster(1)

  expect_null(stop_cluster(x))
})

test_that("curl_download() | General test", {
  url <- paste0(
    "https://api.stackexchange.com/2.2/answers?",
    "order=desc&sort=activity&site=stackoverflow"
  )

  if (curl::has_internet()) {
    checkmate::expect_file(curl_download(url = url, destfile = tempfile()))
  }
})

test_that("curl_fetch_memory() | General test", {
  url <- paste0(
    "https://api.stackexchange.com/2.2/answers?",
    "order=desc&sort=activity&site=stackoverflow"
  )

  if (curl::has_internet()) {
    checkmate::expect_list(curl_fetch_memory(url = url))
  }
})

test_that("has_internet() | General test", {
  expect_equal(has_internet(), curl::has_internet())
})

test_that("is_interactive() | General test", {
  expect_equal(is_interactive(), interactive())
})

# test_that("from_json() | General test", {
#     tmp <- tempfile()
#     jsonlite::write_json(acttrust, tmp)

#     expect_equal(
#         from_json(readLines(tmp))[["pim"]][1],
#         acttrust[["pim"]][1]
#     )
# })

# test_that("read_json() | General test", {
#     tmp <- tempfile()
#     jsonlite::write_json(acttrust, tmp)

#     expect_equal(
#         read_json(tmp)[[1]][["pim"]],
#         acttrust[["pim"]][1]
#     )
# })

# test_that("read_line() | General test", {
#   expect_equal(read_line(""), "")
# })

# test_that("raw_to_char() | General test", {
#   expect_equal(raw_to_char(charToRaw("a")), "a")
# })


# test_that("require_namespace() | General test", {
#   expect_equal(
#     require_namespace("base"),
#     requireNamespace("base", quietly = TRUE)
#   )
# })
