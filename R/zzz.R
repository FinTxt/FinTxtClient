# --------------------------------------------------------------------------
#
# zzz.R is evaluated when the package is loaded
#
# --------------------------------------------------------------------------

# When the package is loaded, do ...
.onLoad <- function(libname = find.package("FinTxtClient"), pkgname="FinTxtClient") {

  # Set options for retinaSDK python module
  if(Sys.getenv("FINTXT_CLIENT_URL") == "") {
    Sys.setenv("FINTXT_CLIENT_URL" = "http://api.fintxt.io/rest")
  }

}
