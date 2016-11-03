# R - Programming
# Week 2 Programming Assignment

setwd("G:/R/Coursera")
unzip('rprog-data-specdata.zip')
directory<-'specdata'


# Function 1: Calculate and output means (without NAs) for assigned monitor index.

pollutantmean <- function(directory, pollutant='sulfate', id = 1:332) {
        
        # Retrieve sum and number of each file.
        means<-sapply(id, function(num) {
                # Specify data sources by file names, not id in files.
                dat <- read.csv(paste0(
                        getwd(), '/', 
                        directory, '/', 
                        formatC(num, width = 3, flag = '0'), 
                        '.csv'),)
                counts <- sum(!is.na(dat[[pollutant]]))
                sums <- sum(dat[[pollutant]], na.rm = TRUE)
                return(c(counts, sums))
        })
        
        # Make the final average.
        total <- rowSums(means)
        return(total[2] / total[1])
}


# Function 2: Calculate numbers of completed cases for assigned monitor index.

complete <- function(directory, id = 1:332) {
        
        # Initialize data frame to be returned.
        # I guessed it works as:
        # datf <- data.frame(id, nobs)
        # However it didn't work, perhaps due to the previous use of variable 'id'.
        datf <- data.frame()
        
        for(num in id) {
                
                # Specify data sources by file names, not id in files.
                dat <- read.csv(paste0(
                        getwd(), '/', 
                        directory, '/', 
                        formatC(num, width = 3, flag = '0'), 
                        '.csv'),)
                nobs <- sum(complete.cases(dat))
                datf <- rbind(datf, c(num, nobs))
        }
        
        names(datf) <- c('id', 'nobs')
        return(datf)
}


# Function 3: Calculate and output correlations between sulfate and nitrate
# above a threshold number of completed entries.

corr <- function(directory, threshold = 0) {
        
        # Filter data based on threshold.
        # For efficiency, the previous functions are not used.
        
        # Initialize the vector returned.
        correlations <- vector('numeric')
        
        for(num in 1:332) {
                
                # Specify data sources by file names, not id in files.
                dat <- read.csv(paste0(
                        getwd(), '/', 
                        directory, '/', 
                        formatC(num, width = 3, flag = '0'), 
                        '.csv'),)
                nobs <- sum(complete.cases(dat))
                if(nobs > threshold) {
                        complete.dat <- dat[complete.cases(dat),]
                        correlations <- c(correlations,
                                          cor(complete.dat[, 2], complete.dat[, 3]))
                }
        }
        return(correlations)
}
