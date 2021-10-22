# Sort tests by type or use the alphabetical order.

test_that("swap() | general test", {
    expect_equal(swap(5, 1), list(x = 1, y = 5))
    expect_equal(swap(1, 5, 1 > 5), list(x = 1, y = 5))
    expect_equal(swap(5, 1, 2 > 1), list(x = 1, y = 5))
})

test_that("swap() | error test", {
    expect_error(swap(1, 1, 1), "Assertion on 'condition' failed")
})
