if(!dir.exists('./Data_Storage')) dir.create('./Data_Storage')
setwd('./Data_Storage')
for(year in 1990:2016) {
        # Download and unzip file.
        filename <- paste0('annual_all_', year, '.csv')
        if(!file.exists(filename)) {
                Url <- paste0('https://aqsdr1.epa.gov/aqsweb/aqstmp/airdata/annual_all_',
                              year, '.zip')
                archivename <- paste0(year, '.zip')
                download.file(Url, destfile = archivename,
                              quiet = TRUE)
                unzip(archivename)
                unlink(archivename)
        }
}

# Initialize data list.
data.gallery <- list()
data.gallery <- sapply(1990:2016, function(year) {
        # Update progress indicator
        incProgress(1/27,
                    detail = paste('Reading data of', year))
        # Read file.
        filename <- paste0('annual_all_', year, '.csv')
        dat <- read.csv(filename)[, c(6,7,9,10,28)]
        # Create sub-list.
        sublist <- list()
        
        # SO2 subset.
        subdat <- dat[grep('Sulfur dioxide',
                           dat$Parameter.Name), ]
        subdat <- subdat[grep('24', subdat$Sample.Duration), ]
        # Re-form data with unique coordinates.
        reform <- aggregate(subdat$Arithmetic.Mean, 
                            by = list(lat = subdat$Latitude,
                                      lng = subdat$Longitude),
                            FUN = mean)
        delIdx <- which(reform$lat == 0)
        if(!(length(delIdx) == 0)) reform <- reform[-delIdx, ]
        sublist$SO2 <- reform
        
        # CO subset.
        subdat <- dat[grep('Carbon monoxide',
                           dat$Parameter.Name), ]
        subdat <- subdat[grep('8', subdat$Sample.Duration), ]
        reform <- aggregate(subdat$Arithmetic.Mean, 
                            by = list(lat = subdat$Latitude,
                                      lng = subdat$Longitude),
                            FUN = mean)
        delIdx <- which(reform$lat == 0)
        if(!(length(delIdx) == 0)) reform <- reform[-delIdx, ]
        sublist$CO <- reform
        
        # O3 subset.
        subdat <- dat[grep('Ozone', dat$Parameter.Name), ]
        subdat <- subdat[grep('8', subdat$Sample.Duration), ]
        reform <- aggregate(subdat$Arithmetic.Mean, 
                            by = list(lat = subdat$Latitude,
                                      lng = subdat$Longitude),
                            FUN = mean)
        delIdx <- which(reform$lat == 0)
        if(!(length(delIdx) == 0)) reform <- reform[-delIdx, ]
        sublist$O3 <- reform
        
        sublist
})
setwd('..')
unlink('Data_Storage')
# Save list in .RData file for further read.
save(data.gallery, file = 'DataGallery.RData')