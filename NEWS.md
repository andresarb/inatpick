# inatpick 0.2.1

## Bug fixes
- Fixed URL in DESCRIPTION (added trailing slash to pkgdown site URL)
- Added iNaturalist to spell-check whitelist

# inatpick 0.2.0

## New functions
- `inat_search_taxon()` — search for a taxon by name and retrieve its ID;
  includes optional `rank` argument to filter by taxonomic level
- `inat_search_place()` — search for a place by name and retrieve its ID

## Improvements
- `inat_fetch()` now accepts multiple annotations as a character vector
  (e.g. `c("flowers", "green_leaves")`); each is fetched separately and
  results are combined with duplicates removed
- `inat_download()` now saves `metadata.csv` automatically alongside photos
  by default (`metadata = TRUE`); use `metadata = FALSE` to skip
- `inat_download()` file names now include the size suffix
  (e.g. `obs123_456_large.jpg`)
- `inat_download()` prints the full output path after downloading
- `inat_metadata()` column names cleaned up: `taxon`, `common_name`, `user`,
  `user_name`, `place`, `url` instead of raw API names
- Fixed `num_photos` bug in `inat_metadata()` that was counting fields instead
  of photos
- Added startup message on `library(inatpick)` with workflow overview
- Added note on `common_name` locale in `inat_search_taxon()` and
  `inat_metadata()` documentation

# inatpick 0.1.0

- Initial release
- `inat_fetch()` — fetch observations from the iNaturalist API
- `inat_download()` — download photos to a local folder
- `inat_metadata()` — export observation metadata to CSV
- `inat_annotations` — annotation labels and IDs lookup table