# DSS Coursera.org
# Exploratory Data Analysis
# Week 4
# Programming Assignment


# Data source: EPA air pollution data - fine particle pollution.

# Unwrapping and loading data.
library(ggplot2)
unzip('exdata-data-NEI_data.zip')
# The below variables are used per instructed.
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Exploration of the raw data are not coded here.
# Instead please take a look at the CodeBook.md.

# Question to address: 
# Have total emissions from PM2.5 decreased in Baltimore City, Maryland, from 1999 to 2008?

# Step 1: Subset data from Baltimore City, and make sums splitted by year.
dataBC <- subset(NEI, fips == '24510')          # 24510 is fips code of Baltimore City, MD.
total <- tapply(dataBC$Emissions, as.factor(dataBC$year), sum)

# Step 2: Create a png file to write-in.
png('Plot2.png', width = 480, height = 480)

# Step 3: Plot the data:
with(dataBC, plot(unique(year), total, type = 'l', lwd = 4, col = 'blue',
               xlab = 'Year', ylab = 'Total Emissions',
               main = 'Total PM2.5 Emissions in Baltimore, MD (1999 ~ 2008)'))

# Step 4: Close the device.
dev.off()
