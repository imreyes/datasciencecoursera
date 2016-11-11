# Case Study Code Book

### Course Info and Materials are from [Peer-graded Assignment: Course Project 2] (https://www.coursera.org/learn/exploratory-data-analysis/peer/b5Ecl/course-project-2)

## __PM2.5 Levels in the US (1999 ~ 2012)__

This case study uses 2 file:

`summarySCC_PM25.rds`: This file contains a data frame with all of the PM2.5 emissions data for 1999, 2002, 2005, and 2008. For each year, the table contains number of tons of PM2.5 emitted from a specific type of source for the entire year.

* `fips`: A five-digit number (represented as a string) indicating the U.S. county

* `SCC`: The name of the source as indicated by a digit string (see source code classification table)

* `Pollutant`: A string indicating the pollutant

* `Emissions`: Amount of PM2.5 emitted, in tons

* `type`: The type of source (point, non-point, on-road, or non-road)

* `year`: The year of emissions recorded

`Source_Classfication_Code.rds`: This table provides a mapping from the SCC digit strings in the Emissions table to the actual name of the PM2.5 source. The sources are categorized in a few different ways from more general to more specific and you may choose to explore whatever categories you think are most useful. For example, source "10100101" is known as "Ext Comb /Electric Gen /Anthracite Coal /Pulverized Coal".