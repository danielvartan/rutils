env_get_list <- function(env = parent.frame()) {
  # R CMD Check variable bindings fix (see: https://bit.ly/3z24hbU)
  # nolint start: object_usage_linter.
  . <- NULL
  # nolint end

  env %>%
    ls(envir = .) %>%
    mget(envir = env)
}
