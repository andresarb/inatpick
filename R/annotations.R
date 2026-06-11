#' iNaturalist annotation term and value IDs
#'
#' A named lookup table for human-readable annotation labels and their
#' corresponding iNaturalist `term_id` and `term_value_id` pairs, for use
#' with [inat_fetch()].
#'
#' @format A data frame with columns `label`, `term_id`, `term_value_id`.
#' @export
inat_annotations <- data.frame(
  label = c(
    # Plant phenology (term_id = 12)
    "flowers", "fruit", "flower_buds", "no_flowers_fruit",
    # Leaves (term_id = 36)
    "breaking_leaf_buds", "green_leaves", "colored_leaves", "no_live_leaves",
    # Life stage (term_id = 1)
    "adult", "juvenile", "larva", "pupa", "egg", "nymph", "teneral", "subimago",
    # Sex (term_id = 9)
    "female", "male",
    # Alive or dead (term_id = 17)
    "alive", "dead"
  ),
  term_id = c(
    12, 12, 12, 12,
    36, 36, 36, 36,
     1,  1,  1,  1,  1,  1,  1,  1,
     9,  9,
    17, 17
  ),
  term_value_id = c(
    13, 14, 15, 21,
    37, 38, 39, 40,
     2,  8,  6,  4,  7,  5,  3, 16,
    10, 11,
    18, 19
  ),
  stringsAsFactors = FALSE
)

#' Resolve annotation label to term_id and term_value_id
#'
#' @param annotation Character. A label from [inat_annotations], or an integer
#'   vector of length 2 (`c(term_id, term_value_id)`) for direct ID use.
#' @return A named integer vector with `term_id` and `term_value_id`.
#' @keywords internal
resolve_annotation <- function(annotation) {
  if (is.numeric(annotation) && length(annotation) == 2) {
    return(setNames(as.integer(annotation), c("term_id", "term_value_id")))
  }
  if (is.character(annotation) && length(annotation) == 1) {
    row <- inat_annotations[inat_annotations$label == annotation, ]
    if (nrow(row) == 0) {
      stop("Unknown annotation label: '", annotation,
           "'. See inat_annotations for valid labels.")
    }
    return(c(term_id = row$term_id, term_value_id = row$term_value_id))
  }
  stop("`annotation` must be a label string or integer vector c(term_id, term_value_id).")
}
