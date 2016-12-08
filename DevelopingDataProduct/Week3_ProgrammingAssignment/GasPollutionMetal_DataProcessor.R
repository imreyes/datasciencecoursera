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
data.gallery.metal <- sapply(1990:2016, function(year) {
        # Read file.
        filename <- paste0('annual_all_', year, '.csv')
        dat <- read.csv(filename, stringsAsFactors = FALSE)[, c(9,10,28,51)]
        # Create sub-list.
        sublist <- list()
        
        # Ba subset.
        subdat <- dat[grep('Barium',
                           dat$Parameter.Name), ]
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
        sublist$Ba <- reform
        
        # Be subset.
        subdat <- dat[grep('Beryllium',
                           dat$Parameter.Name), ]
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
        sublist$Be <- reform
        
        # Cd subset.
        subdat <- dat[grep('Cadmium', dat$Parameter.Name), ]
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
        sublist$Cd <- reform
        
        # Ca subset.
        subdat <- dat[grep('Calcium', dat$Parameter.Name), ]
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
        sublist$Ca <- reform
        
        # Cr subset.
        subdat <- dat[grep('Chromium', dat$Parameter.Name), ]
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
        sublist$Cr <- reform
        
        # Cu subset.
        subdat <- dat[grep('Copper', dat$Parameter.Name), ]
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
        sublist$Cu <- reform
        
        # Fe subset.
        subdat <- dat[grep('Iron', dat$Parameter.Name), ]
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
        sublist$Fe <- reform
        
        # Pb subset.
        subdat <- dat[grep('Lead', dat$Parameter.Name), ]
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
        sublist$Pb <- reform
        
        # Mn subset.
        subdat <- dat[grep('Manganese', dat$Parameter.Name), ]
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
        sublist$Mn <- reform
        
        # Mo subset.
        subdat <- dat[grep('Molybdenum', dat$Parameter.Name), ]
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
        sublist$Mo <- reform
        
        # Ni subset.
        subdat <- dat[grep('Nickel', dat$Parameter.Name), ]
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
        sublist$Ni <- reform
        
        # V subset.
        subdat <- dat[grep('Vanadium', dat$Parameter.Name), ]
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
        sublist$V <- reform
        
        # Zn subset.
        subdat <- dat[grep('Zinc', dat$Parameter.Name), ]
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
        sublist$Zn <- reform
        
        sublist
})

setwd('..')
unlink('Data_Storage', recursive = TRUE)
# Save list in .RData file for further read.
save(data.gallery.metal, file = 'DataGalleryMetal.rda')
