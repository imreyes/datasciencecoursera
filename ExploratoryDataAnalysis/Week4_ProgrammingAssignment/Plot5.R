# DSS Coursera.org
# Exploratory Data Analysis
# Week 4
# Programming Assignment


# Data source: EPA air pollution data - fine particle pollution.

# Unwrapping and loading data.
unzip('exdata-data-NEI_data.zip')
# The below variables are used per instructed.
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Exploration of the raw data are not coded here.
# Instead please take a look at the CodeBook.md.

# Question to address: 
# How have emissions from motor vehicles changed in Baltimore (1999 ~ 2008)?

# Step 1: Subset the data regarding 'coal combustion'.
# Browse thru data, and target the column 'Short.Name' in SCC.
MV <- grep('[mM]otor', SCC$Short.Name)          # Find words of motor.
MV <- SCC$SCC[MV]                               # Get source code.
dataMV <- subset(NEI, SCC %in% MV & fips == '24510')

# Step 2: Create a png file to write-in.
png('Plot5.png', width = 960, height = 960)

# Step 3: Plot the data:
# First look at the distribution, without summing up.
g1 <- ggplot(dataMV, aes(year, Emissions))
g1 <- g1 + geom_point(size = 4) +
        labs(x = 'Year', y = 'Emissions', title = 'PM2.5 by Motor Vehicles in Baltimore (1999 ~ 2008)')

# Note there are 2 distinct 'outliers' - way too high compared to others.
# While we can't remove them, we want to look at the features of the rest points.
g2 <- ggplot(dataMV[dataMV$Emissions<5, ], aes(year, Emissions))          # Note 5 is arbitrary - any lines between 0.2~10 works!
g2 <- g2 + geom_point(size = 4) + labs(x = 'Year', y = 'Emissions',
                               title = "Removing 'Outliers'")

# Now, let's look at the sum plots with and without the big numbers.
aggr <- aggregate(Emissions ~ year, dataMV, sum)
g1s <- ggplot(aggr, aes(year, Emissions))
g1s <- g1s + geom_line(col = 'blue', lwd = 2) +
        labs(x = 'Year', y = 'Total Emissions', title = 'Summary of Annual Sums')

aggr2 <- aggregate(Emissions ~ year, dataMV[dataMV$Emissions < 5, ], sum)
g2s <- ggplot(aggr2, aes(year, Emissions))
g2s <- g2s + geom_line(col = 'blue', lwd = 2) +
        labs(x = 'Year', y = 'Total Emissions', title = "Summary of Annual Sums without 'Outliers'")

# Co-plot with gridExtra package:
cowplot::plot_grid(g1, g1s, g2, g2s, ncol = 2, nrow = 2)

# Step 4: Close the device.
dev.off()
