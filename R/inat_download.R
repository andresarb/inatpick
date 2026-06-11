#' Download photos from iNaturalist observations
#'
#' Downloads all photos from a data frame returned by [inat_fetch()].
#'
#' @param obs Data frame returned by [inat_fetch()].
#' @param out_dir Character. Directory to save images. Created if it does not
#'   exist.
#' @param size Character. Photo size: `"square"` (75px), `"small"` (240px),
#'   `"medium"` (500px), `"large"` (1024px), or `"original"`. Default
#'   `"large"`.
#' @param overwrite Logical. Re-download files that already exist (default
#'   `FALSE`).
#' @param verbose Logical. Print progress messages (default `TRUE`).
#'
#' @return Invisibly returns a data frame of photo URLs and local file paths.
#'
#' @examples
#' \dontrun{
#' obs <- inat_fetch(taxon_id = 488444, place_id = 6783,
#'                   user_login = "someuser")
#' inat_download(obs, out_dir = "my_photos")
#' }
#'
#' @export
inat_download <- function(obs,
                          out_dir   = "inat_photos",
                          size      = "large",
                          overwrite = FALSE,
                          verbose   = TRUE) {

  size <- match.arg(size, c("square", "small", "medium", "large", "original"))

  if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

  # Build photo table
  photos <- obs |>
    dplyr::select(obs_id = "id", "photos") |>
    tidyr::unnest("photos") |>
    dplyr::mutate(
      url_sized  = gsub("square", size, .data$url),
      local_path = file.path(
        out_dir,
        paste0("obs", .data$obs_id, "_", .data$id, ".jpg")
      )
    )

  n <- nrow(photos)
  if (verbose) message("Downloading ", n, " photo(s) to '", out_dir, "'")

  for (i in seq_len(n)) {
    dest <- photos$local_path[i]
    url  <- photos$url_sized[i]

    if (!overwrite && file.exists(dest)) {
      if (verbose) message("[", i, "/", n, "] Skipping (exists): ", basename(dest))
      next
    }

    if (verbose) message("[", i, "/", n, "] Downloading: ", basename(dest))

    tryCatch(
      utils::download.file(url, dest, quiet = TRUE, mode = "wb"),
      error = function(e) warning("Failed to download: ", url, "\n", e$message)
    )
  }

  if (verbose) message("Done.")
  invisible(photos)
}
