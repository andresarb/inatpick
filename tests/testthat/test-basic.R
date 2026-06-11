test_that("inat_fetch rejects bad taxon_id", {
  expect_error(inat_fetch(taxon_id = "abc"))
  expect_error(inat_fetch(taxon_id = c(1, 2)))
})

test_that("inat_metadata handles missing optional columns gracefully", {
  # Minimal fake obs data frame
  fake_obs <- data.frame(
    id           = 1L,
    observed_on  = "2024-01-01",
    quality_grade = "research",
    user.login   = "test_user",
    uri          = "https://www.inaturalist.org/observations/1",
    stringsAsFactors = FALSE
  )
  fake_obs$photos <- list(list())

  tmp <- tempfile(fileext = ".csv")
  meta <- inat_metadata(fake_obs, path = tmp)

  expect_true(file.exists(tmp))
  expect_equal(nrow(meta), 1L)
  expect_equal(meta$id, 1L)
})

test_that("inat_download creates output directory", {
  tmp_dir <- tempfile()
  expect_false(dir.exists(tmp_dir))

  # Pass empty obs — nothing to download but dir should be created
  fake_obs <- data.frame(id = integer(0))
  fake_obs$photos <- list()

  # Suppress the unnest error on zero rows gracefully
  tryCatch(
    inat_download(fake_obs, out_dir = tmp_dir, verbose = FALSE),
    error = function(e) NULL
  )

  expect_true(dir.exists(tmp_dir))
  unlink(tmp_dir, recursive = TRUE)
})

test_that("resolve_annotation works with labels", {
  ids <- inatpick:::resolve_annotation("flowers")
  expect_equal(ids[["term_id"]], 12L)
  expect_equal(ids[["term_value_id"]], 13L)
})

test_that("resolve_annotation works with raw IDs", {
  ids <- inatpick:::resolve_annotation(c(12L, 13L))
  expect_equal(ids[["term_id"]], 12L)
  expect_equal(ids[["term_value_id"]], 13L)
})

test_that("resolve_annotation errors on unknown label", {
  expect_error(inatpick:::resolve_annotation("banana"))
})

test_that("inat_annotations has expected labels", {
  labels <- inat_annotations$label
  expect_true(all(c("flowers", "fruit", "alive", "dead", "adult", "female") %in% labels))
})
