# Find orphan files in a Zotero library

`find_orphan_files()` compares the files present in a specified folder
with those linked to references in a Zotero library, returning the names
of files that are not linked (i.e., orphan files).

## Usage

``` r
find_orphan_files(
  lib_file = tcltk::tk_choose.files(caption = "Select the Zotero library CSV file", multi
    = FALSE),
  file_folder = tcltk::tk_choose.dir(caption = "Select the folder containing the files")
)
```

## Arguments

- lib_file:

  (optional) A string specifying the path to the Zotero library exported
  as a **CSV** file. (default:
  [`tk_choose.files()`](https://rdrr.io/r/tcltk/tk_choose.files.html)).

- file_folder:

  (optional) A string specifying the path to the folder containing the
  files linked to references in the Zotero library. (default:
  [`tk_choose.dir()`](https://rdrr.io/r/tcltk/tk_choose.dir.html)).

## Value

A [`character`](https://rdrr.io/r/base/character.html) vector with the
names of the orphan files.

## Details

To export your library from Zotero, go to the menu
`File > Export Library...` and choose the **CSV** format.

## See also

Other Zotero functions:
[`list_linked_files()`](https://danielvartan.github.io/rutils/reference/list_linked_files.md)

## Examples

``` r
if (FALSE) { # \dontrun{
  find_orphan_files()
} # }
```
