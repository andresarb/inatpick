# inatpick

An R package for downloading photos and metadata from [iNaturalist](https://www.inaturalist.org) via its API. Supports filtering by taxon, place, user, and annotation.

## Installation

```r
# Install from GitHub
remotes::install_github("andresarb/inatpick")
```

## Usage

```r
library(inatpick)

# 0. Find taxon and place IDs by name
inat_search_taxon("Drosera", rank = "genus")
inat_search_place("United Kingdom")

# 1. Fetch observations
obs <- inat_fetch(
  taxon_id      = 51935,    # Drosera genus
  place_id      = 6857,     # United Kingdom
  user_login    = "andresrb",
  annotation    = c("green_leaves", "flowers"),
  quality_grade = "research",
  licensed      = TRUE
)

# 2. Download photos and metadata to the same folder
inat_download(obs, out_dir = "drosera_photos", size = "large")

# Download photos only, no metadata
inat_download(obs, out_dir = "drosera_photos", metadata = FALSE)

# 3. Export metadata separately if needed
inat_metadata(obs, path = file.path("drosera_photos", "metadata.csv"))
```

## Functions

| Function | Description |
|---|---|
| `inat_search_taxon()` | Search for a taxon by name and retrieve its ID |
| `inat_search_place()` | Search for a place by name and retrieve its ID |
| `inat_fetch()` | Fetch observations from the iNaturalist API |
| `inat_download()` | Download photos (and optionally metadata) to a local folder |
| `inat_metadata()` | Export observation metadata to CSV |
| `inat_annotations` | Table of all available annotation labels and IDs |

## Arguments

### `inat_search_taxon()`
- `name` — taxon name to search (common or scientific)
- `rank` — filter by taxonomic rank e.g. `"genus"`, `"species"`, `"family"` (optional)
- `n` — maximum number of results to return (default 10)

### `inat_search_place()`
- `name` — place name to search
- `n` — maximum number of results to return (default 10)

### `inat_fetch()`
- `taxon_id` — iNaturalist taxon ID (required)
- `place_id` — iNaturalist place ID (optional)
- `user_login` — iNaturalist username (optional)
- `annotation` — filter by one or more annotation labels e.g. `"flowers"`, `c("flowers", "green_leaves")` (optional)
- `quality_grade` — `"research"`, `"needs_id"`, or `"any"` (default)
- `year` / `month` — filter by observation date (optional)
- `licensed` — if `TRUE`, return only CC-licensed observations (optional)

### `inat_download()`
- `out_dir` — output folder for photos and metadata
- `size` — photo resolution: `"square"` (75px), `"small"` (240px), `"medium"` (500px), `"large"` (1024px, default), or `"original"` (full resolution). For research use `"large"` or `"original"`; for quick previews use `"small"` or `"medium"`. Size is appended to the filename (e.g. `obs123_456_large.jpg`).
- `metadata` — if `TRUE` (default), saves `metadata.csv` to `out_dir` automatically
- `overwrite` — re-download existing files (default `FALSE`)

### `inat_metadata()`
- `path` — output CSV file path
- `extra_cols` — additional columns from the API response to include

## Finding IDs

Use the search functions or find IDs directly in iNaturalist URLs:

- **Taxon ID**: `inaturalist.org/taxa/51935` → `51935`
- **Place ID**: `inaturalist.org/places/6857` → `6857`
- **Annotation labels**: run `inat_annotations` in R to see all available options

## Photo Licenses & Attribution

inatpick is MIT licensed. However, photos downloaded from iNaturalist retain 
their own licenses as set by individual observers (CC0, CC-BY, CC-BY-NC, etc.). 
Users are responsible for respecting these licenses when using downloaded images 
for research or publication. Use `licensed = TRUE` in `inat_fetch()` to restrict 
downloads to CC-licensed photos only.

See [iNaturalist Terms of Service](https://www.inaturalist.org/pages/terms) for more information.

## License

MIT © Andrés Romero-Bravo

## About

This package was developed as a personal project to support biodiversity
research using iNaturalist data. It is maintained on a best-effort basis.

For bug reports, feature requests, or general questions, please open an
issue on [GitHub](https://github.com/andresarb/inatpick/issues).

**Disclaimer:** This package is provided as-is, without warranty of any kind.
Users are responsible for complying with iNaturalist's Terms of Service and
respecting the licenses of downloaded photos.

## AI Disclosure
This package was developed with the assistance of Claude (Anthropic). 
All code has been reviewed and tested by the author.