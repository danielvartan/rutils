# library(checkmate)

match_list <- function(list_1, list_2) {
  checkmate::assert_multi_class(list_1, c("list", "pairlist"))
  checkmate::assert_multi_class(list_2, c("list", "pairlist"))
  checkmate::assert_list(as.list(list_1), names = "named")
  checkmate::assert_list(as.list(list_2), names = "named")

  list_1 <- nullify_list(list_1)
  list_2 <- nullify_list(list_2)

  for (i in names(list_1)) {
    if (i %in% names(list_2)) {
      if (is.null(list_2[[i]])) {
        list_1[i] <- list(NULL)
      } else {
        list_1[[i]] <- list_2[[i]]
      }
    }
  }

  list_1 %>% magrittr::inset("...", NULL)
}
