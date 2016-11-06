# DSS Coursera, Exploratory Data Analysis
# Week 2

#===========================================#
# Lattice Plotting System
#===========================================#

library(lattice)
library(datasets)

# Simple scatterplot
xyplot(Ozone ~ Wind, data = airquality)

# Convert 'Month' to a factor variable.
airquality <- transform(airquality, Month = factor(Month))
xyplot(Ozone ~ Wind | Month, data = airquality, layout = c(5,1))

# Note: non-base plotting systems take 2 steps:
# 1st - create an object of 'trellis' class;
# 2nd - store plotting info into the object.
p <- xyplot(Ozone ~ Wind, data = airquality)    # Nothing happens.
class(p)
p                                               # Now graph shows.

# Lattice Panel Functions
set.seed(10)
x <- rnorm(100)
f <- rep(0:1, each = 50)
y <- x + f - f * x + rnorm(100, sd = 0.5)
f <- factor(f, labels = c('Group 1', 'Group 2'))
xyplot(y ~ x | f, layout = c(2,1))

# Custom panel function
xyplot(y ~ x | f, panel = function(x, y, ...) {
        panel.xyplot(x, y, ...)         # First call the default.
        panel.abline(h = median(y), lty = 2)
        panel.lmline(x, y, col = 2)
})


#===========================================#
# ggplot2
#===========================================#

# A simple demo case.
library(ggplot2)
qplot(displ, hwy, data = mpg)
# Add color by another vector - easily plot 3rd dimension!
qplot(displ, hwy, data = mpg, col = drv)        # Legend is made automatically.
# Add a geom - smooth / trend.
# geom is a vector argument.
qplot(displ, hwy, data = mpg, geom = c('point', 'smooth'))

# Now plot only 1 vector - will make histogram.
# 'color' shows outline of strips only.
# 'bins' separates the data in how many ranges.
qplot(hwy, data = mpg, fill = drv, bins = 30)

# ggplot2 can also create facets - multi-plot versus multi-color.
qplot(displ, hwy, data = mpg, facets = .~drv)
qplot(hwy, data = mpg, facets = drv~., bins = 30)       # + geom_smooth(method = )


# Let's move on to ggplot()
g <- ggplot(mpg, aes(displ, hwy))       # Create a ggplot object.
g               # Note there's nothing yet.
# Now add a layer to the object.
p <- g + geom_point()
p               # Now it prints.
# Add smooth layer, with default loess method.
g + geom_point() + geom_smooth()        # Default smoothing uses loess().
g + geom_point() + geom_smooth(method = 'lm')
# Then add facet layer.
g + geom_point() + geom_smooth(method = 'lm') + facet_grid(. ~ drv)
# We shall also add titles and labels.
# Functions available: xlab(), ylab(), labs(), title(), etc.
# For global parameters, may use theme(), e.g.: theme(legend.position = 'none').
# Two standard appearance thems:
# - theme_grey(): grey background.
# - them_bw(): more sparks / plain

# Modify aesthetics
g + geom_point(col = 'steelblue', size = 6, alpha = 0.5)        # alpha controls transparency.
g + geom_point(aes(col = drv), size = 4, alpha = 0.5)           # aes() seems very useful.
# Don't even have to use quotes. Note '[]' results in subscript without quotes.
# No spaces between strings (quoted or unquoted) - use '*' to connect.
# se = FALSE removes the confidence band of smoothing.
g + geom_point(aes(col = drv), size = 4, alpha = 0.5) +
        labs(title = 'mpg sample plot') +
        labs(x = expression(displ * ' ' * sub[2.5])) +
        geom_smooth(size = 4, lty = 3, method = 'lm', se = FALSE)

# Axis limit issue may occor:
testdat <- data.frame(x = 1:100, y = rnorm(100))
testdat[50, 2] <- 100
plot(testdat$x, testdat$y, type = 'l', ylim = c(-3, 3))

# We now use ggplot.
g <- ggplot(testdat, aes(x = x, y = y))
g + geom_line()
# Note we are not interested in the outlier, so set ylim.
g + geom_line() + ylim(-3, 3)
# Note the dot is omitted, and the line is disconnected.
# To connect, use below function.
g + geom_line() + coord_cartesian(ylim = c(-3, 3))

# Cut data into percentiles.
cutpoints <- quantile(mpg$hwy, seq(0, 1, length = 4), na.rm = TRUE)
mpg$cutdata <- cut(mpg$hwy, cutpoints)
levels(mpg$cutdata)
# Setup ggplot with data frame.
g <- ggplot(mpg, aes(displ, cutdata))
# Add layers with modifications.
g + geom_point(alpha = 1/3) +
        facet_wrap(drv ~ cutdata, nrow = 3, ncol = 3) +
        geom_smooth(method = 'lm') +
        theme_bw(base_family = 'Avenir', base_size = 10) +
        labs(x = expression(displ * sub[2.5])) +
        labs(y = 'highway') +
        labs(title = 'MPG sample plot')
