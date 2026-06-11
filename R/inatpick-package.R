#' inatpick: Download Photos and Metadata from iNaturalist
#'
#' A lightweight interface to the iNaturalist API for downloading observation
#' photos and exporting metadata to CSV. Supports filtering by taxon, place,
#' and user.
#'
#' The main workflow:
#' 1. [inat_fetch()] — retrieve observations from the API
#' 2. [inat_download()] — download photos to a local folder
#' 3. [inat_metadata()] — export observation metadata to CSV
#'
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom dplyr bind_rows select mutate
#' @importFrom tidyr unnest
#' @importFrom purrr compact
#' @importFrom httr GET stop_for_status content
#' @importFrom jsonlite fromJSON
#' @importFrom utils download.file write.csv
#' @importFrom rlang .data
#' @importFrom stats setNames
## usethis namespace: end
NULL