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
# Which type (point, nonpoint, onroad, nonroad) have decreased in emissions in Baltimore, MD?
# Which have increased?

# Step 1: Subset data from Baltimore City, and make sums splitted by year and type.
dataBC <- subset(NEI, fips == '24510')          # 24510 is fips code of Baltimore City, MD.
total <- sapply(unique(dataBC$type), function(i) {
        tapply(dataBC$Emissions[dataBC$type == i], as.factor(dataBC$year[dataBC$type == i]), sum)
})

# Step 2: Create a png file to write-in.
png('Plot3.png', width = 960, height = 480)

# Step 3: Plot the data:
# There are 2 ways to plot, which gives slightly different visual effects.

# BY AVERAGE (fitting the distributed points):
# As the emission data are well dispersed, we'll plot log(emission + 1).
g1 <- ggplot(dataBC, aes(year, log(Emissions + 1), color = type))
g1 <- g1 + geom_point() + facet_grid(. ~ type) + geom_smooth(method = 'lm', se = FALSE) + 
        labs(x = 'Year', y = 'log(Emissions + 1)', title = 'PM2.5 from Multiple Sources in Baltimore, MD (1999 ~ 2008)') +
        theme(axis.text.x = element_text(angle = 45), legend.position = 'none')
# BY SUM:
aggr <- aggregate(Emissions ~ year + type, dataBC, sum)
g2 <- ggplot(aggr, aes(year, Emissions, color = type))
g2  <- g2 + geom_line() +
        labs(x = 'Year', y = 'Total Emissions', title = 'Summary of Total PM2.5')
# Co-plot with gridExtra package:
cowplot::plot_grid(g1, g2, ncol = 2)
# Step 4: Close the device.
dev.off()
