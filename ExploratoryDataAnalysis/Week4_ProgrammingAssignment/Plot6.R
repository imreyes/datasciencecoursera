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
# How have emissions from motor vehicles changed in Baltimore & Los Angeles (1999 ~ 2008)?

# Step 1: Subset the data regarding 'coal combustion'.
# Browse thru data, and target the column 'Short.Name' in SCC.
MV <- grep('[mM]otor', SCC$Short.Name)          # Find words of motor.
MV <- SCC$SCC[MV]                               # Get source code.
dataBLA <- subset(NEI, SCC %in% MV & fips %in% c('24510', '06037'))
dataBLA$County <- ifelse(dataBLA$fips == '24510', 'Baltimore', 'Los Angeles')

# Step 2: Create a png file to write-in.
png('Plot6.png', width = 960, height = 480)

# Step 3: Plot the data:
# As addressed above, small portion of high values drives the total pm2.5 level up.
# However, here we'll not consider removing these high values.

# Look at scatter plot first.
g1 <- ggplot(dataBLA, aes(year, log(Emissions + 1), color = County))
g1 <- g1 + geom_point() + facet_grid(. ~ County) + geom_smooth(method = 'lm', se = FALSE) + 
        labs(x = 'Year', y = 'log(Emissions + 1)', title = 'PM2.5 from Motor Vehicles in Baltimore & LA (1999 ~ 2008)') +
        theme(axis.text.x = element_text(angle = 45), legend.position = 'none')

# Looks pm2.5 in LA are very hign - and increasing!
# Then let's plot the sums.
aggr <- aggregate(Emissions ~ year + County, dataBLA, sum)
g2 <- ggplot(aggr, aes(year, Emissions, color = County))
g2 <- g2 + geom_line() +
        labs(x = 'Year', y = 'Total Emissions', title = 'Summary of Total PM2.5')
# Co-plot with gridExtra package:
cowplot::plot_grid(g1, g2, ncol = 2)

# Step 4: Close the device.
dev.off()