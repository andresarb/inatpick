#' inatpick: Download Photos and Metadata from iNaturalist
#'
#' A lightweight interface to the iNaturalist API for downloading observation
#' photos and exporting metadata to CSV. Supports filtering by taxon, place,
#' user, and annotation.
#'
#' The main workflow:
#' 1. [inat_search_taxon()] / [inat_search_place()] — find taxon and place IDs
#' 2. [inat_fetch()] — retrieve observations from the API
#' 3. [inat_download()] — download photos to a local folder
#' 4. [inat_metadata()] — export observation metadata to CSV
#'
#' @keywords internal
"_PACKAGE"

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "Welcome to inatpick v", utils::packageVersion("inatpick"), "!\n\n",
    "Workflow:\n",
    "  Search: inat_search_taxon() / inat_search_place()\n",
    "  Fetch:  inat_fetch()\n",
    "  Save:   inat_download()\n\n",
    "Docs: https://andresarb.github.io/inatpick\n",
    "Type ?inatpick for help.\n\n",
    "This package is provided as-is, without warranty of any kind.\n",
    "It is a personal project maintained on a best-effort basis."
  )
}

## usethis namespace: start
#' @importFrom dplyr bind_rows select mutate distinct
#' @importFrom tidyr unnest
#' @importFrom purrr compact
#' @importFrom httr GET stop_for_status content
#' @importFrom jsonlite fromJSON
#' @importFrom utils download.file write.csv packageVersion
#' @importFrom rlang .data
#' @importFrom stats setNames
## usethis namespace: end
NULL