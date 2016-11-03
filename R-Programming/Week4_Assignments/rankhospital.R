# R - Programming
# Week 4 Programming Assignment Part II

## rankhospital() function
## find the n th ranked (num) hospital in the designated cases (outcome)
## and state (state),. The num could be 'best' or 'worst'.

rankhospital <- function(state, outcome, num = 'best') {
        
        
        ## Read outcome data
        dat <- read.csv('outcome-of-care-measures.csv',
                        stringsAsFactors = FALSE)
        
        
        ## Check that state and outcome are valid
        if(!(state %in% dat$State)) {
                stop('invalid state')
        }
        # Internal definition of valid outcomes - unable to retrieve from original data.
        validOutcome <- c('heart attack' = 11, 'heart failure' = 17, 'pneumonia' = 23)
        if(!(outcome %in% names(validOutcome))) {
                stop('invalid outcome')
        }
        outcomeInd <- validOutcome[outcome]
        
        
        ## Return hospital name in that state with lowest 30-day death rate
        subData <- dat[dat$State == state, c(2, outcomeInd)]
        subData[, 2] <- as.numeric(subData[, 2])                # This gives an expected warning.
        subData <- subData[complete.cases(subData), ]
        subData <- subData[order(subData[, 2], subData[, 1]), ]
        if(is.character(num)) {
                if(num == 'best') num <- 1 else num <- dim(subData)[1]
        }
        subData[num, 1]
}
