library(plyr)
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
data.gallery.metal <- list()
# Create chemical list.
chemicals <- c('Barium', 'Beryllium', 'Cadmium', 'Calcium', 'Chromium', 'Copper',
               'Iron', 'Lead', 'Manganese', 'Molybdenum', 'Nickel', 'Vanadium', 'Zinc')

data.gallery.metal <- sapply(1990:2016, function(year) {
        # Read file.
        filename <- paste0('annual_all_', year, '.csv')
        state.abb[51:55] <- c('PR', 'DC', 'GU', 'VI', 'MX')
        state.name[51:55] <- c('Puerto Rico', 'District Of Columbia', 'Guam',
                               'Virgin Islands', 'Country Of Mexico')
        dat <- read.csv(filename, stringsAsFactors = FALSE)[, c(9,10,28,51)]

        # Create sub-list.
        sublist <- sapply(chemicals, function(elem) {
                subdat <- dat[grep(elem, dat$Parameter.Name), ]
                # Re-form data with unique coordinates.
                reform1 <- aggregate(subdat$Arithmetic.Mean, 
                                     by = list(State = subdat$State.Name),
                                     FUN = function(i) ifelse(mean(i) != 0, mean(i), NA))
                reform2 <- aggregate(subdat$Arithmetic.Mean, 
                                     by = list(State = subdat$State.Name),
                                     FUN = function(i) ifelse(mean(i) != 0, sum(i)/mean(i), 0))
                reform <- merge(reform1, reform2, by = 'State')
                names(reform) <- c('State', 'Mean', 'Num.Monitors')
                reform$hover <- with(reform, paste(State, '<br>', 'Mean:', Mean,
                                                   '<br>', '# of Sites:', Num.Monitors))
                reform$State <- sapply(reform$State, function(i) {
                        ifelse(i == 'Virginia', 'VA', state.abb[grep(i, state.name)])
                })
                reform
        })

        sublist
})

setwd('..')
unlink('Data_Storage', recursive = TRUE)
# Save list in .RData file for further read.
save(data.gallery.metal, file = 'DataGalleryMetal.rda')
