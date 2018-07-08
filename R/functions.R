# --------------------------------------------------------------------------------
#
# Functions go here
#
# --------------------------------------------------------------------------------

#' Retrieve languages for which you can query news intensities
#'
#' @importFrom httr GET
#' @importFrom httr content
#' @importFrom httr http_error
#'
#' @return list of languages
#' @export

fintxt_get_languages <- function() {

  # Retrieve base url
  url <- Sys.getenv("FINTXT_CLIENT_URL")

  # Update endpoint
  if(!substr(url, nchar(url), nchar(url)) == "/") {

    url <- paste0(url, "/")

  }
  url <- paste0(url, "languages")

  # Send GET request
  r <- httr::GET(
    url = url
  )

  # If error, raise error
  if(httr::http_error(r)) {

    # Get error
    err <- httr::content(r)

    stop("API returned error '", err$status, "': '", err$error, "'")

  } else { # Return

    httr::content(r)

  }

}

#' Retrieve live news intensities
#'
#' Retrieve live news intensities for a language, a date and a company's \href{https://en.wikipedia.org/wiki/Reuters_Instrument_Code}{Reuters Instrument Code}
#'
#' @param language Filter news intensity values by language. See the '/languages' endpoint for allowed values. Defaults to NULL.
#' @param date Filter news intensity values by date. Defaults to NULL.
#' @param ric RIC code for the company for which you want to query news intensity values. Defaults to NULL.
#'
#' @importFrom httr GET
#' @importFrom httr content
#' @importFrom httr http_error
#' @importFrom httr add_headers
#'
#' @seealso See the documentation at <https://fintxt.github.io/documentation/index.html>
#'
#' @return List containing
#'
#' @export

fintxt_live_intensities <- function() {



}

#' Retrieve live news intensities
#'
#' @param language Filter news intensity values by language. See the '/languages' endpoint for allowed values. Defaults to NULL.
#' @param ric RIC code for the company for which you want to query news intensity values. Defaults to NULL.
#' @param date Filter news intensity values by date. Defaults to NULL.
#'
#' @importFrom httr GET
#' @importFrom httr content
#' @importFrom httr http_error
#' @importFrom httr add_headers
#'
#' @return List containing API response or error
#'
#' @export

fintxt_client_get <- function(endpoint, language = NULL, ric = NULL, date = NULL) {

  # Check if endpoint allowed
  if(!endpoint %in% c("languages", "live", "historic")) {

    stop("Endpoint must be one of 'languages', 'live', 'historic'")

  }

  # Check if params are character
  if(is(endpoint)[1] != "character") {
    stop("Endpoint must be a character ...")
  }
  if(!is.null(language)) {
    if(is(language)[1] != "character") {
      stop("Language must be a character ...")
    }
  }
  if(!is.null(ric)) {
    if(is(ric)[1] != "character") {
      stop("RIC must be a character ...")
    }
  }
  if(!is.null(date)) {
    if(is(date)[1] != "character") {
      stop("Date must be a character ...")
    }
  }

  # Check if token supplied
  if(Sys.getenv("FINTXT_CLIENT_TOKEN") == "") {

    stop("No API token supplied. Set your token using 'Sys.setenv('FINTXT_CLIENT_TOKEN'='<YOURTOKEN>')'")

  }

  url <- Sys.getenv("FINTXT_CLIENT_URL")

  # Paste endpoint
  if(!substr(url, nchar(url), nchar(url)) == "/") {

    url <- paste0(url, "/")

  }

  if(endpoint == "live") {

    url <- paste0(url, endpoint, "/", language, "?ric=", ric)

  } else if(endpoint == "historic") {

    url <- paste0(url, endpoint, "/", language, "/", date, "?ric=", ric)

  } else {

    url <- paste0(url, endpoint)

  }

  # Call api
  if(endpoint == "languages") {

    r <- httr::GET(
      url = url
    )

  } else {

    r <- httr::GET(
      url = url,
      httr::add_headers("API-TOKEN" = Sys.getenv("FINTXT_CLIENT_TOKEN"))
    )

  }

  # If error, raise error
  if(httr::http_error(r)) {

    # Get error
    err <- httr::content(r)

    stop("API returned error '", err$status, "': '", err$error, "'")

  } else { # Return

    httr::content(r)

  }

}
