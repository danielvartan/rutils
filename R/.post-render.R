# library(beepr)
# library(cffr)
# library(codemetar)
# library(groomr) # github.com/danielvartan/groomr
# library(here)
# library(rutils) # github.com/danielvartan/rutils

# Remove empty lines from `README.md` -----

groomr::remove_blank_line_dups(here::here("README.md"))

# Update package versions in `DESCRIPTION` -----

rutils::update_pkg_versions()

# Update package year in `LICENSE`, `LICENSE.md`, and `inst/CITATION` -----

rutils::update_pkg_year()

# Update `cffr` and `codemeta` -----

cffr::cff_write()
codemetar::write_codemeta()

# Check if the script ran successfully -----

beepr::beep(1)

Sys.sleep(3)
