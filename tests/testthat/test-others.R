# Sort tests by type or use the alphabetical order.

test_that("swap() | general test", {
    expect_equal(swap(x = 5, y = 1, condition = TRUE), list(x = 1, y = 5))
    expect_equal(swap(x = 1, y = 5, condition = 1 > 5), list(x = 1, y = 5))
    expect_equal(swap(x = 5, y = 1, condition = 2 > 1), list(x = 1, y = 5))
})

test_that("swap() | error test", {
    # assert_identical(x, y, type = "class")
    expect_error(swap(
        x = 1, y = "a", condition = TRUE
    ))

    # assert_identical(x, y, condition, type = "length")
    expect_error(swap(
        x = 1L, y = 1:2, condition = TRUE
    ))

    # checkmate::assert_logical(condition)
    expect_error(swap(
        x = 1, y = 1, condition = 1
    ),
    "Assertion on 'condition' failed"
    )
})
