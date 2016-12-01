# DSS Coursera.org
# Regression Models
# Week4

# Generalized Linear Regression

# Logistic Regression

# First look at a simulation example.

x <- seq(-10, 10, length = 1000)
library(manipulate)
manipulate(
        plot(x, exp(beta0 + beta1 * x) / (1 + exp(beta0 + beta1 * x)),
             type = 'l', lwd = 3, frame = FALSE),
        # Note below: beta0 and beta1 cannot use '<-' to be valued. Not sure why yet.
        beta1 = slider(-2, 2, step = 0.1, initial = 2),
        beta0 = slider(-2, 2, step = 0.1, initial = 0)
)



# Let's use an example of NFL Baltimore Ravens winning data.

download.file('https://dl.dropboxusercontent.com/u/7710864/data/ravensData.rda',
              destfile = 'ravensData.rda')
load('ravensData.rda')
head(ravensData)

# The linear model doesn't take the job good enough.
lmRavens <- lm(ravensData$ravenWinNum ~ ravensData$ravenScore)
summary(lmRavens)$coef

# Now we use the binomial glm.
logRegRavens <- glm(ravensData$ravenWinNum ~ ravensData$ravenScore, family = binomial)
summary(logRegRavens)
plot(ravensData$ravenScore, logRegRavens$fitted.values, pch = 19, col = 'blue',
     xlab = 'Score', ylab = 'Prob Ravens Win')

# Note the statistics we got are the logits.
# We need to convert back to raw probability using exp.
exp(logRegRavens$coef)
exp(confint(logRegRavens))
anova(logRegRavens, test = 'Chisq')


# Poisson Regression

download.file('https://dl.dropboxusercontent.com/u/7710864/data/gaData.rda',
              destfile = 'gaData.rda')
load('gaData.rda')
gaData$julian <- julian(gaData$date)
head(gaData)
plot(gaData$julian, gaData$visits, pch = 19, col = 'grey',
     xlab = 'Date in Julian', ylab = 'Visit Numbers')
# Simple linear model
lm1 <- lm(gaData$visits ~ gaData$julian)
abline(lm1, col = 'red', lwd = 3)

# Poisson model
exp(coef(lm(I(log(gaData$visits + 1)) ~ gaData$julian)))
glm1 <- glm(gaData$visits ~ gaData$julian, family = poisson)
lines(gaData$julian, glm1$fitted.values, col = 'blue', lwd = 3)

# Mean-Variance Relationship
# Note in Poisson distrubution, mean and variance are the same;
# however the fitted model above doesn't show that - 
plot(glm1$fitted, glm1$residuals, pch = 19, col = 'grey',
     ylab = 'Residuals', xlab = 'Fitted')
# It has higher variance for lower mean. There should be a correction.
# Jeff Leek has written one function confint.agnostic() to estimate confint corrected.

# We give an offset of log of total visits, which is the total visit as denominator.
glm2 <- glm(gaData$simplystats ~ gaData$julian, offset = log(gaData$visits + 1),
            family = poisson)
plot(gaData$julian, glm2$fitted, col = 'blue', pch = 19, xlab = 'Date',
     ylab = 'Fitted Counts')
points(gaData$julian, glm1$fitted, col = 'red', pch = 19)

plot(gaData$julian, gaData$simplystats / (gaData$visits + 1), pch = 19, col = 'grey', lwd = 3)
lines(gaData$julian, glm2$fitted / (gaData$visits + 1), col = 'blue', lwd = 3)

# End note
# Log-linear models and multiway tables
# Wiki on overdispersion
# Regression models for count data
# pscl package for fitting zero inflated models - data have a lot of zeros.
