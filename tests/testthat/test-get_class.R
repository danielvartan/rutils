test_that("get_class() | General test", {
  get_class(x = 1) |> expect_equal("numeric")

  datasets::iris |>
    get_class() |>
    expect_equal(
      vapply(
        datasets::iris,
        function(x) class(x)[1],
        character(1)
      )
    )

  list(a = 1, b = 1) |>
    get_class() |>
    expect_equal(
      vapply(
        list(a = 1, b = 1),
        function(x) class(x)[1],
        character(1)
      )
    )
})
