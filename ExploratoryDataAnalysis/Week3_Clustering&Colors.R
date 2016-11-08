# DSS Coursera.org
# Exploratory Data Analysis
# Week 3


#===========================================#
# Hierachical Clustering
#===========================================#

# Clustering works when samples close to eachother group together.
# "Close" is defined by distance.
# Euclidean distance - sqrt(sum((varAi - varBi) ^ 2))
# Manhattan distance - sum(abs(varAi - varBi))

# First example.
set.seed(1234)
par(mar = c(0, 0, 0, 0))
x <- rnorm(12, mean = rep(1:3, each = 4), sd = 0.2)
y <- rnorm(12, mean = rep(c(1, 2, 1), each = 4), sd = 0.2)
plot(x, y, col = 'blue', pch = 19, cex = 2)
text(x + 0.05, y + 0.05, labels = as.character(1:12))

# Read data into data.frame.
dataFrame <- data.frame(x = x, y = y)
# dist() calculates distances between any 2 points.
distxy <- dist(dataFrame)

# Dendrogram Algorithm: find 2 closest points, merge.
# Then find closest.

# hclust() does hierachical clustering
# from distance object (dist)
hClustering <- hclust(distxy)

# Then we plot hclust object, we get dendrogram.
plot(hClustering)

# heatmap()
# plot 2-D hierachical clustering of columns and rows.
set.seed(143)
dataMatrix <- as.matrix(dataFrame)[sample(1:12), ]
heatmap(dataMatrix)


#===========================================#
# K-Means Clustering
#===========================================#

# Use the example again..
set.seed(1234)
par(mar = c(0, 0, 0, 0))
x <- rnorm(12, mean = rep(1:3, each = 4), sd = 0.2)
y <- rnorm(12, mean = rep(c(1, 2, 1), each = 4), sd = 0.2)
plot(x, y, col = 'blue', pch = 19, cex = 2)
text(x + 0.05, y + 0.05, labels = as.character(1:12))

# Skipped the animation showing algorithm.
dataFrame <- data.frame(x, y)
# kmeans() clusters data into designated number of groups
kmeansObj <- kmeans(dataFrame, centers = 3)
names(kmeansObj)
kmeansObj$cluster       # Group of each element.

# Visualize clustered data.
par(mar = rep(0.2, 4))
plot(x, y, col = kmeansObj$cluster, pch = 19, cex = 2)
points(kmeansObj$centers, col = 1:3, pch = 3, cex = 3, lwd = 3)

# Look at heatmap
set.seed(1234)
dataMatrix <- as.matrix(dataFrame)[sample(1:12), ]
kmeansObj2 <- kmeans(dataMatrix, centers = 3)
par(mfrow = c(1, 2), mar = c(2, 4, 0.1, 0.1))
image(t(dataMatrix)[, nrow(dataMatrix):1], yaxt = 'n')
image(t(dataMatrix)[, order(kmeansObj$cluster)], yaxt = 'n')


#===========================================#
# Dimension Reduction
#===========================================#

set.seed(12345)
par(mfrow = c(1, 1))
par(mar = rep(0.2, 4))
# Random matrix.
dataMatrix <- matrix(rnorm(400), nrow = 40)
image(1:10, 1:40, t(dataMatrix)[, nrow(dataMatrix):1])
heatmap(dataMatrix)     # No difference.

set.seed(678910)
for(i in 1:40) {
        coinFlip <- rbinom(1, size = 1, prob = 0.5)
        if(coinFlip) {
                dataMatrix[i, ] <- dataMatrix[i, ] + rep(c(0,3), each = 5)
        }
}
image(1:10, 1:40, t(dataMatrix)[, nrow(dataMatrix):1])
heatmap(dataMatrix)     # Now there is a difference.

hh <- hclust(dist(dataMatrix))
dataMatrixOrdered <- dataMatrix[hh$order, ]
par(mfrow = c(1, 3))
image(t(dataMatrixOrdered)[, nrow(dataMatrixOrdered):1])
plot(rowMeans(dataMatrixOrdered), 40:1, , xlab = 'Row Mean', ylab = 'Row', pch = 19)
plot(colMeans(dataMatrixOrdered), xlab = 'Column', ylab = 'Column Mean', pch = 19)


# There are always many variables and tests revealing the correlation.
# It's sometimes good to get a sub-matrix which explains most of variance but with smaller size.

# SVD & PCA are 2 major ways.
# Look at SVD first.
svd1 <- svd(scale(dataMatrixOrdered))
par(mfrow = c(1, 3))
image(t(dataMatrixOrdered)[, nrow(dataMatrixOrdered):1])
plot(svd1$u[, 1], 40:1, , xlab = 'Row', ylab = 'U', pch = 19)
plot(svd1$v[, 1], xlab = 'Column', ylab = 'V', pch = 19)

# The diagonal matrix d shows the 'power' of each vector.
# The 1st matrix with highest singular value, explains most of variance.
par(mfrow = c(1, 2))
plot(svd1$d, xlab = 'Column', ylab = 'Singular Value', pch = 19)
plot(svd1$d^2 / sum(svd1$d^2), xlab = 'Column', ylab = 'Proportion of Variance Explained', pch = 19)


# Then look at PCA.
# prcomp() essentially doing the same thing.
svd1 <- svd(scale(dataMatrixOrdered))
pca1 <- prcomp(dataMatrixOrdered, scale = TRUE)
par(mfrow = c(1, 1))
plot(pca1$rotation[, 1], svd1$v[, 1], pch = 19,
     xlab = 'Principal Component 1', ylab = 'V')
abline(c(0, 1))


# Components of the SVD - variance explained.
constantMatrix <- dataMatrixOrdered * 0
for(i in 1:dim(dataMatrixOrdered)[1]) {constantMatrix[i, ] <- rep(c(0, 1), each = 5)}
svd1 <- svd(constantMatrix)
image(t(constantMatrix)[, nrow(constantMatrix):1])
plot(svd1$d, pch = 19)
plot(svd1$d^2 / sum(svd1$d^2), pch = 19)
# In this case, 1 column is enough to explain variance,
# as all observations are the same: 0 0 0 0 0 1 1 1 1 1.

# Now we add the 2nd pattern.
set.seed(678910)
for(i in 1:40) {
        coinFlip1 <- rbinom(1, size = 1, prob = 0.5)
        coinFlip2 <- rbinom(1, size = 1, prob = 0.5)
        if(coinFlip1) {
                dataMatrix[i, ] <- dataMatrix[i, ] + rep(c(0, 5), each = 5)
        }
        if(coinFlip2) {
                dataMatrix[i, ] <- dataMatrix[i, ] + rep(c(0, 5), 5)
        }
}
hh <- hclust(dist(dataMatrix))
dataMatrixOrdered <- dataMatrix[hh$order, ]

svd2 <- svd(scale(dataMatrixOrdered))

# The raw data matrix.
image(t(dataMatrixOrdered)[, nrow(dataMatrixOrdered):1])
plot(rep(c(0, 1), each = 5), pch = 19)
plot(rep(c(0, 1), 5), pch = 19)
# The SVD matrix.
image(t(dataMatrixOrdered)[, nrow(dataMatrixOrdered):1])
plot(svd2$v[, 1], pch = 19)     # This shows the trends of both sub-patterns
plot(svd2$v[, 2], pch = 19)     # Also shows something related, but not exact.


# If there's missing value, SVD doesn't work.
# In those cases, we need to ouse impute package.
library(impute)
dataMatrix2 <- dataMatrixOrdered
dataMatrix2[sample(1:100, size = 40, replace = FALSE)] <- NA
svd(dataMatrix2)        # Note this gives error.
# impute.knn() Fill the NA rows with k nearest neighnors.
dataMatrix2 <- impute.knn(dataMatrix2)$data
svd1 <- svd(scale(dataMatrixOrdered))
svd2 <- svd(scale(dataMatrix2))
plot(svd1$v[, 1], pch = 19)
plot(svd2$v[, 1], pch = 19)
# Note the two plots are very very similar.


#===========================================#
# Plotting with Colors.
#===========================================#

# grDevices package has 2 useful functions:
# - colorRamp()
# - colorRampPalette()
# colors() can be used in any plotting function,
# and it lists names of colors.

library(grDevices)
pal <- colorRamp(c('red', 'blue'))
pal(0)
pal(0.5)

pal <- colorRampPalette(c('red', 'yellow'))
pal(2)
pal(10)

# RColorBrewer Package is also useful.
library(RColorBrewer)
# This contains 3 types of palettes:
# - Sequential for continuous numeric data.
# - Diverging for deviations.
# - Qualitative for factor or discrete.

cols <- brewer.pal(3, 'BuGn')
cols            # Get 3 colors from 'BuGn' sequential palette.
pal <- colorRampPalette(cols)
image(volcano, col = pal(20))

# smoothScatter function in R.
x <- rnorm(10000)
y <- rnorm(10000)
smoothScatter(x, y)


# Some other Plotting options.

# rgb() function can be used to generate colors
# via red green blue proportions.
# alpha patameter in rgb() is used to define transparency.

# colorspace package for different control over colors.

# Plot without transparency
plot(x, y, pch = 19)
# Now make it transparent.
plot(x, y, col = rgb(0.5, 0.5, 0.5, 0.2), pch = 19)
