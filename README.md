# FinTxtClient

Client to work with the FinTxt news intensities API.

## Installing

Install the package by executing 

```r
devtools::install_github("FinTxt/FinTxtClient")
```

## Usage

After installing the package, use the following code to call the endpoints:

```r
library(FinTxtClient)
Sys.setenv("FINTXT_CLIENT_TOKEN" = "<yourtoken>")
r <- fintxt_get_languages()
```

// TODO: update examples
