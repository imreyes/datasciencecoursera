# DSS Coursera.org
# Getting and Cleaning Data
# Week4

#===============================================================#
# Editting Text Variables.
#===============================================================#

# Download and get dataset.
if(!file.exists('./data')) {dir.create('./data')}
Url <- 'https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accesType=DOWNLOAD'
download.file(Url, destfile = './data/cameras.csv')
cameraData <- read.csv('./data/cameras.csv')
names(cameraData)
# Into lower cases to prevent reading problems.
tolower(names(cameraData))
# strsplit() automatically splitting variable names.
# Output character list.
splitNames <- strsplit(names(cameraData), '\\.')
splitNames[[5]]
splitNames[[6]]

# Quick demo of list
mylist <- list(letters = c('A', 'b', 'c'), numbers = 1:3, matrix(1:25, ncol = 5))
head(mylist)
# Return a sublist with [].
mylist[1]
# return object of the sublist with [[]] or $.
mylist[[1]]
mylist$letters
# Get substructure of the sublist.
splitNames[[6]][1]

# sapply() to fix character vectors.
firstElement <- function(x) {x[1]}
sapply(splitNames, firstElement)

# Take the Peer Review datasets as examples.
if(!file.exists('./data')) {dir.create('./data')}
fileUrl1 <- 'https://dl.dropboxusercontent.com/u/7710864/data/reviews-apr29.csv'
fileUrl2 <- 'https://dl.dropboxusercontent.com/u/7710864/data/solutions-apr29.csv'
download.file(fileUrl1, destfile = './data/reviews.csv')
download.file(fileUrl2, destfile = './data/solutions.csv')
reviews <- read.csv('./data/reviews.csv')
solutions <- read.csv('./data/solutions.csv')

# We wish to clean up the names.
names(reviews)
sub('_', '', names(reviews),)
# Note sub() only match and replace 1st pattern.
testName <- 'this_is_a_test'
sub('_', '', testName)
# gsub() substitutes all.
gsub('_', '', testName)

# grep() family finds values or patterns.
# grep() returns indeces of matched values.
grep('Alameda', cameraData$intersection)
# Note grep() also works for numbers.
testNum <- c(12, 23, 356)
grep(3, testNum)
# Looks like it coerces number into charater before matching.
# use value = TRUE if want to return values instead of indeces.
grep('Alameda', cameraData$intersection, value = TRUE)
# grepl() returns a logical vector for each entry - match (T) or not match (F).
table(grepl('Alameda', cameraData$intersection))
# Subset data.
cameraData2 <- cameraData[!grepl('Alameda', cameraData$intersection), ]


# Other useful string functions.
library(stringr)
# Compare with python - looks useful when dealing with strings.
nchar('Guang Yang')             # len()
substr('Guang Yang', 1, 6)      # Here 6th character is included.
paste('Guang', 'Yang')          # Default sep = ' '.
paste0('Guang', 'Yang')         # sep = '', always.
# Clear off spaces on left or right. strtrim() trims required length.
str_trim('GuangYang        ')


#===============================================================#
# Regular Expressions.
#===============================================================#

# ^i think - matches lines start with 'i think...'.
# morning$ - matches lines end wiht '...morning'.
# [Bb][Uu][Ss][Hh] - matches patterns of 'BUSH', 'bush', 'Bush', 'bUsH', ...
# Combinations:
# ^[Ii] am - matches lines start with 'I am...' or 'i am...'.
# ^[0-9][a-zA-Z] - matches lines start with '0a..', '7T...', etc.
# [^?.]$ - matches lines NOT end with '?' or '.'
# 9.11 - matches patterns like '9-11', '9:11', 9511', '9.11', etc..
# fire|flood - matches patterns of 'fire' OR 'flood'.
# Combinations:
# ^[Gg]ood|[Bb]ad - matches lines start with 'Good...', 'good...',
## OR JUST CONTAINING 'Bad', or 'bad'.
# ^([Gg]ood|[Bb]ad) - start with anything inside the parenthesis.
# [Gg]eorge( [Ww]\.)? [Bb]ush - note spaces are important.
# * repeats any pattern right before it any times (include 0).
# + like * but at least 1.
# (.*) - matches all parentheses ?? how do we know () and . are literal or meta character?
# [Bb]ush( +[^ ]+ +){1,5} debate - matches 'bush' and 'debate' with 1~5 words in between.
# {m,n} - m <= match times <= n
# {m}   - m = match times
# {m,}  - m <= match times
# ([a-zA-Z]+) +\1 + - here \1 means replicate patterns in parenthesis 1 more time.
# * is greedy, and matching the longest string.
# *? makes it not greedy.

# Review materials from python project Calculator.py.

#===============================================================#
# Working with Dates.
#===============================================================#

# Simple date() function returns current time as string.
d1 <- date()
d1
class(d1)       # 'character'

# Sys.Data() makes Date object, but with no time.
d2 <- Sys.Date()
d2
class(d2)       # 'Date'

# format() formats the dates.
# %d as number (0~31), %a as abbr. weekdays (Mon.~Sun.)
# %A as weekdays (Monday~Sunday), %m as month (00-12),
# %b as abbr. month (Jan.~Dec.), %B month (January~December)
# %y as 2 digit year, %Y as 4 digit year.
format(d2, '%a %b %d')

# as.Date() creates date from scratch, in batches
# Note the string-wise months are case-insensitive.
x <- c('1jan1960', '2jan1960', '31mar1960', '30Jul1961')
z <- as.Date(x, '%d%b%Y')
z
dz <- z[1] - z[2]       # class(dz) is 'difftime'.
as.numeric(dz)          # Convert to numeric form - in days.

# Converts in different formats
weekdays(d2)
months(z)
julian(d2)              # How many days after 1970-01-01

# package Lubridate.
library(lubridate)
# A set of functions reads in various y, m, d orders.
# Each gets one order into date format.
ymd('20140108')
ymd('140108')
mdy('08/04/2013')
dmy('03-04-2013')
# Note it's impossible to parse '01-02/03', as it's not a conventional way.
# Nor do dym() or myd() exist - not conventional way!
# That is not a good case - don't attempt bad format ever!

# Also deals with time.
ymd_hms('2011-08-03 10:15:03')
# Could also change time zone.
mdy_hms('08032011 10-15-03', tz = 'Pacific/Auckland')
hms('03:22:14')         # Note how it works with only hms.

# Some functions have slightly different syntax.
x <- dmy(c('1jan2013', '2jan2913', '31mar2013', '30-jul-2013'))
# Note it takes different notation methods.
wday(x[1])                      # Weekdays by wday()
weekdays(x[1])                  # Compare to weekdays()
wday(x[1], label = TRUE)



#===============================================================#
# Data Resources.
#===============================================================#

# To name some:

# Government sites.
# Gapminder.
# Survey Data from US.
# Infochimps Marketplaces.
# Kaggle.

# More info in the video.

# Potential interesting API:
# Google maps - RGoogleMaps.



#===============================================================#
# Practice & Quizzes
#===============================================================#

# First note - always try swirl() class when not knowing what to do.

# Quiz 1

# Getting data.
Url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv'
# Code book address:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
download.file(Url, destfile = './data/ACS_Housing_Idaho2.csv')
dat <- read.csv('./data/ACS_Housing_Idaho2.csv')
strpNames <- strsplit(names(dat), 'wgtp')
strpNames[[123]]


# Quiz 2 & 3
# The data has already been downloaded.
# Look at Week3 quizzes for reference.
dat <- read.csv('./data/GDP_ranking.csv', skip = 4, nrows = 190)[, c(1,2,4,5)]
names(dat) <- c("CountryCode", "Rank", "Economy", "Total")
for(i in seq_along(dat$CountryCode)) {if(dat$CountryCode[i] == '') dat$CountryCode[i] <- NA}
dat <- dat[complete.cases(dat), ]

# Remove ',' and make data numeric.
dat$Total <- as.numeric(gsub(',', '', dat$Total))
mean(dat$Total)

# Search for countries start with 'United'.
countryNames <- as.character(dat$Economy)
countryNames <- dat$Economy                     # character factor also works.
grep('^United', countryNames)


# Quiz 4
# The data has already been downloaded.
# Look at Week3 quizzes for reference.
dat2 <- read.csv('./data/Ed_stats.csv')
mergedDat <- merge(dat, dat2, by = 'CountryCode')

# Look for countries with fiscal year ends at June.
# This is in 'special.Notes
sum(mergedDat$Special.Notes != '')              # Not many data available.
grep('[Ff]iscal year end: [Jj]une', mergedDat$Special.Notes)


# Quiz 5
library(quantmod)
# Get data. sampleTimes gets times values were collected.
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)
# Number of values collected in 2012.
sum(year(sampleTimes) == 2012)
# Number of values collected in Mondays of 2012
sum(year(sampleTimes) == 2012 & wday(sampleTimes) == 2) # 2 for Mundays.
