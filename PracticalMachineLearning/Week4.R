# DSS Coursera.org
# Practical Machine Learning
# Week4


#============================================================#
# Regularized Regression
#============================================================#

# Basic Idea: fit a regression model; penalize (shrink) large coefficients

# Pros: help with bias/variance tradeoff, and model selection.
# Cons: maybe computationally demanding on large datasets; doesn't perform as well
# as random forest and boosting.

# Model selection approach: split samples
# 1. Divide data into training/testing/validation sets;
# 2. Treat validation as test data, train all competing models on training data
# and pick the best one on validation;
# 3. Apply to test set to appropiately assess performance.
# 4. Repeat 1-3.

# Two common problems: limited data; computational complexity.


# Prostate Cancer as example.
library(ElemStatLearn); data(prostate)
str(prostate)

small <- prostate[1:5, ]
lm(lpsa ~ ., data = small)

# Penalization ways - ridge, lasso, relaxo.



#============================================================#
# Combining Predictors - Ensambling Methods
#============================================================#

# Basic idea:
# Combine classifiers by averaging/voting;
# Combining classifiers improves accuracy, reduces interpretability.
# NOTE: Boosting, bagging, and random forests are variants on this theme.

# Usually combine similar classifiers (bagging, boosting, random forests)
# For different classifiers: staking / ensembling models.

# Example with Wage Dataset.
library(ISLR); data(Wage); library(ggplot2); library(caret)
Wage <- subset(Wage, select = -c(logwage))
# Include a validation set.
set.seed(135)
inBuild <- createDataPartition(y = Wage$wage, p = 0.7, list = F)
validation <- Wage[-inBuild, ]
buildData <- Wage[inBuild, ]
# Now separate testing and training sets.
inTrain <- createDataPartition(y = buildData$wage, p = 0.7, list = F)
training <- buildData[inTrain, ]; testing <- buildData[-inTrain, ]

# Build 2 different models.
mod1 <- train(wage ~ ., method = 'glm', data = training)
mod2 <- train(wage ~ ., method = 'rf', data = training,
              trControl = trainControl(method = 'cv'), number = 3)
# Random forest method takes way too long.

# And predict on the testing set.
pred1 <- predict(mod1, testing); pred2 <- predict(mod2, testing)
qplot(pred1, pred2, col = wage, data = testing) +
        geom_abline(intercept = 0, slope = 1, col = 'red')

# Then let's fit a model combining the predictors / classifiers.
predDF <- data.frame(pred1, pred2, wage = testing$wage)
combModFit <- train(wage ~ ., method = 'gam', data = predDF)    # Fit with the 2 previous predictions.
combPred <- predict(combModFit, predDF)

qplot(combPred, testing$wage) +
        geom_abline(intercept = 0, slope = 1, col = 'red')

# Let's come back to the models and see how well they fit.
sqrt(sum((pred1 - testing$wage)^2))
sqrt(sum((pred2 - testing$wage)^2))
sqrt(sum((combPred - testing$wage)^2))
# The combined method gives better results.

# Remember it's necessary to validate the models using validation set.
valid1 <- predict(mod1, validation)
valid2 <- predict(mod2, validation)
validDF <- data.frame(pred1 = valid1, pred2 = valid2)
combValid <- predict(combModFit, validDF)

# Check again.
sqrt(sum((valid1 - validation$wage)^2))
sqrt(sum((valid2 - validation$wage)^2))
sqrt(sum((combValid - validation$wage)^2))
# In this parsing instance, the ensembling method fails to improve the results.



#============================================================#
# Forecasting
#============================================================#

# Major differences: 
# Data are dependent over time.
# Specific pattern types:
# - Trends: long term increase or decrease;
# - Seasonal patterns: patterns related to time, week, month, season, etc.;
# - Cycles: patterns rises and falls periodically.
# Subsampling into training/test sets is more complicated.
# Similar issues arise in spatial data
# - Dependency between nearby observations;
# - Location specific effects.
# Typically goal is to predict one or more observations into the future.
# All standard predictions can be used, but with caution!

# Use a google data as example.
library(quantmod)
from.dat <- as.Date('01/01/08', format = '%m/%d/%y')
to.dat <- as.Date('12/31/13', format = '%m/%d/%y')
getSymbols('GOOG', src = 'google', from = from.dat, to = to.dat)
head(GOOG)

# Below parses data into monthly view; use of functions are not scrutinized,
# but they may be useful in the future.
mGoog <- to.monthly(GOOG[,1])
googOpen <- Op(mGoog)
ts1 <- ts(googOpen, frequency = 12)
plot(ts1, xlab = 'Years + 1', ylab = 'GOOG')
# Above is open prices of Google, showing irregular curve.

# The above curve may be decomposed to several features:
# Trend - consistently increasing pattern over time;
# Seasonal - When there is a pattern over a fixed period of time that recurs;
# Cyclic - When data rises and falls over non fixed periods. (random variance?)

# Now let's decompose that using a simple function.
plot(decompose(ts1), xlab = 'Years + 1')

# Now create training and test sets.
ts1Train <- window(ts1, start = 1, end = 5)
ts1Test <- window(ts1, start = 5, end = (7 - 0.01))
ts1Train
plot(ts1Train)

# Simple Moving Average
library(forecast)
lines(ma(ts1Train, order = 3), col = 'red')     # Maybe like loess()?


# Exponential Smoothing
ets1 <- ets(ts1Train, model = 'MMM')
fcast <- forecast(ets1)
plot(fcast)
lines(ts1Test, col = 'red', lwd = 2)
# Get accuracy.
accuracy(fcast, ts1Test)

# Final notes:
# Forecasting and time-series prediction is an entire field.
# Causions: Beware of spurious correlations, extrapoation, and dependencies over time.
# Financial predicting: quantmod, quandl packages may be helpful.



#============================================================#
# Unsupervised Prediction
#============================================================#

# Sometimes people don't know the labels for prediction - no supervision.

# Basic ideas
# Create clusters => Name clusters => Build predictor for clusters.
# In a new dataset, predict clusters.

# Iris as example.
data(iris); library(ggplot2)
inTrain <- createDataPartition(y = iris$Species, p = 0.7, list = F)
training <- iris[inTrain, ]; testing <- iris[-inTrain, ]

# Now we ignore the species clusters; instead use k-means method to cluster.
# We still need to know beforehand how many clusters we want to split.
kMeans1 <- kmeans(subset(training, select = -c(Species)), centers = 3)
training$clusters <- as.factor(kMeans1$cluster)
qplot(Petal.Width, Petal.Length, col = clusters, data = training)
# Look at the accuracy of clustering.
table(kMeans1$cluster, training$Species)        # Somehow close, but not perfect.

# Now build predictor.
modFit <- train(clusters ~ ., data = subset(training, select = -c(Species)), method = 'rpart')
table(predict(modFit, training), training$Species)
# Again, it appears that 2 clusters are interpermeating.

# Apply model on test set.
testClusterPred <- predict(modFit, testing)
table(testClusterPred, testing$Species)
# The prediction is actually better than expected.

# Final notes:
# The cl_predict() function in the clue package provides similar functionality.
# Beware of over-interpretation of clusters!
# One basic approach to recommendation engines.



#============================================================================#
# Quizzes
#============================================================================#

library(caret); library(AppliedPredictiveModeling)
library(ElemStatLearn); library(rpart); library(pgmm)
library(gbm); library(lubridate); library(forecast)
library(e1071)

# Q1

# Load data
data(vowel.train)
data(vowel.test)
vowel.train$y <- as.factor(vowel.train$y)
vowel.test$y <- as.factor(vowel.test$y)

# Fit model
library(randomForest)
set.seed(33833)
# Random Forest
modRf <- train(y ~ ., method = 'rf', data = vowel.train)
# GBM
modGBM <- train(y ~ ., method = 'gbm', data = vowel.train)
# Ensembling
predRF <- predict(modRF, vowel.test)
predGBM <- predict(modGBM, vowel.test)

# See the accuracy
confusionMatrix(testRF, vowel.test$y)
confusionMatrix(testGBM, vowel.test$y)
confusionMatrix(testGBM, testRF)
# Predict test set.


# Q2

# Load data.
library(gbm); library(AppliedPredictiveModeling)
data(AlzheimerDisease)
set.seed(33833)
adData <- data.frame(diagnosis, predictors)
inTrain <- createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training <- adData[inTrain,]; testing <- adData[-inTrain, ]

# Fit model
set.seed(62433)
modRF <- train(diagnosis ~ ., data = training, method = 'rf')
modGBM <- train(diagnosis ~ ., data = training, method = 'gbm')
modLDA <- train(diagnosis ~ ., data = training, method = 'lda')

# Stack the models - using test data.
predRF <- predict(modRF, testing)
predGBM <- predict(modGBM, testing)
predLDA <- predict(modLDA, testing)
stackData <- data.frame(predRF = predRF, predGBM = predGBM,
                        predLDA = predLDA, diagnosis = testing$diagnosis)
modStack <- train(diagnosis ~ ., data = stackData, method = 'rf')
predStack <- predict(modStack, testing)

# See accuracy - this time calculate directly, not using confusion matrix.
mean(predRF == testing$diagnosis)
mean(predGBM == testing$diagnosis)
mean(predLDA == testing$diagnosis)
mean(predStack == testing$diagnosis)
# As good as boosting, better than others.


# Q3

# Load data.
data(concrete)
set.seed(3433)
data(concrete)
inTrain <- createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training <- concrete[inTrain,]; testing <- concrete[-inTrain,]

# Build model.
set.seed(233)
modFit <- train(CompressiveStrength ~ ., data = concrete, method = 'lasso')
plot.enet(modFit$finalModel, xvar = 'penalty', use.color = T)            # plot(modFit$finalModel) works the same way.


# Q4

# Load data
Url <- 'https://d396qusza40orc.cloudfront.net/predmachlearn/gaData.csv'
if(!file.exists('gaData.csv')) download.file(Url, destfile = 'gaData.csv')
dat <- read.csv('gaData.csv')
training <- dat[year(dat$date) < 2012,]
testing <- dat[year(dat$date) > 2011,]
tstrain <- ts(training$visitsTumblr)

# Fit model
# Use bats() fit, like ets() in above note.
modFit <- bats(tstrain)
# Forecast() takes the 'model fitted' (don't know if it's a real model),
# length of prediction ahead, and confidence intervals.
pred <- forecast(modFit, h = length(testing$visitsTumblr), level = c(95))
# FInd accuracy within the confidence intervals.
mean(testing$visitsTumblr > pred$lower & testing$visitsTumblr < pred$upper)


# Q5

# Load data
set.seed(3523)
data(concrete)
inTrain <- createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training <- concrete[inTrain,]; testing <- concrete[-inTrain,]

# Fit model
set.seed(325)
modSVM <- svm(CompressiveStrength ~ ., data = training)
predSVM <- predict(modSVM, testing)

# Calculate RMSE
sqrt(sum((predSVM - testing$CompressiveStrength)^2)/length(predSVM))
# Use accuracy() function
accuracy(predSVM, testing$CompressiveStrength)[2]
