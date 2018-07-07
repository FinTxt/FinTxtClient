# --------------------------------------------------------------------------------
#
# Functions go here
#
# --------------------------------------------------------------------------------

#' Retrieve historic or live news intensities
#'
#' @param endpoint API endpoint to use. Must be one of must be one of 'languages', 'live', 'historic'
#' @param language Filter news intensity values by language. See the '/languages' endpoint for allowed values
#' @param ric RIC code for the company for which you want to query news intensity values
#' @param date Filter news intensity values by date. Defaults to NULL.
#'
#' @importFrom httr GET
#' @importFrom httr content
#' @importFrom httr http_error
#' @importFrom httr add_headers
#'
#' @export

fintxt_client_get <- function(endpoint, language, ric, date = NULL) {

  # Check if endpoint allowed
  if(!endpoint %in% c("languages", "live", "historic")) {

    stop("Endpoint must be one of 'languages', 'live', 'historic'")

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

    url <- paste0(url, "/", endpoint)

  }

  # Call api
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
