# FinTxtClient

[![Project Status: Inactive – The project has reached a stable, usable state but is no longer being actively developed; support/maintenance will be provided as time allows.](http://www.repostatus.org/badges/latest/inactive.svg)](http://www.repostatus.org) [![lifecycle](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable) [![minimal R version](https://img.shields.io/badge/R%3E%3D-3.1.0-6666ff.svg)](https://cran.r-project.org/) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/sfutils)](https://cran.r-project.org/package=FinTxtClient) [![Build Status](https://travis-ci.org/FinTxt/FinTxtClient-R.svg?branch=master)](https://travis-ci.org/FinTxt/FinTxtClient-R)

R client to work with the FinTxt news intensities API found at [https://api.fintxt.io/rest/](https://api.fintxt.io/rest/).

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

See the documentation [here](https://fintxt.github.io/documentation/theapi.html)
