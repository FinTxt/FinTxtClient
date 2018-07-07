# --------------------------------------------------------------------------------
#
# Functions go here
#
# --------------------------------------------------------------------------------

fintxt_client_get <- function(endpoint, language, ric, date) {

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
