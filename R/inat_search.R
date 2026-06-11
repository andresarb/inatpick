#' Search for a taxon by name on iNaturalist
#'
#' Returns matching taxa from iNaturalist, useful for finding the taxon ID
#' to pass to [inat_fetch()].
#'
#' @param name Character. Taxon name to search (common or scientific).
#' @param rank Character or `NULL`. Filter results by taxonomic rank, e.g.
#'   `"genus"`, `"species"`, `"family"`. Default `NULL` returns all ranks.
#' @param n Integer. Maximum number of results to return (default 10).
#'
#' @return A data frame with columns `id`, `name`, `common_name`, `rank`, and
#'   `observations_count`, ordered by number of observations.
#'
#' @note The `common_name` field reflects iNaturalist's `preferred_common_name`,
#'   which is typically in English but may vary depending on the taxon and
#'   iNaturalist's locale settings.
#'
#' @examples
#' \dontrun{
#' inat_search_taxon("Drosera rotundifolia")
#' inat_search_taxon("Drosera", rank = "genus")
#' inat_search_taxon("sundew", rank = "species")
#' }
#'
#' @export
inat_search_taxon <- function(name, rank = NULL, n = 10) {
  stopifnot(is.character(name), length(name) == 1)
  
  res <- httr::GET(
    "https://api.inaturalist.org/v1/taxa",
    query = list(q = name, per_page = n)
  )
  httr::stop_for_status(res)
  
  parsed <- jsonlite::fromJSON(
    httr::content(res, as = "text", encoding = "UTF-8"),
    flatten = TRUE
  )
  
  if (parsed$total_results == 0) {
    message("No taxa found for '", name, "'.")
    return(invisible(data.frame()))
  }
  
  results <- parsed$results
  
  out <- data.frame(
    id                 = results$id,
    name               = results$name,
    common_name        = if ("preferred_common_name" %in% names(results))
      results$preferred_common_name else NA_character_,
    rank               = results$rank,
    observations_count = if ("observations_count" %in% names(results))
      results$observations_count else NA_integer_,
    stringsAsFactors   = FALSE
  )
  
  out <- out[order(-out$observations_count, na.last = TRUE), ]
  
  # Filter by rank if specified
  if (!is.null(rank)) {
    out <- out[out$rank == rank, ]
    if (nrow(out) == 0) {
      message("No taxa found for '", name, "' with rank '", rank, "'.")
      return(invisible(data.frame()))
    }
  }
  
  cat("Use the 'id' column value in inat_fetch(taxon_id = ...).\n\n")
  if (is.null(rank))
    cat("Tip: use the 'rank' argument to filter by taxonomic level for fewer, more accurate results.\n\n")
  out
}


#' Search for a place by name on iNaturalist
#'
#' Returns matching places from iNaturalist, useful for finding the place ID
#' to pass to [inat_fetch()].
#'
#' @param name Character. Place name to search.
#' @param n Integer. Maximum number of results to return (default 10).
#'
#' @return A data frame with columns `id`, `name`, `display_name`, and `place_type`.
#'
#' @examples
#' \dontrun{
#' inat_search_place("United Kingdom")
#' inat_search_place("Bolivia")
#' }
#'
#' @export
inat_search_place <- function(name, n = 10) {
  stopifnot(is.character(name), length(name) == 1)
  
  res <- httr::GET(
    "https://api.inaturalist.org/v1/places/autocomplete",
    query = list(q = name, per_page = n)
  )
  httr::stop_for_status(res)
  
  parsed <- jsonlite::fromJSON(
    httr::content(res, as = "text", encoding = "UTF-8"),
    flatten = TRUE
  )
  
  if (parsed$total_results == 0) {
    message("No places found for '", name, "'.")
    return(invisible(data.frame()))
  }
  
  results <- parsed$results
  
  out <- data.frame(
    id           = results$id,
    name         = results$name,
    display_name = if ("display_name" %in% names(results))
      results$display_name else results$name,
    place_type   = if ("place_type" %in% names(results))
      results$place_type else NA_integer_,
    stringsAsFactors = FALSE
  )
  cat("Use the 'id' column value in inat_fetch(place_id = ...).\n\n")
  out
}