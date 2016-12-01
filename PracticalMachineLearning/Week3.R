# DSS Coursera.org
# Practical Machine Learning
# Week3


#============================================================#
# Predicting with Trees
#============================================================#

# Iteratively split variables into groups
# Evaluate 'homogeneity' within each group
# Split again if necessary

# Pros: easy to interpret; better performance in nonlinear settings.
# Cons: Without pruning/cross-validation can lead to overfitting;
# harder to estimaate uncertainty; results may be variable.

# Basic algorithm:
# 1. Start with all variables in one group
# 2. Find the variable (split) best separates the outcomes
# 3. Divide the data into 2 groups on that split
# 4. Within each split, repeat steps 2~3 until groups are small or pure enough.

# Example: iris data
library(ggplot2); data(iris); library(caret)
names(iris)
table(iris$Species)

# Create training and test sets
inTrain <- createDataPartition(y = iris$Species,
                               p = 0.7, list = FALSE)
training <- iris[inTrain, ]
testing <- iris[-inTrain, ]
qplot(training$Petal.Width, training$Sepal.Width,
      col = training$Species)
# The data are separated well by species. Now we train the data.
modFit <- train(Species ~ ., method = 'rpart', data = training)
modFit$finalModel
# And visualize the model by dendogram.
plot(modFit$finalModel)
text(modFit$finalModel, use.n = TRUE, all = TRUE, cex = 0.8)

# For prettier dendograms, use rattle package.
library(rattle)
fancyRpartPlot(modFit$finalModel)

# Predicting
predict(modFit, newdata = testing)

# Final notes:
# Classification trees are nonlinear models,
# using interactions between varaibles
# data transformations may be less important (monotone transformations)
# trees can also be used for regression problems (continuous outcom)



#============================================================#
# Bagging - Bootstrap Aggregating
#============================================================#

# Basic idea:
# Resample cases and recalculate predictions
# Average or majority vote

# Notes: similar bias; reduced variance; more useful for nonlinear functions.

# Load ozone data as example.
library(ElemStatLearn); data(ozone, package = 'ElemStatLearn')
ozone <- ozone[order(ozone$ozone), ]
head(ozone)

# Bagged loess
ll <- matrix(NA, nrow = 10, ncol = 155)
# Resample ozone values to 10 groups
# and fit by loess, and calculate predicted values.
for(i in 1:10){
        ss <- sample(1:dim(ozone)[1], replace = TRUE)
        ozone0 <- ozone[ss, ]
        ozone0 <- ozone0[order(ozone0$ozone), ]
        loess0 <- loess(temperature ~ ozone, data = ozone0, span = 0.2)
        ll[i, ] <- predict(loess0, newdata = data.frame(ozone = 1:155))

}
plot(ozone$ozone, ozone$temperature, pch = 19, cex = 0.5)
for(i in 1:10) {lines(1:155, ll[i, ], col = 'grey', lwd = 2)}
lines(1:155, apply(ll, 2, mean), col = 'red', lwd = 2)
# Note the grey loess curves are estimates from resampling;
# The red is the average of the grey curves.

# In train() function, there are some bagging methods:
# bagEarth; treebag; bagFDA
# Or use the bag() function.

# More bagging - custom bagging
predictors <- data.frame(ozone = ozone$ozone)
temperature <- ozone$temperature
treebag <- bag(predictors, temperature, B = 10,
               bagControl = bagControl(fit = ctreeBag$fit,
                                       predict = ctreeBag$pred,
                                       aggregate = ctreeBag$aggregate))
plot(ozone$ozone, temperature, col = 'lightgrey', pch = 19)
# Fit from single conditional regression tree
points(ozone$ozone, predict(treebag$fits[[1]]$fit, predictors), pch = 19, col = 'red')
# Fit from 10 resampling bag regression.
points(ozone$ozone, predict(treebag, predictors), pch = 19, col = 'blue')


#============================================================#
# Random Forest
#============================================================#

# Basic ideas:
# Bootstrap samples;
# bootstrap variables at each split;
# grow multiple trees and vote.

# Pros: Accuracy
# Cons: Low speed; low interpretability; overfitting.

# Use iris data as example.
data(iris); library(ggplot2)
inTrain <- createDataPartition(y = iris$Species, p = 0.7, list = FALSE)
training <- iris[inTrain, ]
testing <- iris[-inTrain, ]

# Fit with random forest (rf) method.
modFit <- train(Species ~ ., data = training, method = 'rf', prox = TRUE)
modFit

# Look at the specific model.
getTree(modFit$finalModel, k = 2)

# Class centers.
irisP <- classCenter(training[, c(3, 4)], training$Species, modFit$finalModel$prox)
irisP <- as.data.frame(irisP)
irisP$Species <- rownames(irisP)
p <- qplot(Petal.Width, Petal.Length, col = Species, data = training)
p + geom_point(aes(x = Petal.Width, y = Petal.Length, col = Species), size = 5, shape = 4, data = irisP)

# Predicting new values
pred <- predict(modFit, testing)
testing$predRight <- pred == testing$Species
table(pred, testing$Species)
qplot(Petal.Width, Petal.Length, col = predRight, data = testing)

# Final notes
# One of the two top performing algorithms along with boosting in prediction contests.
# Difficult to interpret but often very accurate.
# Be very aware of overfitting.



#============================================================#
# Boosting
#============================================================#

# Basic ideas
# Take lots of possibly weak predictors;
# Weight them and add them up;
# Get a stronger predictor.

# Several R libraries for boosting:
# gbm - boosting with trees;
# mboost - model based boosting;
# ada - statistical boosting based on additive logistic regression;
# gamboost - boosting generalized additive models.

# Most of above are in caret package.

# Use Wage example.
library(ISLR); data(Wage); library(ggplot2); library(caret)
Wage <- subset(Wage, select = -c(logwage))
inTrain <- createDataPartition(y = Wage$wage, p = 0.7, list = FALSE)
training <- Wage[inTrain, ]; testing <- Wage[-inTrain, ]

# Fit the model
modFit <- train(wage ~ ., method = 'gbm', data = training, verbose = FALSE)

# See the prediction results.
qplot(predict(modFit, testing), wage, data = testing) +
        geom_abline(slope = 1, intercept = 0, lwd = 3, col = 'red')
# Predicts nearly unbiased, but still some variance.


#============================================================#
# Model-Based Prediction
#============================================================#

# Basic Ideas
# Assume the data follow a probablistic model;
# Use Bayes' theorem to identify optimal classifiers.

# Pros: Can take advantage of structure of data; maybe computationally convenient; reasonably accurate.
# Cons: Make additional assumptions about data; reduce accuracy when model is incorrect.

# Iris Example
data(iris); library(ggplot2)
names(iris)
table(iris$Species)

# Create training set.
inTrain <- createDataPartition(y = iris$Species, p = 0.7, list = FALSE)
training <- iris[inTrain, ]
testing <- iris[-inTrain, ]

# Build Predictions.
modlda <- train(Species ~ ., data = training, method = 'lda')
modnb <- train(Species ~ ., data = training, method = 'nb')
plda <- predict(modlda, testing); pnb <- predict(modnb, testing)
table(plda, pnb)        # Minor difference between LDA and Naive Bayes.
equalPredictions <- (plda == pnb)
# Visualize the difference
qplot(Petal.Width, Sepal.Width, col = equalPredictions, data = testing)
# Visualize the true categories
qplot(Petal.Width, Sepal.Width, col = Species, data = testing)
# Visualize predictions by LDA - it's 100% right in this case.
qplot(Petal.Width, Sepal.Width, col = plda, data = testing)
# Visualize predictions by Naive Bayes - 3 wrong predictions.
qplot(Petal.Width, Sepal.Width, col = pnb, data = testing)


#============================================================================#
# Quizzes
#============================================================================#

library(caret); library(AppliedPredictiveModeling)
library(ElemStatLearn); library(rpart); library(pgmm)

# Q1

# The answeris not reproducible, due to no seed set when partitioning training set.
# Load Data.
data(segmentationOriginal)
dim(segmentationOriginal)
# Subset training and testing sets.
inTrain <- createDataPartition(y = segmentationOriginal$Case, p = 0.7, list = F)
training <- segmentationOriginal[inTrain, ]
testing <- segmentationOriginal[-inTrain, ]

# Fit model.
set.seed(125)
modFit <- train(Class ~ ., method = 'rpart', data = training)
modFit$finalModel

# Predict specific values - not working, why?
#predict(modFit, data.frame(
#        TotalIntenCh2 = 23000, FiberWidthCh1 = 10, PerimStatusCh1 = 2))

# Visualize the dendogram.
library(rpart.plot); library(rattle)
fancyRpartPlot(modFit$finalModel)

# Q2
# K-fold CV - when k gets larger, CV is done more times (k)
# and the average estimate is less biased; however the variance
# increases as there are fewer samples per group (CLT).
# Leave-One-Out equals to n-fold CV where n is number of total
# samples; thus k = n.


# Q3

# Load data.
library(pgmm); data(olive)
olive = olive[, -1]

# Fit classification tree (no testing set here).
modFit <- train(Area ~ ., method = 'rpart', data = olive)

# Predict new dataset.
newdata <- as.data.frame(t(colMeans(olive)))
predict(modFit, newdata)


# Q4

# Load data.
library(ElemStatLearn); data(SAheart)
set.seed(8484)
train <- sample(1:dim(SAheart)[1], size = dim(SAheart)[1] / 2, replace = F)
trainSA <- SAheart[train, ]
testSA <- SAheart[-train, ]

# Fit logistic regression.
set.seed(13234)
modFit <- train(chd ~ age + alcohol + obesity + tobacco + typea + ldl,
                family = 'binomial', method = 'glm', data = trainSA)

# Test Miss-Classification Rates.
missClass <- function(values, prediction) {
        sum((prediction > 0.5) * 1 != values) / length(values)
}
missClass(trainSA$chd, predict(modFit, trainSA))
missClass(testSA$chd, predict(modFit, testSA))


# Q5

# Load data.
library(ElemStatLearn); data(vowel.train); data(vowel.test)

# Pre-treat the datasets.
vowel.train$y <- factor(vowel.train$y)
vowel.test$y <- factor(vowel.test$y)

# Fit random forest.
library(randomForest)
set.seed(33833)
modFit <- randomForest(y ~ ., data = vowel.train)
order(varImp(modFit), decreasing = T)
