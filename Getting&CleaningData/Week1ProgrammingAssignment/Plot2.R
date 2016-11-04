# Data Science Specialization - Coursera.org
# 4. Exploratory Data Analysls
# Week 1 Programming Assignment

#============================================================#
# Load and clean data.
#============================================================#

unzip('exdata-data-household_power_consumption.zip')

# A huge dataset - we only pick data between 2007-02-01 and 2007-02-02.
# Note the date format is 'd/m/yyyy'.
startline <- grep('1/2/2007', readLines('household_power_consumption.txt'))[1]
endline <- grep('3/2/2007',readLines('household_power_consumption.txt'))[1]

# ?? Question: How do we grep() only the 1st match? ... Above is time consuming.

nrow <- endline - startline + 1         # Accept 1 entry from 2007-02-03.

# Take a look at data - it's separated by ';'
dat <- read.table('household_power_consumption.txt',
                  skip = startline - 1, 
                  nrows = nrow, sep = ';')
names(dat) <- as.vector(read.table('household_power_consumption.txt',
                                   nrows = 1, sep = ';',
                                   stringsAsFactors = FALSE,
                                   na.strings = '?'))

# Reformat time.
dat$Date <- as.Date(dat$Date, format = '%d/%m/%Y')
timeline <- as.POSIXct(paste(dat$Date, dat$Time))


#============================================================#
# Plot and export graph.
#============================================================#

# Plot 2
plot(timeline, dat$Global_active_power, type = 'l',
     ylab = 'Global Active Power (kilowatts)', xlab = '')

# Copy to png
dev.copy(png, 'Plot2.png', height = 480, width = 480)
dev.off()
