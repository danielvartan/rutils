# library(checkmate, quietly = TRUE)
# library(here, quietly = TRUE)
# library(stringr, quietly = TRUE)
# library(qpdf, quietly = TRUE)

remove_pdf_cover <- function(input_file, output_file = input_file) {
  checkmate::assert_string(input_file, pattern = ".pdf$")
  checkmate::assert_file_exists(input_file, access = "r")
  checkmate::assert_string(output_file, pattern = ".pdf$")
  checkmate::assert_directory_exists(dirname(output_file), access = "w")

  if (input_file == output_file) {
    temp_file <- tempfile()
    file.copy(input_file, temp_file)
    input_file <- temp_file
  }

  len <- qpdf::pdf_length(input_file)

  qpdf::pdf_subset(
    input = input_file,
    pages = seq(2, len),
    output = output_file
  )

  if (exists("temp_file")) suppressWarnings(file.remove(temp_file))

  invisible()
}
