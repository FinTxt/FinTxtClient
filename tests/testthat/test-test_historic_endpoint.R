context("test-test_historic_endpoint.R")

test_that("Client can retrieve data from the historic endpoint", {

  company <- "TRI.TO"
  date <- "03-06-2018"
  language <- "english"

  res <- fintxt_historic_intensities_one("companies", language, date, company)

  expect_length(res, 3)

  expect_equal(names(res), c("request", "news_intensity", "company"))

  expect_equal(res$news_intensity, 4.381)

  expect_length(res$request, 5)

  res <- fintxt_historic_intensities_one("commodities", language, date, "milk")

  expect_length(res, 2)

  expect_equal(res$news_intensity, 3.6009)

  expect_error(fintxt_historic_intensities_one("companies", language, date, "monkey"),
               "API returned error '400'")

})
