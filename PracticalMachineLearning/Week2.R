# DSS Coursera.org
# Practical Machine Learning
# Week2


#============================================================#
# The Caret Package
#============================================================#

library(caret)
library(kernlab)        # This package contains the spam dataset.
data(spam)

# Randomly split entire data into training and testing set.
# There's likely another way for same thing in Edx course.
inTrain <- createDataPartition(y = spam$type, p = 0.75, list = FALSE)
training <- spam[inTrain, ]
testing <- spam[-inTrain, ]

# Then fit the model.
set.seed(32343)
modelFit <- train(type ~ ., data = training, method = 'glm')
modelFit
modelFit$finalModel

# And predict the model.
predictions <- predict(modelFit, newdata = testing)
predictions

# Confusion matrix - look at the results of predictions.
confusionMatrix(predictions, testing$type)


#============================================================#
# Data Slicing
#============================================================#

set.seed(32323)
# createFolds() looks like the function used in Edx course.
folds <- createFolds(y = spam$type, k = 10, list = TRUE, returnTrain = TRUE)
sapply(folds, length)
folds[[1]][1:10]

folds <- createFolds(y = spam$type, k = 10, list = TRUE, returnTrain = FALSE)
sapply(folds, length)

folds <- createResample(y = spam$type, times = 10, list = TRUE)
sapply(folds, length)
folds[[1]][1:10]                # Now there are repeated numbers (resampled).

# createTimeSlices() splits periodically 'initialWindow' number of training,
# and then 'horizon' number of testing.
tme <- 1:1000
folds <- createTimeSlices(y = tme, initialWindow = 20, horizon = 10)
names(folds)
folds$train[[1]]
folds$test[[1]]


#============================================================#
# Plotting Predictors
#============================================================#

library(ISLR)
library(ggplot2)
library(caret)
data(Wage)
summary(Wage)

inTrain <- createDataPartition(y = Wage$wage, p = 0.7, list = FALSE)
training <- Wage[inTrain, ]
testing <- Wage[-inTrain, ]
dim(training)
dim(testing)

# Like pairs() plot.
featurePlot(x = training[, c('age', 'education', 'jobclass')],
            y = training$wage, plot = 'pairs')
qplot(age, wage, data = training)
qplot(age, wage, col = jobclass, data = training)
qq <- qplot(age, wage, col = education, data = training)
qq + geom_smooth(method = 'lm', formula = y ~ x)

library(Hmisc)
# Split wage numbers into continuous groups.
cutWage <- cut2(training$wage, g = 3)
table(cutWage)
# Plot both box and points.
qplot(cutWage, age, data = training, fill = cutWage, geom = c('boxplot', 'jitter'))
table(cutWage, training$jobclass)
prop.table(t1, 1)       # 1 for row, 2 for column.
# Density plot
qplot(wage, col = education, data = training, geom = 'density')

# Further notes:
# Look for imbalance in outcomes/predictors, outliers,
# groups of points not explained by a predictor, and skewed variables.


#============================================================#
# Basic Preprocessing
#============================================================#

library(caret); library(kernlab); data(spam)
inTrain <- createDataPartition(y = spam$type, p = 0.75, list = FALSE)
training <- spam[inTrain, ]
testing <- spam[-inTrain, ]
hist(training$capitalAve, xlab = 'ave. capital run length')
mean(training$capitalAve)
sd(training$capitalAve)         # Note capitalAve has much larger sd than mean.
# This data is highly skewed, with large amount of low value but small group of high.
# Here is the proper place to preprocess.
# We use standardization.
trainCapAve <- training$capitalAve
trainCapAveS <- (trainCapAve - mean(trainCapAve)) / sd(trainCapAve)
mean(trainCapAveS); sd(trainCapAveS)

# Note! When we come over to testing, we need to standardize the testingset
# USING MEAN AND SD OF TRAINING SET.
testCapAve <- testing$capitalAve
testCapAveS <- (testCapAve - mean(trainCapAve)) / sd(trainCapAve)
mean(testCapAveS); sd(testCapAveS)

# The above standardization can easily be done by preProcess() function.
preObj <- preProcess(training[, -58], method = c('center', 'scale'))
trainCapAveS <- predict(preObj, training[, -58])$capitalAve
mean(trainCapAveS); sd(trainCapAveS)

testCapAveS <- predict(preObj, testing[, -58], method = c('center', 'scale'))$capitalAve
mean(testCapAveS); sd(testCapAveS)

# Another way - call preProcess as argument in train() function.
set.seed(32343)
modelFit <- train(type ~ ., data = training,
                  preProcess = c('center', 'scale'), method = 'glm')
modelFit

# Other transformations instead of standardizing, or another way to standardize.
# BoxCox transformation estimates a ~normal distribution of data using maximum likelihood.
preObj <- preProcess(training[, -58], method = c('BoxCox'))
trainCapAveS <- predict(preObj, training[, -58])$capitalAve
hist(trainCapAveS)
qqnorm(trainCapAveS)



# Imputing missing data
set.seed(13343)

# To illustrate, we make some NAs.
training$capAve <- training$capitalAve
selectNA <- rbinom(dim(training)[1], size = 1, prob = 0.05) == 1
training$capAve[selectNA] <- NA

# Now impute and standardize.
preObj <- preProcess(training[, -58], method = 'knnImpute')
capAve <- predict(preObj, training[, -58])$capAve

# Standardize tre values.
capAveTruth <- training$capitalAve
capAveTruth <- (capAveTruth - mean(capAveTruth)) / sd(capAveTruth)

# Now check.
quantile(capAve - capAveTruth)
quantile((capAve - capAveTruth)[selectNA])
quantile((capAve - capAveTruth)[!selectNA])

# Note: be careful when transforming factor variables.


#============================================================#
# Covariate Creation
#============================================================#

# Covariate are sometimes also called predictor or feature.
# 2 levels to generate covariate:
# 1) from raw data to covariate
# 2) transforming tidy covariates - only on training set.

library(ISLR); library(ggplot2); library(caret); data(Wage)
inTrain <- createDataPartition(y = Wage$wage, p = 0.7, list = FALSE)
training <- Wage[inTrain, ]
testing <- Wage[-inTrain, ]

# Common covariates to add - dummy variables
# Basic idea - convert factor variables to indicator variables.
table(training$jobclass)
dummies <- dummyVars(wage ~ jobclass, data = training)
head(predict(dummies, newdata = training))

# Removing zero covariates - variables don't change thruout the dataset.
nsv <- nearZeroVar(training, saveMetrics = TRUE)
nsv

# Spline basis - split data into ax^3 + bx^2 + cx, for curve fitting.
library(splines)
bsBasis <- bs(training$age, df = 3)
bsBasis
# Fitting curves with splines.
lm1 <- lm(wage ~ bsBasis, data = training)
plot(training$age, training$wage, pch = 19, cex = 0.5)
points(training$age, predict(lm1, newdata = training), col = 'red', pch = 19, cex = 0.5)
# Splines on the test set
predict(bsBasis, age = testing$age)


#============================================================#
# Preprocessing with PCA
#============================================================#

library(caret); library(kernlab); data(spam)
inTrain <- createDataPartition(y = spam$type, p = 0.75, list = FALSE)
training <- spam[inTrain, ]
testing <- spam[-inTrain, ]

# Check correlated predictors (features, covariates, vectors...)
M <- abs(cor(training[, -58]))
diag(M) <- 0                            # Get rid of all identicals.
which(M > 0.8, arr.ind = TRUE)          # List all highly correlated vectors.
plot(spam[, 34], spam[, 32])            # Visualize the correlation.

# So here comes idea of PCA - reduce number of predictors,
# and also reduce noise due to averaging.
# Rotate by 45 degree - looks familiar.
smallSpam <- spam[, c(34,32)]
prComp <- prcomp(smallSpam)
plot(prComp$x[,1], prComp$x[,2])
prComp$rotation                         # This tells how the data is rotated.
typeColor <- ((spam$type == 'spam') * 1 + 1)
prComp <-prcomp(log10(spam[, -58] + 1))
plot(prComp$x[,1], prComp$x[,2], col = typeColor, xlab = 'PC1', ylab = 'PC2')

# Can also do PCA with preProcess() function.
preProc <- preProcess(log10(spam[, -58] + 1), method = 'pca', pcaComp = 2)
spamPC <- predict(preProc, log10(spam[, -58] + 1))
plot(spamPC[,1], spamPC[,2], col = typeColor)
trainPC <- predict(preProc, log10(training[, -58] + 1))
modelFit <- train(training$type ~ ., method = 'glm', data = trainPC)
testPC <- predict(preProc, log10(testing[, -58] + 1))
confusionMatrix(testing$type, predict(modelFit, testPC))

# Alternative way
modelFit <- train(training$type ~ ., method = 'glm', preProcess = 'pca', data = training)
confusionMatrix(testing$type, predict(modelFit, testPC))


#============================================================#
# Predicting with Regression
#============================================================#

# Key Ideas:
# Fit a simple regression model
# Plug in new covariates and multiply by coefficnents
# Useful when the linear model is (nearly) correct
# Pros: easy to implement and to interpret
# Cons: often poor performance in non-linear settings.
library(caret); data(faithful)
set.seed(333)
inTrain <- createDataPartition(y = faithful$waiting,
                               p = 0.5, list = FALSE)
trainFaith <- faithful[inTrain,]; testFaith <- faithful[-inTrain,]
head(trainFaith)

# Volcano Old faithful - eruption duration vs. waiting time
plot(trainFaith$waiting, trainFaith$eruptions, pch = 19, col = 'blue')

# Fit a linear model
lm1 <- lm(eruptions ~ waiting, data = trainFaith)
summary(lm1)
lines(trainFaith$waiting, lm1$fitted.values, lwd = 3)
# Predict data
coef(lm1)[1] + coef(lm1)[2] * 80
predict(lm1, newdata = data.frame(waiting = 80))

# Plot predictions - training vs. testing
par(mfrow = c(1, 2))
plot(trainFaith$waiting, trainFaith$eruptions, pch = 19, col = 'blue')
lines(trainFaith$waiting, predict(lm1), lwd = 3)
plot(testFaith$waiting, testFaith$eruptions, pch = 19, col = 'blue')
lines(testFaith$waiting, predict(lm1, newdata = testFaith), lwd = 3)

# Get train/test errors
# RMSEs
sqrt(sum((lm1$fitted - trainFaith$eruptions) ^ 2))
sqrt(sum((predict(lm1, newdata = testFaith) - testFaith$eruptions) ^ 2))

# Prediction intervals
pred1 <- predict(lm1, newdata = testFaith, interval = 'prediction')
# interval = 'prediction' gives 2 additional columns besides fit - upper and lower limit.
ord <- order(testFaith$waiting)
plot(testFaith$waiting, testFaith$eruptions, pch = 19, col = 'blue')
matlines(testFaith$waiting[ord], pred1[ord,], type = 'l', , col = c(1,2,2), lty = c(1,1,1), lwd = 3)

# Same process with caret
modFit <- train(eruptions ~ waiting, dat = trainFaith, method = 'lm')
summary(modFit$finalModel)


#============================================================#
# Predicting with Regression (Multi-Covariates)
#============================================================#

library(ISLR); library(ggplot2); library(caret); data(Wage)
Wage <- subset(Wage, select = -c(logwage))
summary(Wage)
inTrain <- createDataPartition(y = Wage$wage, p = 0.7, list = FALSE)
training <- Wage[inTrain, ]
testing <- Wage[-inTrain, ]
featurePlot(x = training[, c('age', 'education', 'jobclass')],
            y = training$wage,
            plot = 'pairs')
qplot(age, wage, col = jobclass, data = training)
qplot(age, wage, col = education, data = training)

# Fit a linear model
modFit <- train(wage ~ age + jobclass + education,
                method = 'lm', data = training)
fitMod <- modFit$finalModel
plot(fitMod, 1, pch = 19, cex = 0.5)

# Color by variables not used in the model
qplot(fitMod$fitted, fitMod$residuals, col = race, data = training)
# Plot by index
plot(fitMod$residuals, pch = 19)

# Predicted vs. truth in the test set
pred <- predict(modFit, testing)
qplot(wage, pred, col = year, data = testing)

# Use all covariates - not recommended.
modFitAll <- train(wage ~ ., data = training, method = 'lm')
pred <- predict(modFitAll, testing)
qplot(wage, pred, data = testing)

# Final note: try to combine with other regression models.


#============================================================================#
# Quizzes
#============================================================================#

library(AppliedPredictiveModeling)
data(AlzheimerDisease)
set.seed(3433)
adData <- data.frame(diagnosis, predictors)
inTrain <- createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training <- adData[inTrain, ]
testing <- adData[-inTrain, ]
varIdx <- grep('^IL', names(training))

# Find number of PCs holding 90% of variance.
preProc <- preProcess(training[, varIdx], method = 'pca', thresh = 0.9)

# Now train with all variables starting with 'IL'.
trainingSub <- training[, c(1,varIdx)]
modelFit <- train(diagnosis ~ ., method = 'glm', data = trainingSub)
confusionMatrix(testing$diagnosis, predict(modelFit, testing[,varIdx]))

# Then train with PCs explaining 80% variance.
# Step1: obtain preprcess formula using PCA method, threshold at 80%.
preProc <- preProcess(training[, varIdx], method = 'pca', thresh = 0.8)
# Step2: generate the PCs from formula and raw data.
trainPC <- cbind(diagnosis = training[,1], predict(preProc, training[, varIdx]))
# Step3: train with data of PCs, and build the model.
modelFit2 <- train(diagnosis ~ ., method = 'glm', data = trainPC)
# Step4: generate the testing PCs from testing raw data.
testPC <- cbind(diagnosis = testing[,1], predict(preProc, testing[, varIdx]))
# Step5: predict using model from training, and PCs of test. Compare with truth.
confusionMatrix(testPC$diagnosis, predict(modelFit2, testPC))
# Note training with PCs is better than not.

data(concrete)
library(caret)
set.seed(1000)
inTrain <- createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]
training <- mixtures[inTrain, ]
testing <- mixtures[-inTrain, ]
sapply(1:(dim(training)[2] - 1), function(i) plot(training$CompressiveStrength, col = cut2(training[,i], g = 3), main = names(training)[i]))
hist(training$Superplasticizer)
hist(log(training$Superplasticizer))
