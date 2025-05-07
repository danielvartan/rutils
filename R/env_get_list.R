env_get_list <- function(env = parent.frame()) {
  # R CMD Check variable bindings fix
  # nolint start
  . <- NULL
  # nolint end

  env %>%
    ls(envir = .) |>
    mget(envir = env)
}
