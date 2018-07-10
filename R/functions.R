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
#' @param type either one of 'companies' or 'commodities'
#' @param q RIC code for the company for which you want to query news intensity values or name of commodity for which you want to query news intensity values. See documentation for supported commodities.
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

fintxt_live_intensities_one <- function(type = c("companies", "commodities"),
                                        language = c("total", "english", "french",
                                                     "russian", "arabic", "german"), q) {

  type <- match.arg(type)
  language <- match.arg(language)

  # Date allowed
  free <- Sys.Date() - 30

  # Check parameters
  if(is(language)[1] != "character") {
    stop("Language must be a character ...")
  }
  if(is(q)[1] != "character") {
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
  url <- paste0(url, "live/", type, "/", language, "?q=", q)

  # Call
  r <- httr::GET(
    url = url,
    httr::add_headers("API-TOKEN" = Sys.getenv("FINTXT_CLIENT_TOKEN"))
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

#' Retrieve historic news intensities
#'
#' Retrieve historic news intensities for a language, a date and a company's \href{https://en.wikipedia.org/wiki/Reuters_Instrument_Code}{Reuters Instrument Code}. Note that you need to supply a valid api token if you want to query data for the last 30 days.
#'
#' @param type either one of 'companies' or 'commodities'
#' @param language Filter news intensity values by language. See the '/languages' endpoint for allowed values.
#' @param date Filter news intensity values by date.
#' @param q RIC code for the company for which you want to query news intensity values or name of commodity for which you want to query news intensity values. See documentation for supported commodities.
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

fintxt_historic_intensities_one <- function(type = c("companies", "commodities"),
                                            language = c("total", "english", "french",
                                                         "russian", "arabic", "german"),
                                            date, q) {

  type <- match.arg(type)
  language <- match.arg(language)

  # Date allowed
  free <- Sys.Date() - 30

  # Check parameters
  if(is(language)[1] != "character") {
    stop("Language must be a character ...")
  }
  if(is(q)[1] != "character") {
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
  url <- paste0(url, "historic/", type, "/", language, "/", date, "?q=", q)

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

#' Retrieve historic news intensities for a portfolio of company RICs or commodities
#'
#' Retrieve historic news intensities for a language, a date and a company's \href{https://en.wikipedia.org/wiki/Reuters_Instrument_Code}{Reuters Instrument Code} or commodities. Note that you need to supply a valid api token.
#'
#' @param type either one of 'companies' or 'commodities'
#' @param language Filter news intensity values by language. See the '/languages' endpoint for allowed values.
#' @param identifiers RIC codes for the companies for which you want to query news intensity values or names of commodities for which you want to query news intensity values. See documentation for supported commodities. Note that you cannot mix companies and commodities
#' @param weights Weight of each company/commodity in your portfolio in decimal format. Should sum to 1, but the API will still return news intensities if this is not the case. See example section.
#'
#' @importFrom httr GET
#' @importFrom httr content
#' @importFrom httr http_error
#' @importFrom httr add_headers
#' @importFrom jsonlite toJSON
#'
#' @seealso See the documentation at <https://fintxt.github.io/documentation/index.html>
#'
#' @return List containing API results
#'
#' @examples
#' \dontrun{
#' # historic portfolio endpoint
#' identifiers = c("TRI.TO", "IBM.N", "RRD.N", "SPGI.N", "INTU.OQ", "RELN.AS", "WLSNc.AS", "REL.L"),
#' weights = c(0.3, 0.1,0.05,0.05, 0.2,0.1,0.1,0.1)
#' fintxt_historic_intensities_portfolio("companies", "english", "18-06-2018", identifiers, weights)
#' }
#'
#' @export

fintxt_historic_intensities_portfolio <- function(type = c("companies", "commodities"),
                                                  language = c("total", "english", "french",
                                                               "russian", "arabic", "german"),
                                                  date, identifiers, weights) {

  type <- match.arg(type)
  language <- match.arg(language)

  # Check parameters
  if(is(language)[1] != "character") {
    stop("Language must be a character ...")
  }
  if(is(identifiers)[1] != "character") {
    stop("'identifiers' must be a character ...")
  }
  if(is(weights)[1] != "numeric") {

    stop("'weights' should be numeric")

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

    }

  }
  if(length(identifiers) != length(weights)) {

    stop("Length of identifiers is not equal to length of weights")

  }
  # Check if token supplied
  if(Sys.getenv("FINTXT_CLIENT_TOKEN") == "") {

    stop("Calling this endpoint requires an API token. No API token supplied. Set your token using 'Sys.setenv('FINTXT_CLIENT_TOKEN'='<YOURTOKEN>')'")

  }

  # Append url
  url <- Sys.getenv("FINTXT_CLIENT_URL")
  if(!substr(url, nchar(url), nchar(url)) == "/") {

    url <- paste0(url, "/")

  }
  url <- paste0(url, "portfolio/historic")

  # Make post body
  body <- list(
    "identifiers" = identifiers,
    "weights" = weights,
    "type" = type,
    "language" = language,
    "date" = date
  )

  # To json
  body_json <- jsonlite::toJSON(body)

  # POST
  r <- httr::POST(url = url,
                  body = body_json,
                  httr::add_headers("API_TOKEN"=Sys.getenv("FINTXT_CLIENT_TOKEN")))

  # Return
  if(httr::http_error(r)) {

    # Get error
    err <- httr::content(r)

    stop("API returned error '", err$status, "': '", err$error, "'")

  } else {

    res <- httr::content(r)
    # Check for warnings
    if(res$warnings$warnings) {

      for(warning_ret in res$warnings$warning) {

        warning(warning_ret)

      }

    }

    # Return
    return(res)

  }

}

#' Retrieve live news intensities for a portfolio of company RICs or commodities
#'
#' Retrieve live news intensities for a language, a date and a company's \href{https://en.wikipedia.org/wiki/Reuters_Instrument_Code}{Reuters Instrument Code}. Note that you need to supply a valid api token.
#'
#' @param type either one of 'companies' or 'commodities'
#' @param language Filter news intensity values by language. See the '/languages' endpoint for allowed values.
#' @param date Filter news intensity values by date.
#' @param identifiers RIC codes for the companies for which you want to query news intensity values or names of commodities for which you want to query news intensity values. See documentation for supported commodities. Note that you cannot mix companies and commodities
#' @param weights Weight of each company/commodity in your portfolio in decimal format. Should sum to 1, but the API will still return news intensities if this is not the case. See example section.
#'
#' @importFrom httr GET
#' @importFrom httr content
#' @importFrom httr http_error
#' @importFrom httr add_headers
#' @importFrom jsonlite toJSON
#'
#' @seealso See the documentation at <https://fintxt.github.io/documentation/index.html>
#'
#' @return List containing API results
#'
#' @examples
#' \dontrun{
#' # historic portfolio endpoint
#' identifiers = c("TRI.TO", "IBM.N", "RRD.N", "SPGI.N", "INTU.OQ", "RELN.AS", "WLSNc.AS", "REL.L"),
#' weights = c(0.3, 0.1,0.05,0.05, 0.2,0.1,0.1,0.1)
#' fintxt_live_intensities_portfolio("companies", "english", identifiers, weights)
#' }
#'
#' @export

fintxt_live_intensities_portfolio <- function(type = c("companies", "commodities"),
                                                  language = c("total", "english", "french",
                                                               "russian", "arabic", "german"),
                                                  identifiers, weights) {

  type <- match.arg(type)
  language <- match.arg(language)

  # Check parameters
  if(is(language)[1] != "character") {
    stop("Language must be a character ...")
  }
  if(is(identifiers)[1] != "character") {
    stop("'identifiers' must be a character ...")
  }
  if(is(weights)[1] != "numeric") {

    stop("'weights' should be numeric")

  }
  if(length(identifiers) != length(weights)) {

    stop("Length of identifiers is not equal to length of weights")

  }
  # Check if token supplied
  if(Sys.getenv("FINTXT_CLIENT_TOKEN") == "") {

    stop("Calling this endpoint requires an API token. No API token supplied. Set your token using 'Sys.setenv('FINTXT_CLIENT_TOKEN'='<YOURTOKEN>')'")

  }

  # Append url
  url <- Sys.getenv("FINTXT_CLIENT_URL")
  if(!substr(url, nchar(url), nchar(url)) == "/") {

    url <- paste0(url, "/")

  }
  url <- paste0(url, "portfolio/live")

  # Make post body
  body <- list(
    "identifiers" = identifiers,
    "weights" = weights,
    "type" = type,
    "language" = language
  )

  # To json
  body_json <- jsonlite::toJSON(body)

  # POST
  r <- httr::POST(url = url,
                  body = body_json,
                  httr::add_headers("API_TOKEN"=Sys.getenv("FINTXT_CLIENT_TOKEN")))

  # Return
  if(httr::http_error(r)) {

    # Get error
    err <- httr::content(r)

    stop("API returned error '", err$status, "': '", err$error, "'")

  } else {

    res <- httr::content(r)
    # Check for warnings
    if(res$warnings$warnings) {

      for(warning_ret in res$warnings$warning) {

        warning(warning_ret)

      }

    }

    # Return
    return(res)

  }

}
