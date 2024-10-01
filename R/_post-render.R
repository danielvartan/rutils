# library(beepr, quietly = TRUE)
# library(groomr, quietly = TRUE)
# library(here, quietly = TRUE)
# library(readr, quietly = TRUE)
# library(stringr, quietly = TRUE)

# Remove empty lines from `README.md` -----

groomr::remove_blank_line_dups(here::here("README.md"))

# Update `LICENSE` and `LICENSE.md` year -----

files <- c(here::here("LICENSE"), here::here("LICENSE.md"))

for (i in files) {
  data <-
    i |>
    readr::read_lines() |>
    stringr::str_replace_all(
      pattern = "20\\d{2}",
      replacement = as.character(Sys.Date() |> lubridate::year())
    )

  data |> readr::write_lines(i)
}

# Check if the script ran successfully -----

# beepr::beep(1)
