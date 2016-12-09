# README.md

### Links to [shiny app](https://imreyes.shinyapps.io/GasMetalPollution/) and [presentation](http://rpubs.com/imreyes/GasMetalPollution)

### `ui.R` and `server.R` of the shiny app are in `GasMetalPollution` folder.

### `GasMetalPollution.rmd` knits to the shiny presentation.

### `DataGalleryGasMetal.rda` stores the R matrix object (64 * 27 lists), with years in columns, and every consecutive 4 rows combines into a data frame and stores data of one pollutant type.

### `GasMetalPollution_DataProcessor.R` creates the `DataGalleryGasMetal.rda` file from the online source (see below for more information).


## Introduction

This repo contains all files and codes for the shiny application and presentation regarding visualization of pollutions in the states of US (see above links).

There are 13 types of metal dusts: `Barium (Ba)`, `Beryllium (Be)`, `Cadmium (Cd)`, `Calcium (Ca)`, `Chromium (Cr)`, `Copper (Cu)`, `Iron (Fe)`, `Lead (Pb)`, `Manganese (Mn)`, `Molybdenum (Mo)`, `Nickel (Ni)`, `Vanadium (V)`, `Zinc (Zn)`.

The 3 types of gases are: `Sulfur dioxide`, `Carbon monoxide`, `Ozone`.

Processed R data object (`DataGalleryGasMetal.rda`) contains all data from 1990 to 2016.

## Sources of Data

This document originates some cleaned data from the annual pollution data from [EPA Air-Data webpage](https://www.epa.gov/outdoor-air-quality-data). For more information of [data downloading](https://aqsdr1.epa.gov/aqsweb/aqstmp/airdata/download_files.html) or [data documentation](https://aqsdr1.epa.gov/aqsweb/aqstmp/airdata/FileFormats.html#_annual_summary_files), please follow the links to the EPA websites.
