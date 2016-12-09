# README.md

#### __The presentation is also published on RPub__, please follow the [link to the published presentation](http://rpubs.com/imreyes/233962).

## Introduction

This ioslides presentation depicts levels of pollutions of metal dusts, by states in the US.

There are 13 types of metal dusts: `Barium (Ba)`, `Beryllium (Be)`, `Cadmium (Cd)`, `Calcium (Ca)`, `Chromium (Cr)`, `Copper (Cu)`, `Iron (Fe)`, `Lead (Pb)`, `Manganese (Mn)`, `Molybdenum (Mo)`, `Nickel (Ni)`, `Vanadium (V)`, `Zinc (Zn)`.

Data on map are averaged measurements from all monitors in the same state, and with unit of `mg/m^3`.

Processed R data object (`DataGalleryMetal.rda`) contains all data from 1990 to 2016; only the data of 2015 is shown in this presentation (data of 2016 is incomplete), with `Cadmium (Cd)` and `Lead (Pb)` maps in 1990 is provided for comparison, right after their maps of 2015.

## Sources of Data

This document originates some cleaned data from the annual pollution data from [EPA Air-Data webpage](https://www.epa.gov/outdoor-air-quality-data). For more information of [data downloading](https://aqsdr1.epa.gov/aqsweb/aqstmp/airdata/download_files.html) or [data documentation](https://aqsdr1.epa.gov/aqsweb/aqstmp/airdata/FileFormats.html#_annual_summary_files), please follow the links to the EPA websites.

## Access to Codes

The [DataGalleryMetal.rda](https://github.com/imreyes/datasciencecoursera/blob/master/DevelopingDataProduct/Week3_ProgrammingAssignment/DataGalleryMetal.rda) stores the list named `data.gallery.metal` which contains the necessary data chunks for mapping. Codes to generate the list is stored in [GasPollutionMetal_DataProcessor.R](https://github.com/imreyes/datasciencecoursera/blob/master/DevelopingDataProduct/Week3_ProgrammingAssignment/GasPollutionMetal_DataProcessor.R) file. 
