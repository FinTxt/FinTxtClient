context("test-test_api_errors.R")

test_that("API returns errors on bad requests", {

  language <- "total"
  date <- format(Sys.Date() - 1, "%d-%m-%Y")
  q <- "TRI.TO"

  expect_error(fintxt_historic_intensities_one("companies", language, date, q),
               "Calling this endpoint with a date")

  expect_error(fintxt_historic_intensities_one("companies", "chinese", format(Sys.Date() - 35, "%d-%m-%Y"), q),
               "'arg' should be one of")

  Sys.setenv('FINTXT_CLIENT_TOKEN'='TOKTOKTOK')

  expect_error(fintxt_historic_intensities_one("companies", language, date, q),
               "API returned error '401': 'Bad token.")

  expect_error(fintxt_historic_intensities_one("companies", language, format(Sys.Date() + 1, "%d-%m-%Y"), q),
               "Date out of range")

  expect_error(fintxt_live_intensities_one("companies",language,q),
               "API returned error '401'")

  expect_error(fintxt_live_intensities_portfolio("companies", language, c("TRI.TO", "AAPL.OQ"), c(0.5,0.5)),
               "API returned error '401'")

})
