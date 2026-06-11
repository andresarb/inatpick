#' Export observation metadata to CSV
#'
#' Extracts key fields from observations returned by [inat_fetch()] and writes
#' them to a CSV file.
#'
#' @param obs Data frame returned by [inat_fetch()].
#' @param path Character. Output CSV file path. Default `"inat_metadata.csv"`.
#' @param extra_cols Character vector of additional column names from `obs` to
#'   include, if present.
#'
#' @return Invisibly returns the metadata data frame.
#'
#' @examples
#' \dontrun{
#' obs <- inat_fetch(taxon_id = 488444, place_id = 6783,
#'                   user_login = "someuser")
#' inat_metadata(obs, path = "chuquitensis_bolivia.csv")
#' }
#'
#' @export
inat_metadata <- function(obs,
                          path       = "inat_metadata.csv",
                          extra_cols = NULL) {

  core_cols <- c(
    id                    = "id",
    observed_on           = "observed_on",
    quality_grade         = "quality_grade",
    taxon_name            = "taxon.name",
    taxon_common_name     = "taxon.preferred_common_name",
    user                  = "user.login",
    place_guess           = "place_guess",
    latitude              = "location",   # handled below
    longitude             = "location",
    description           = "description",
    url                   = "uri",
    num_photos            = "photos"      # handled below
  )

  # Start with available core columns
  available <- intersect(
    c("id", "observed_on", "quality_grade", "taxon.name",
      "taxon.preferred_common_name", "user.login", "place_guess",
      "location", "description", "uri", "photos"),
    names(obs)
  )

  meta <- obs[, available, drop = FALSE]

  # Split location into lat/lon
  if ("location" %in% names(meta)) {
    coords       <- strsplit(as.character(meta$location), ",")
    meta$latitude  <- suppressWarnings(as.numeric(sapply(coords, `[`, 1)))
    meta$longitude <- suppressWarnings(as.numeric(sapply(coords, `[`, 2)))
    meta$location  <- NULL
  }

  # Count photos
  if ("photos" %in% names(meta)) {
    meta$num_photos <- lengths(meta$photos)
    meta$photos     <- NULL
  }

  # Optional extra columns
  if (!is.null(extra_cols)) {
    extra_available <- intersect(extra_cols, names(obs))
    if (length(extra_available)) meta <- cbind(meta, obs[, extra_available, drop = FALSE])
  }

  utils::write.csv(meta, path, row.names = FALSE)
  message("Metadata written to '", path, "' (", nrow(meta), " rows)")

  invisible(meta)
}
