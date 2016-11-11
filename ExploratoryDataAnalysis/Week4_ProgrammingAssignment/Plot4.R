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
# How have emissions from coal combustion related sources changed in the US (1999 ~ 2008)?

# Step 1: Subset the data regarding 'coal combustion'.
# Browse thru data, and target the column 'Short.Name' in SCC.
Coal <- grep('[Cc]oal', SCC$Short.Name)         # Find words of coal.
Comb <- grep('[ -][Cc]omb', SCC$Short.Name)        # Find words START with comb.
CoalComb <- intersect(Coal, Comb)
CoalComb <- SCC$SCC[CoalComb]
dataCC <- subset(NEI, SCC %in% CoalComb)

# Step 2: Create a png file to write-in.
png('Plot4.png', width = 480, height = 480)

# Step 3: Plot the data:
aggr <- aggregate(Emissions ~ year, dataCC, sum)
g <- ggplot(aggr, aes(year, Emissions))
g + geom_line(col = 'blue', lwd = 2) +
        labs(x = 'Year', y = 'Total Emissions', title = 'Summary of Total PM2.5')

# Step 4: Close the device.
dev.off()
