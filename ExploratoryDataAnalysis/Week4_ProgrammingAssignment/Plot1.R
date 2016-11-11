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
# Have total emissions from PM2.5 decreased in the US from 1999 to 2008?

# Step 1: Make the total, splitted by year.
total <- tapply(NEI$Emissions, as.factor(NEI$year), sum)

# Step 2: Create a png file to write-in.
png('Plot1.png', width = 480, height = 480)

# Step 3: Plot the data:
with(NEI, plot(unique(year), total, type = 'l', lwd = 4, col = 'blue',
               xlab = 'Year', ylab = 'Total Emissions',
               main = 'Total PM2.5 Emissions in the US between 1999 and 2008'))

# Step 4: Close the device.
dev.off()
