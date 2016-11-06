# DSS Coursera.org
# Getting and Cleaning Data
# Week3

#===============================================================#
# Subsetting and sorting.
#===============================================================#

set.seed(13435)
X <- data.frame('var1' = sample(1:5),
                'var2' = sample(6:10),
                'var3' = sample(11:15))
X <- X[sample(1:5),]; X$var2[c(1,3)] = NA
X[, 1]
X[, 'var1']
X[1:2, 'var2']
X[(X$var1 <= 3 & X$var3 > 11), ]
X[(X$var1 <= 3 | X$var3 > 15), ]
X[which(X$var2 > 8), ]
X[X$var2 > 8, ]         # Note without which() the NAs are returned.

# sort() only functions on one vector.
sort(X$var1)
sort(X$var1, decreasing = TRUE)
sort(X$var2, na.last = TRUE)

# order() returns indeces in order of contents; can take more than 1 column.
X[order(X$var1), ]
X[order(X$var1, X$var3), ]

# Note: neither sort() or order() affects the original object directly.
# arrange() in plyr package works similar with order(),
# but return values not indeces.
library(plyr)
arrange(X, var1)
arrange(X, desc(var1))

# Add vector to a data frame.
X$var4 <- rnorm(5)
# Or by cbind()
Y <- cbind(X, 'var5' = rnorm(5)) # if no names (keys) given, 'rnorm(5)' is the name.

#===================================================================================#
# Summarizing Data
#===================================================================================#

# An example of restaurants in Baltimore City.
if(!file.exists('./data')) {dir.create('./data')}
Url <- 'https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD'
download.file(Url, destfile = './data/restaurants.csv')
restData <- read.csv('./data/restaurants.csv')

# First look at the data in a ballpark.
head(restData, n = 3)
tail(restData, n = 3)
summary(restData)
str(restData)
quantile(restData$councilDistrict, na.rm = TRUE)
quantile(restData$councilDistrict, probs = c(0.5, 0.75, 0.9))
# Table relationships and data distribution.
table(restData$zipCode, useNA = 'ifany')        # show missing values by useNA.
table(restData$councilDistrict, restData$zipCode)
# Check NAs.
sum(is.na(restData$councilDistrict))
any(is.na(restData$councilDistrict))
all(restData$zipCode > 0)       # Note something is wrong in zipcodes.
colSums(is.na(restData))
all(colSums(is.na(restData)) == 0)
# Check zipcodes.
table(restData$zipCode %in% c('21212'))
table(restData$zipCode %in% c('21212', '21213'))
restData[restData$zipCode %in% c('21212', '21213'), ]

# Cross tabs - new dataset used.
# First look at data.
# Note it's same dataset example for 'batch effect'.
data("UCBAdmissions")
DF <- as.data.frame(UCBAdmissions)
summary(DF)

xt <- xtabs(Freq ~ Gender + Admit, data = DF)

# Cross tabs - another dataset.
warpbreaks$replicate <- rep(1:9, len = 54)
xt <- xtabs(breaks ~ ., data = warpbreaks)
ftable(xt)

# Size of a dataset.
fakeData <- rnorm(1e5)
object.size(fakeData)   # Look at size.
print(object.size(fakeData), units = 'Mb')      # units used in print().


#=============================================================================#
# Create new variables
#=============================================================================#

# An example of restaurants in Baltimore City.
if(!file.exists('./data')) {dir.create('./data')}
Url <- 'https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD'
download.file(Url, destfile = './data/restaurants.csv')
restData <- read.csv('./data/restaurants.csv')

# Creating simple variables.
s1 <- seq(1, 10, by = 2)
s2 <- seq(1, 10, length = 3)
x <- c(1, 3, 8, 25, 100)
seq(along = x)  # equals 1:length(x)

# Creating variables in dataframe.
restData$nearMe <- restData$neighborhood %in% c('Roland Park', 'Homeland')
table(restData$nearMe)

restData$zipWrong <- ifelse(restData$zipCode < 0, TRUE, FALSE)
table(restData$zipWrong, restData$zipCode < 0)

# Group out by zipCodes.
restData$zipGroups <- cut(restData$zipCode, breaks = quantile(restData$zipCode))
table(restData$zipGroups, restData$zipCode)
# Note we use cut() to separate consecutive values into range factors.
# An easier way to cut:
library(Hmisc)
restData$zipGroups <- cut2(restData$zipCode, g = 4)     # Cut into 4 groups by quntile.
table(restData$zipGroups)

# Create factor variables.
restData$zcf <- factor(restData$zipCode)
restData$zcf[1:10]

# Levels of factor.
yesno <- sample(c('yes', 'no'), size = 10, replace = TRUE)
yesnofac <- factor(yesno, levels = c('yes', 'no'))
relevel(yesnofac, ref = 'no')           # Use ref as base (intercept).
as.numeric(yesnofac)


# Using mutate function - create new columns or replace columns with 'better' data.
library(Hmisc)
restData2 <- mutate(restData, zipGroups = cut2(zipCode, g = 4))
table(restData2$zipGroups)



#==========================================================================================#
# Reshaping Data
#==========================================================================================#


library(reshape2)
head(mtcars)
mtcars$carname <- rownames(mtcars)

# melt() list all variables in id, and list values of measure.vars row-wise, separately
# Note dim(mtcars) is 32*12, and dim(carMelt) is 64 * 5
# 64 -- 32 * length(measure.vars)
# 5  -- length(id) + length(measure.vars)
carMelt <- melt(mtcars, id = c('carname', 'gear', 'cyl'), measure.vars = c('mpg', 'hp'))

# dcast() puts object from melt(), and list y ~ variable.
# y is one of id in melt() object, variable are NUNBERS of variables of measure.vars.
cylData <- dcast(carMelt, cyl ~ variable)
# Applying a function behind will replace counts.
cylData <- dcast(carMelt, cyl ~ variable, mean)


# Another data
head(InsectSprays)
# Making average summary using tapply()
tapply(InsectSprays$count, InsectSprays$spray, sum)     # Return array

# Same job, but using split() and lapply().
spIns <- split(InsectSprays$count, InsectSprays$spray)
sprCount <- lapply(spIns, sum)                          # Return list
sprCount <- unlist(sprCount)                            # Get object back to array
sprCount <- sapply(spIns, sum)                          # sapply() gives array.

# And same job another way.
library(plyr)
# Seems not work - seek for solutions when wish to use.
ddply(InsectSprays, .(spray), summarize, sum = sum(count))
spraySums <- ddply(InsectSprays, .(spray), summarize, sum = ave(count, FUN = sum))



#==============================================================================================#
# dplyr package - managing data frames
#==============================================================================================#

library(dplyr)
# Usually, all functions in dplyr start with argument of dataframe object in the 1st place.
# After the dataframe object, don't have to use the object$ again, just names.
# Return dataframe object as well, with manipulation requested.

# Let's use an example from online.
options(width = 105)
chicago <- readRDS('chicago.rds')

# select() selects variables (names) as column indeces.
head(select(chicago, city:dptp))
head(select(chicago, -(city:dptp)))   # Any columns other than city : dptp.
# Above single command equals to below 3:
i <- match('city', names(chicago))
j <- match('dptp', names(chicago))
head(chicago[, -(i:j)])

# filter() selects ROWS that meet the given criteria.
chic.f <- filter(chicago, pm25tmean2 > 30)
head(chic.f, 10)
chic.f <- filter(chicago, pm25tmean2 > 30 & tmpd > 80)
head(chic.f, 10)

# arrange() reorder rows of dataframe.
chicago <- arrange(chicago, date)
head(chicago)
tail(chicago)
chicago <- arrange(chicago, desc(date))

# rename() changes the names of dataframe you wish.
# Note the new name is given on the left as argument key,
# and old names are values.
chicago <- rename(chicago, pm25 = pm25tmean2, dewpoint = dptp)

# mutate() creates new variable (column) based on other variables.
chicago <- mutate(chicago, pm25detrend = pm25 - mean(pm25, na.rm = TRUE))
head(select(chicago, pm25, pm25detrend))

# group_by() splits rows by a factor variable.
# First create a factor in dataframe
chicago <- mutate(chicago, tempcat = factor(1 * (tmpd > 80), labels = c('cold', 'hot')))
# Then group by the factor (note, 2 defined levels 'hot', 'cold', and a NA level).
hotcold <- group_by(chicago, tempcat)
hotcold

# summarize() provides small dataframe tabs some variables you name, by methods required:
# summarize(group_by(dataframe, factor), var1 = FUN1(), var2 = FUN2(), ...)
# Results:
#                       var1                            var2                    ...
# factor_level1         FUN1(var1[level1])          FUN2(var2[level1])          ...
# factor_level2         FUN1(var1[level2])          FUN2(var2[level2])          ...
# ...                   ...                             ...                     ...
summarize(hotcold, pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))

# Now let's play around with years.
# Make a table showing mean pm25, max ozone and median NO2 data of each year.
chicago <- mutate(chicago, year = as.POSIXlt(date)$year + 1900)
years <- group_by(chicago, year)
summarize(years, pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))

# Introduce the pipeline operator %>% of dplyr.
# This allows one-command generation of multiple operations.
chicago %>% mutate(month = as.POSIXlt(date)$mon + 1) %>%
        group_by(month) %>%
        summarize(pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))
# Note withthis pipelined command, the mutate() doesn't apply itself on dataset
names(chicago)
chicago <- mutate(chicago, month = as.POSIXlt(date)$mon + 1)
names(chicago)          # Now it's added.



#===============================================================================================================#
# Merging data
#===============================================================================================================#

# Download and read-in data.
if(!file.exists('./data')) {dir.create('./data')}
fileUrl1 <- 'https://dl.dropboxusercontent.com/u/7710864/data/reviews-apr29.csv'
fileUrl2 <- 'https://dl.dropboxusercontent.com/u/7710864/data/solutions-apr29.csv'
download.file(fileUrl1, destfile = './data/reviews.csv')
download.file(fileUrl2, destfile = './data/solutions.csv')
reviews <- read.csv('./data/reviews.csv')
solutions <- read.csv('./data/solutions.csv')
head(reviews, 2)
head(solutions, 2)

# merge() merges data frames.
# Important parameters: x, y, by, by.x, by.y, all
names(reviews)
names(solutions)
mergedData <- merge(x = reviews, y = solutions, by.x = 'solution_id', by.y = 'id', all = TRUE)
head(mergedData)

# Default - merge all columns with same names.
# Find common names.
intersect(names(solutions), names(reviews))
mergedData2 <- merge(reviews, solutions, all = TRUE)
head(mergedData2)
# Note this doesn't 'compress' entries, but increase the row numbers.
# This creates a lot of NAs where columns in x don't apply in y.

# Use join() in plyr package.
# Faster, but less full featured - defaults to left join.
df1 <- data.frame(id = sample(1:10), x = rnorm(10))
df2 <- data.frame(id = sample(1:10), y = rnorm(10))
# join() finds the common variable, and then merge two dataframes based on it.
# arrange() sorts the rows by id.
arrange(plyr::join(df1, df2), id)

# join_all() in plyr recursively join more than 1 dataframes (in one list object).
df3 <- data.frame(id = sample(1:10), z = rnorm(10))
dfList = list(df1, df2, df3)
plyr::join_all(dfList)



#=========================================================================================#
# Practice & Quiz
#=========================================================================================#

# Quiz 1
Url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv'
download.file(Url, destfile = './data/ACS_Housing_Idaho.csv')
dat <- read.csv('./data/ACS_Housing_Idaho.csv')

# Browse through the data first.
# Also refer to the code book:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
dim(dat)        # Big file.
unique(dat$ST)  # Only 1 state coded '16' - which is Idaho by code book.
unique(dat$ACR) # We'll look for '3' - over 10 acres by code book.
unique(dat$AGS) # '6' for > $10000 products.

# So we'll create a logical vector.
agricultureLogical <- ifelse(dat$ACR =='3' & dat$AGS == '6', TRUE, FALSE)
which(agricultureLogical)[1:3]


# Quiz 2
# Download and read-in data.
library(jpeg)
Url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg'
# Note mode = 'wb' is crucial - write binary.
download.file(Url, destfile = './data/Jeff.jpg', mode = 'wb')
dat <- readJPEG('./data/Jeff.jpg', native = TRUE)

# Process data.
summary(dat)
quantile(dat, probs = c(0.3, 0.8))
# The answer seems not to match any options.


# Quiz 3 ~ 5
# Download and read-in data.
Url1 <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv'
Url2 <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv'
download.file(Url1, destfile = './data/GDP_ranking.csv')
download.file(Url2, destfile = './data/Ed_stats.csv')

# Take a look at the files - the GDP file doesn't look good for direct reading.
# Rip off the 1st 4 rows, and manually add names.
GDPr <- read.csv('./data/GDP_ranking.csv', skip = 4)
# Note there are still many empty entries - only 1,2,4,5 are useful.
GDPr <- GDPr[, c(1, 2, 4, 5)]
# Then manually rename the data.
names(GDPr) <- c("CountryCode", "Rank", "Economy", "Total")
# Check completeness of data - note empty cells != NA.
# Replace '' with NA.
for(i in seq_along(GDPr$CountryCode)) {if(GDPr$CountryCode[i] == '') GDPr$CountryCode[i] <- NA}
mean(complete.cases(GDPr))
GDPr <- GDPr[complete.cases(GDPr), ]

# Note: above results in 229 countries - but we only look at 190 in the quiz.
GDPr <- read.csv('./data/GDP_ranking.csv', skip = 4, nrows = 190)[, c(1, 2, 4, 5)]
names(GDPr) <- c("CountryCode", "Rank", "Economy", "Total")

EDs <- read.csv('./data/Ed_stats.csv')

# Merge data.
mergeDat <- merge(GDPr, EDs, by = 'CountryCode')
nrow(mergeDat)  # See how many matches.
# Sort the data with GDP rank.
sortDat <- arrange(mergeDat, desc(Rank))
sortDat$Long.Name[13]

# Summarize data.
sortDat %>% group_by(Income.Group) %>% summarize(Rank = mean(Rank))
# Can also done by tapply().
tapply(sortDat$Rank, sortDat$Income.Group, mean)

# Make a table.
sortDat <- mutate(sortDat, Rank.Group = cut(Rank, breaks = 5))  # Use breaks instead of quantile(Rank, seq(0, 1, 1/5))
table(sortDat$Rank.Group, sortDat$Income.Group)
