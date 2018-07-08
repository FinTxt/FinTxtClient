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
#'
#' @examples
#' \dontrun{
#' # Call languages endpoint
#' library(FinTxtClient)
#' lang <- fintxt_get_languages()
#' }
#'
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
#' Retrieve live news intensities for a language and a company's \href{https://en.wikipedia.org/wiki/Reuters_Instrument_Code}{Reuters Instrument Code}. Note that you need to supply a valid api token.
#'
#' @param language Filter news intensity values by language. See the '/languages' endpoint for allowed values.
#' @param ric RIC code for the company for which you want to query news intensity values.
#'
#' @importFrom httr GET
#' @importFrom httr content
#' @importFrom httr http_error
#' @importFrom httr add_headers
#'
#' @seealso See the documentation at <https://fintxt.github.io/documentation/index.html>
#'
#' @return List containing API results
#'
#' @examples
#' \dontrun{
#' # Call languages endpoint
#' library(FinTxtClient)
#' r <- fintxt_live_intensities("english", "TRI.TO")
#' }
#'
#' @export

fintxt_live_intensities <- function(language, ric) {

  # Date allowed
  free <- Sys.Date() - 30

  # Check parameters
  if(is(language)[1] != "character") {
    stop("Language must be a character ...")
  }
  if(is(ric)[1] != "character") {
    stop("RIC must be a character ...")
  }

  # Check if token supplied
  if(Sys.getenv("FINTXT_CLIENT_TOKEN") == "") {

    stop("No API token supplied. Set your token using 'Sys.setenv('FINTXT_CLIENT_TOKEN'='<YOURTOKEN>')'")

  }

  # Retrieve url & paste endpoint
  url <- Sys.getenv("FINTXT_CLIENT_URL")
  if(!substr(url, nchar(url), nchar(url)) == "/") {

    url <- paste0(url, "/")

  }
  url <- paste0(url, "live/", language, "?ric=", ric)

  # If error, raise error
  if(httr::http_error(r)) {

    # Get error
    err <- httr::content(r)

    stop("API returned error '", err$status, "': '", err$error, "'")

  } else { # Return

    httr::content(r)

  }

}

#' Retrieve historic news intensities
#'
#' Retrieve live news intensities for a language, a date and a company's \href{https://en.wikipedia.org/wiki/Reuters_Instrument_Code}{Reuters Instrument Code}. Note that you need to supply a valid api token.
#'
#' @param language Filter news intensity values by language. See the '/languages' endpoint for allowed values.
#' @param date Filter news intensity values by date.
#' @param ric RIC code for the company for which you want to query news intensity values.
#'
#' @importFrom httr GET
#' @importFrom httr content
#' @importFrom httr http_error
#' @importFrom httr add_headers
#'
#' @seealso See the documentation at <https://fintxt.github.io/documentation/index.html>
#'
#' @return List containing API results
#'
#' @examples
#' \dontrun{
#' # Call languages endpoint
#' library(FinTxtClient)
#' r <- fintxt_historic_intensities("english", Sys.Date()-40, "TRI.TO")
#' }
#'
#' @export

fintxt_historic_intensities <- function(language, date, ric) {

  # Date allowed
  free <- Sys.Date() - 30

  # Check parameters
  if(is(language)[1] != "character") {
    stop("Language must be a character ...")
  }
  if(is(ric)[1] != "character") {
    stop("RIC must be a character ...")
  }
  if(is(date)[1] != "character") {

    stop("Date must be a character ...")

  } else {

    # Check if in right format
    date_formt <- as.Date(date, format="%d-%m-%Y")
    if(is.na(date_formt)) {

      stop("Date supplied is not in the required format. Please pass dates as '<day>-<month>-<year>'")

    }

    # Check if date is allowed
    if(date_formt < as.Date("18-03-2016", format="%d-%m-%Y")) {

      stop("Date out of range")

    } else if (date_formt > (Sys.Date() - 1)) {

      stop("Date out of range")

    } else {

      # If date > today - 30 days, then require token
      if(date_formt > (Sys.Date() - 30)) {

        # Check if token supplied
        if(Sys.getenv("FINTXT_CLIENT_TOKEN") == "") {

          stop("Calling this endpoint with a date later than 30 days ago requires an API token. No API token supplied. Set your token using 'Sys.setenv('FINTXT_CLIENT_TOKEN'='<YOURTOKEN>')'")

        }

        require_token <- TRUE

      } else {

        require_token <- FALSE

      }

    }

  }

  # Retrieve url & paste endpoint
  url <- Sys.getenv("FINTXT_CLIENT_URL")
  if(!substr(url, nchar(url), nchar(url)) == "/") {

    url <- paste0(url, "/")

  }
  url <- paste0(url, "historic/", language, "/", date, "?ric=", ric)

  # Send request
  if(require_token) {

    r <- httr::GET(
      url = url,
      httr::add_headers("API-TOKEN" = Sys.getenv("FINTXT_CLIENT_TOKEN"))
    )

  } else {

    r <- httr::GET(
      url = url
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
