library(beepr)
library(cffr)
library(codemetar)
library(groomr) # github.com/danielvartan/groomr
library(here)
library(rutils) # github.com/danielvartan/rutils

# Remove Empty Lines from `README.md` -----

remove_blank_line_dups(here("README.md"))

# Update Package Versions in `DESCRIPTION` -----

update_pkg_versions()

# Update Package Year in `LICENSE` and `inst/CITATION` -----

update_pkg_year(c(here("inst", "CITATION")))

# Update `cffr` and `codemeta` -----

cff_write()
write_codemeta()

# Check If the Script Ran Successfully -----

beep(1)

Sys.sleep(3)
