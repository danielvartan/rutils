# Sort functions by type or use the alphabetical order.

find_absolute_path <- function(relative_path) {
    require_pkg("tools")

    vapply(
        relative_path, tools::file_path_as_absolute, character(1),
        USE.NAMES = FALSE
        )
}

find_path <- function(dir, package = get_package_name()) {
    root <- system.file(package = package)

    if (!stringr::str_detect(root, "inst/?$") &&
        any(stringr::str_detect("^inst$", list.files(root)), na.rm = TRUE)) {

        system.file(paste0("inst/", dir), package = package)
    } else {
        system.file(dir, package = package)
    }
}

get_package_name <- function() {
    require_pkg("rstudioapi")

    basename(rstudioapi::getActiveProject())
}

require_pkg <- function(...) {
    out <- list(...)

    lapply(out, checkmate::assert_string,
           pattern = "^[A-Za-z][A-Za-z0-9.]+[A-Za-z0-9]$")

    if (!identical(unique(unlist(out)), unlist(out))) {
        cli::cli_abort("'...' cannot have duplicated values.")
    }

    pkg <- unlist(out)
    namespace <- vapply(pkg, require_namespace, logical(1),
                        quietly = TRUE, USE.NAMES = FALSE)
    pkg <- pkg[!namespace]

    if (length(pkg) == 0) {
        invisible(NULL)
    } else {
        cli::cli_abort(paste0(
            "This function requires the {single_quote_(pkg)} package{?s} ",
            "to run. You can install {?it/them} by running:", "\n\n",
            "install.packages(",
            "{paste(double_quote_(pkg), collapse = ', ')})"
        ))
    }
}
