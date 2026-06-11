#' Fetch observations from the iNaturalist API
#'
#' Retrieves all observations matching the given filters, handling pagination
#' automatically.
#'
#' @param taxon_id Integer. iNaturalist taxon ID (e.g. `488444` for
#'   *Caiophora chuquitensis*).
#' @param place_id Integer or `NULL`. iNaturalist place ID (e.g. `6783` for
#'   Bolivia).
#' @param user_login Character or `NULL`. iNaturalist username.
#' @param annotation Character label or integer vector `c(term_id,
#'   term_value_id)` or `NULL`. Filter by a single annotation. Use a label
#'   from [inat_annotations] (e.g. `"flowers"`, `"fruit"`, `"alive"`,
#'   `"adult"`, `"female"`) or pass raw IDs directly as `c(12L, 13L)`.
#'   See [inat_annotations] for all valid labels.
#' @param quality_grade Character. One of `"research"`, `"needs_id"`, or
#'   `"any"` (default).
#' @param year Integer or `NULL`. Filter by observation year.
#' @param month Integer (1–12) or `NULL`. Filter by observation month.
#' @param licensed Logical or `NULL`. If `TRUE`, return only observations with
#'   a CC photo license.
#' @param per_page Integer. Results per API page (max 200).
#' @param verbose Logical. Print progress messages (default `TRUE`).
#'
#' @return A data frame of observations with list-column `photos`.
#'
#' @examples
#' \dontrun{
#' # Observations with open flowers
#' obs <- inat_fetch(taxon_id = 488444, place_id = 6783,
#'                   annotation = "flowers")
#'
#' # Using raw IDs
#' obs <- inat_fetch(taxon_id = 488444, annotation = c(12L, 13L))
#'
#' # See all available annotation labels
#' inat_annotations
#' }
#'
#' @seealso [inat_annotations] for all annotation labels and IDs.
#' @export
inat_fetch <- function(taxon_id,
                       place_id      = NULL,
                       user_login    = NULL,
                       annotation    = NULL,
                       quality_grade = "any",
                       year          = NULL,
                       month         = NULL,
                       licensed      = NULL,
                       per_page      = 200,
                       verbose       = TRUE) {

  stopifnot(is.numeric(taxon_id), length(taxon_id) == 1)
  per_page <- min(as.integer(per_page), 200L)

  # Resolve annotation to term_id / term_value_id
  term_id       <- NULL
  term_value_id <- NULL
  if (!is.null(annotation)) {
    ids           <- resolve_annotation(annotation)
    term_id       <- ids[["term_id"]]
    term_value_id <- ids[["term_value_id"]]
  }

  all_results <- list()
  page        <- 1L
  total       <- Inf

  while ((page - 1L) * per_page < total) {

    query <- list(
      taxon_id      = taxon_id,
      place_id      = place_id,
      user_login    = user_login,
      term_id       = term_id,
      term_value_id = term_value_id,
      quality_grade = if (quality_grade == "any") NULL else quality_grade,
      year          = year,
      month         = month,
      licensed      = if (isTRUE(licensed)) "any" else NULL,
      per_page      = per_page,
      page          = page
    )
    query <- purrr::compact(query)

    res <- httr::GET("https://api.inaturalist.org/v1/observations",
                     query = query)
    httr::stop_for_status(res)

    parsed      <- jsonlite::fromJSON(httr::content(res, as = "text",
                                                    encoding = "UTF-8"),
                                      flatten = TRUE)
    total       <- parsed$total_results
    all_results <- c(all_results, list(parsed$results))

    if (verbose) {
      fetched <- min(page * per_page, total)
      message("Fetched ", fetched, " / ", total, " observations")
    }

    page <- page + 1L
    Sys.sleep(0.5)
  }

  dplyr::bind_rows(all_results)
}
