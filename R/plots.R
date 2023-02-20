# Sort by type or alphabetical order.

label_jump <- function(x, type = "even") {
    checkmate::assert_atomic(x)
    checkmate::assert_choice(type, c("even", "odd", "one"))

    x <- x %>% as.character()

    if (type == "even") x[seq_along(x) %% 2 == 0] <- ""
    if (type == "odd") x[!seq_along(x) %% 2 == 0] <- ""
    if (type == "one") x[seq_along(x) %% 3 == 0] <- ""

    x
}
