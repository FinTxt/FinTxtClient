context("test-test_languages_endpoint.R")

test_that("The client can retrieve all languages", {

  # Get languages
  langs = fintxt_get_languages()
  expect_equal(unlist(langs), c("english", "french", "german", "russian", "arabic", "total"))

})
