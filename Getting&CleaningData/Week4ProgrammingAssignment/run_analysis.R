# DSS Coursera.org
# Getting and Cleaning Data
# Week4 Programming Assignment

# This script serves to get data files from a .zip folder, 
# select the desired data entries (measurements on mean and
# standard deviation), and merge the training and testing
# datasets together, with properly reformated variable names.

# The work starts and ends at current working directory,
# where all files, including the final 'tidy.txt' output,
# stored in './data/' folder.


# Download and unzip files.

Url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if(!file.exists('./data')) {dir.create('./data')}
setwd('./data')

if(!file.exists('SamsungGalaxy5.zip')) {download.file(Url, destfile = './data/SamSungGalaxy5.zip')}
if(!file.exists('UCI HAR Dataset')) {unzip('./data/SamSungGalaxy5.zip')}
setwd('./UCI HAR Dataset')

# Read-in activity labels.
ActivityLabels <- read.table('activity_labels.txt', stringsAsFactors = FALSE)
# Rename the labels.
ActivityLabels[, 2] <- tolower(ActivityLabels[, 2])
ActivityLabels[, 2] <- gsub('_u', 'U', ActivityLabels[, 2])
ActivityLabels[, 2] <- gsub('_d', 'D', ActivityLabels[, 2])
ActivityLabels[, 2] <- Hmisc::capitalize(ActivityLabels[, 2])

# Read-in features.
Features <- read.table('features.txt', stringsAsFactors = FALSE)

# Find feature wanted, which are means and standard deviations.
#=======================================================#
#  Note meanFreq() are excluded                         #
#  I think it's a different function other than mean(). #
#  To add meanFreq(), simply remove '\\(' from RegEx.   #
#=======================================================#
TargetFeatures <- grep('mean\\(|std', Features[,2])
# Name the selected features, as output variable names.
FeatureNames <- Features[TargetFeatures,2]
FeatureNames <- gsub('-m', 'M', FeatureNames)
FeatureNames <- gsub('-s', 'S', FeatureNames)
FeatureNames <- gsub('[()-]', '', FeatureNames)

# Read-in train data, label and subject; bind the data with cards.
TrainSet <- read.table('./train/X_train.txt', stringsAsFactors = FALSE)[, TargetFeatures]
TrainLabel <- read.table('./train/y_train.txt', stringsAsFactors = FALSE)
TrainSubject <- read.table('./train/subject_train.txt', stringsAsFactors = FALSE)
TrainData <- cbind(TrainSubject, TrainLabel, TrainSet)

# Read-in test data, label and subject; bind the data with cards.
TestSet <- read.table('./test/X_test.txt', stringsAsFactors = FALSE)[, TargetFeatures]
TestLabel <- read.table('./test/y_test.txt', stringsAsFactors = FALSE)
TestSubject <- read.table('./test/subject_test.txt', stringsAsFactors = FALSE)
TestData <- cbind(TestSubject, TestLabel, TestSet)

# Merge two datasets, and give proper discriptive name for each variable.
TotalData <- rbind(TrainData, TestData)
names(TotalData) <- c('Subject', 'Activity', FeatureNames)

# Factorize the activity labels and subject.
TotalData$Activity <- factor(TotalData$Activity, levels = ActivityLabels[, 1],
                             labels = ActivityLabels[, 2])
TotalData$Subject <- factor(TotalData$Subject)

# Make averages of each volunteer and each activity, on all variables.
MeltData <- reshape2::melt(TotalData, id = c('Activity', 'Subject'))
MeanData <- reshape2::dcast(MeltData, Activity + Subject ~ variable, mean)

# Write data into 'tidy.txt'.
setwd('..')
write.table(MeanData, file = 'TidySummary.txt', row.names = FALSE)
setwd('..')
