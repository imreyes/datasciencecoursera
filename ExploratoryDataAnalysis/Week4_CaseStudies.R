# DSS Coursera.org
# Exploratory Data Analysis
# Week 4
# Case Studies


# Data source: EPA air pollution data - fine particle pollution.


#===============================================================#
# Ask Questions: Is PM2.5 level in 2012 is better than in 1999?
#===============================================================#

# Look for data first.
# Data are downloaded from below link:
# http://aqsdr1.epa.gov/aqsweb/aqstmp/airdata/download_files.html#Annual
# Scroll down to find PM2.5 daily (code 88101).
# Manually download zip archives as 'daily_88101_1999.zip' and 'daily_88101_2012.zip'.

unzip('./data/daily_88101_1999.zip')
unzip('./data/daily_88101_2012.zip')

# Use proper software to browse through the data (preferred Excel).
# Several things I usually prefer to look at:
# 1) paragraphs or text chunks before header (need to trim off when reading);
# 2) NAs - scroll up and down, have an idea where I see NAs (or missing value);
# 3) lengths of each column - if not same, some samples are not completed, or columns are not related;
# 4) if there're columns with a single value - this is removable.
# ...

# The data looks pretty nice, and we can use read.csv() to load data.
dat1 <- read.csv('./data/daily_88101_1999.csv', stringsAsFactors = FALSE, na.strings = '')
dat2 <- read.csv('./data/daily_88101_2012.csv', stringsAsFactors = FALSE, na.strings = '')

# A quick note of function make.names()
# which takes strings not suitable for names
# and return good names.
# e.g.: 'Country Code' to 'Country.Code'.

# Playing around with data first.
# Target the PM2.5 data.

pm1 <- dat1$Arithmetic.Mean
pm2 <- dat2$Arithmetic.Mean

# There's no missing data here, which is oood for the case.
# However, would NAs matter?
# Good question... but it depends on what's the question.

# Let look at summaries to get a sense.
summary(pm1)
summary(pm2)

# Looks like, in general, 2012 has lower PM2.5 levels (average) than 1999.
# But 2012 also has much higher max values.
# Look at the boxplot now.
boxplot(pm1, pm2)
boxplot(log(pm1), log(pm2))     # pm2 skews much greater, and values are high.


# NOTE!! Why there are negative values in 2012?
# PM2.5 data gives concentration or count of PM2.5 particles in air,
# and thus cannot be negative anyhow.

summary(pm2)
mean(pm2 < 0)   # ~4% data are reported in negative values, nut much though.
# But we still want to know how it's produced.
# Look at the date these data are produced.
NegDates <- as.Date(dat2$Date.Local[pm2 < 0], '%Y-%m-%d')
hist(NegDates, 'month')         # 'month' gives a special break pattern.
# Looks like it's easier to get negative (wrong) data in winter and summer,
# which are relatively 'clean' time in a year. I don't know for sure though.
# But anyways, we will ignore the 0.4% problematic data for now.

# Now let's explore data!
# Look at data in one place.

site1 <- unique(subset(dat1, State.Code == 36, c(County.Code, Site.Num)))
site2 <- unique(subset(dat2, State.Code == 36, c(County.Code, Site.Num)))

# Glue the county code and site# together, and find the sites contained in both dataset.
site1 <- paste(site1$County.Code,site1$Site.Num, sep = '.')
site2 <- paste(site2$County.Code,site2$Site.Num, sep = '.')
both <- intersect(site1, site2)         # Only 11 in common of the two years.

# Now get back to the original dataset.
# To connect the common sites, we need to create a variable containing the same values.
dat1$Site <- paste(dat1$County.Code, dat1$Site.Num, sep = '.')
dat2$Site <- paste(dat2$County.Code, dat2$Site.Num, sep = '.')
NY1 <- subset(dat1, State.Code ==36 & Site %in% both)
NY2 <- subset(dat2, State.Code ==36 & Site %in% both)

# Take a look how many data obtained from each site.
sapply(split(NY1, NY1$Site), nrow)
sapply(split(NY2, NY2$Site), nrow)

# Now take a look at PM2.5 levels changing with time.
# Note: with 1 site, let's pick '67.1015'.
NY1sub <- NY1[NY1$Site == '67.1015', ]
NY2sub <- subset(NY2, Site =='67.1015')         # Note here, I showed 2 identical codes.

# Note the Date.Local are character values - we should change them back to Date.
NY1sub$Date.Local <- as.Date(NY1sub$Date.Local, '%Y-%m-%d')
NY2sub$Date.Local <- as.Date(NY2sub$Date.Local, '%Y-%m-%d')


# Now let's plot.
par(mfrow = c(1, 2))
# Define a common ylim.
LIM <- range(NY1sub$Arithmetic.Mean, NY2sub$Arithmetic.Mean, na.rm = TRUE)
plot(NY1sub$Date.Local, NY1sub$Arithmetic.Mean, ylim = LIM, pch = 19, col = 'red')
abline(h = median(NY1sub$Arithmetic.Mean), lty = 3, lwd = 3)
plot(NY2sub$Date.Local, NY2sub$Arithmetic.Mean, ylim = LIM, pch = 19, col = 'blue')
abline(h = median(NY1sub$Arithmetic.Mean), lty = 3, lwd = 3)

# So this implies (in the selected site in NY) PM2.5 levels in 2012 is lower on average,
# and the fluctuations, especially high spikes, are greately reduced.

# But what if we want to look at a bigger picture?
# Maybe we can take averages grouped by states,
# and match between the two datasets.
# Here we use tapply() to achieve this.
avg1 <- with(dat1, tapply(Arithmetic.Mean, State.Code, mean, na.rm = TRUE))
avg2 <- with(dat2, tapply(Arithmetic.Mean, State.Code, mean, na.rm = TRUE))

# Then we write the means along with the state into data.frames.
d1 <- data.frame(state = names(avg1), mean = avg1)
d2 <- data.frame(state = names(avg2), mean = avg2)
# And then merge.
dall <- merge(d1, d2, by = 'state')
names(dall) <- c('state', 'mean.1999', 'mean.2012')
par(mfrow = c(1, 1), mar = c(2, 2, 0, 0))
with(dall, plot(rep(1999,51), dall$mean.1999, xlim = c(1998, 2013)))
with(dall, points(rep(2012, 51), dall$mean.2012, xlim = c(1998, 2013)))

# Now let's connect between the data from the same state.
segments(rep(1999,51), dall$mean.1999, rep(2012, 51), dall$mean.2012)
# The majority of states decreased the PM2.5 levels, with a few exceptions.
# Look at these a few states:
States <- dall$state[dall$mean.1999 < dall$mean.2012]           # Get state codes.
unique(dat1$State.Name[dat1$State.Code %in% States])            # Extract names.
