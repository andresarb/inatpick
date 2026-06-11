#' Export observation metadata to CSV
#'
#' Extracts key fields from observations returned by [inat_fetch()] and writes
#' them to a CSV file. Use `path` to save the CSV in the same folder as your
#' downloaded photos.
#'
#' @param obs Data frame returned by [inat_fetch()].
#' @param path Character. Output CSV file path. Default `"inat_metadata.csv"`.
#'   To save alongside downloaded photos, use
#'   `path = file.path(out_dir, "metadata.csv")`.
#' @param extra_cols Character vector of additional column names from `obs` to
#'   include, if present.
#'
#' @return Invisibly returns the metadata data frame.
#'
#' @note The `common_name` column reflects iNaturalist's `preferred_common_name`,
#'   which is typically in English but may vary depending on the taxon and
#'   iNaturalist's locale settings.
#'
#' @examples
#' \dontrun{
#' obs <- inat_fetch(taxon_id = 488444, place_id = 6783,
#'                   user_login = "someuser")
#'
#' # Save photos and metadata to the same folder
#' inat_download(obs, out_dir = "my_photos")
#' inat_metadata(obs, path = file.path("my_photos", "metadata.csv"))
#' }
#'
#' @export
inat_metadata <- function(obs,
                          path       = "inat_metadata.csv",
                          extra_cols = NULL) {

  # Map raw API column names to clean output names
  col_map <- c(
    id           = "id",
    observed_on  = "observed_on",
    quality_grade = "quality_grade",
    taxon        = "taxon.name",
    common_name  = "taxon.preferred_common_name",
    user         = "user.login",
    user_name    = "user.name",
    place        = "place_guess",
    description  = "description",
    url          = "uri",
    photos       = "photos"
  )

  # Keep only columns that exist in obs
  available <- col_map[col_map %in% names(obs)]
  meta <- obs[, available, drop = FALSE]
  names(meta) <- names(available)

  # Split location into lat/lon
  if ("location" %in% names(obs)) {
    coords         <- strsplit(as.character(obs$location), ",")
    meta$latitude  <- suppressWarnings(as.numeric(sapply(coords, `[`, 1)))
    meta$longitude <- suppressWarnings(as.numeric(sapply(coords, `[`, 2)))
  }

  # Count photos correctly — each element is a data frame of photos
  if ("photos" %in% names(meta)) {
    meta$num_photos <- sapply(obs$photos, function(p) {
      if (is.null(p) || length(p) == 0) 0L
      else if (is.data.frame(p)) nrow(p)
      else length(p)
    })
    meta$photos <- NULL
  }

  # Optional extra columns
  if (!is.null(extra_cols)) {
    extra_available <- intersect(extra_cols, names(obs))
    if (length(extra_available))
      meta <- cbind(meta, obs[, extra_available, drop = FALSE])
  }

  utils::write.csv(meta, path, row.names = FALSE)
  message("Metadata written to '", path, "' (", nrow(meta), " rows)")

  invisible(meta)
}
