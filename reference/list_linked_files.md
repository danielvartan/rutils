# List all files linked to a reference in a Zotero library

`list_linked_files()` reads a CSV file exported from Zotero and extracts
the file paths of all attachments linked to the references in the
library.

## Usage

``` r
list_linked_files(
  lib_file = tcltk::tk_choose.files(caption = "Select Zotero library CSV file", multi =
    FALSE),
  basename = TRUE
)
```

## Arguments

- lib_file:

  (optional) A string specifying the path to the Zotero library exported
  as a **CSV** file. (default:
  [\`tk_choose.files()“](https://rdrr.io/r/tcltk/tk_choose.files.html)).

- basename:

  (optional) A [`logical`](https://rdrr.io/r/base/logical.html) flag
  indicating if the function should return the full path to the files or
  only the file names (default: `TRUE`).

## Value

A [`character`](https://rdrr.io/r/base/character.html) vector with the
names of the files linked to the references in the Zotero library.

## Details

To export your library from Zotero, go to the menu
`File > Export Library...` and choose the **CSV** format.

## See also

Other Zotero functions:
[`find_orphan_files()`](https://danielvartan.github.io/rutils/reference/find_orphan_files.md)

## Examples

``` r
if (FALSE) { # \dontrun{
  list_linked_files()
} # }
```
