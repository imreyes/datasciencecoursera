# R - Programming
# Week 4 Programming Assignment Part III

## rankall() function
## find the n th ranked (num) hospital in the designated cases (outcome)
## of ALL STATES. The num could be 'best' or 'worst'.

rankall <- function(outcome, num = 'best') {
        
        
        ## Read outcome data
        dat <- read.csv('outcome-of-care-measures.csv',
                        stringsAsFactors = FALSE)
        
        
        # Internal definition of valid outcomes - unable to retrieve from original data.
        validOutcome <- c('heart attack' = 11, 'heart failure' = 17, 'pneumonia' = 23)
        if(!(outcome %in% names(validOutcome))) {
                stop('invalid outcome')
        }
        outcomeInd <- validOutcome[outcome]
        
        
        ## Return hospital name in that state with lowest 30-day death rate
        # First reduce data volumn - hospital (1), state (2), death rate (3)
        dat <- dat[, c(2, 7, outcomeInd)]
        dat[, 3] <- as.numeric(dat[, 3])
        dat <- dat[complete.cases(dat[, 3]),]
        if(num == 'best') num <- 1
        dec <- FALSE
        if(num == 'worst') {            # Inefficient to switch 'worst' to number.
                num <- 1                # instead switch to 'descending order' later.
                dec <- TRUE
        }
        # a dataframe coerces its columns to factors, which creates problems.
        # So the data are firstly input to matrix, then convert to dataframe.
        hslist <- matrix('character')
        hslist <- sapply(sort(unique(dat[, 2])), function(state) {
                subData <- dat[dat[, 2] == state, ]
                subData <- subData[order(subData[, 3], subData[, 1],
                                         decreasing = dec), ]
                c(subData[num,1], state)
        })
        hslist <- as.data.frame(t(hslist))
        names(hslist) <- c('hospital', 'state')
        hslist
}
