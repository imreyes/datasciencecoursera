# R - Programming
# Week 4 Programming Assignment Part I

## best() function
## find the best hospital in the designated cases (outcome)
## and in designated state (state).

best <- function(state, outcome) {
        
        
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
        subData <- dat[dat$State == state, c(2, outcomeInd)]    # Filter the entries of the specified state,
        subData <- subData[order(subData[, 1]), ]                 # only pick hospital names
        bestInd <- which.min(subData[, 2])                       # and the specified column.
        as.character(subData$Hospital.Name[bestInd])
}
