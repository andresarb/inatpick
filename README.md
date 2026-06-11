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

# 1. Fetch observations
obs <- inat_fetch(
  taxon_id   = 488444,   # Caiophora chuquitensis
  place_id   = 6783,     # Bolivia
  user_login = "someuser"
)

# Filter by annotation (e.g. only observations with open flowers)
obs_flowers <- inat_fetch(
  taxon_id   = 488444,
  annotation = "flowers"
)

# 2. Download photos (large size by default)
inat_download(obs, out_dir = "chuquitensis_photos", size = "large")

# 3. Export metadata to CSV
inat_metadata(obs, path = "chuquitensis_bolivia.csv")
```

## Functions

| Function | Description |
|---|---|
| `inat_fetch()` | Fetch observations from the iNaturalist API |
| `inat_download()` | Download photos to a local folder |
| `inat_metadata()` | Export observation metadata to CSV |
| `inat_annotations` | Table of all available annotation labels and IDs |

## Arguments

### `inat_fetch()`
- `taxon_id` — iNaturalist taxon ID (required)
- `place_id` — iNaturalist place ID (optional)
- `user_login` — iNaturalist username (optional)
- `annotation` — filter by annotation label e.g. `"flowers"`, `"fruit"`, `"alive"`, `"adult"` (optional)
- `quality_grade` — `"research"`, `"needs_id"`, or `"any"` (default)
- `year` / `month` — filter by observation date (optional)
- `licensed` — if `TRUE`, return only CC-licensed observations (optional)

### `inat_download()`
- `size` — `"square"`, `"small"`, `"medium"`, `"large"` (default), or `"original"`
- `overwrite` — re-download existing files (default `FALSE`)

### `inat_metadata()`
- `path` — output CSV file path
- `extra_cols` — additional columns from the API response to include

## Finding IDs

- **Taxon ID**: visible in the iNaturalist URL, e.g. `inaturalist.org/taxa/488444`
- **Place ID**: visible in the URL when browsing places, e.g. `inaturalist.org/places/6783`
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