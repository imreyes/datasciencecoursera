library(plotly)

# 1st examples - note the plots are interactive.
plot_ly(x = mtcars$wt, y = mtcars$mpg, mode = 'markers')

plot_ly(x = mtcars$wt, y = mtcars$mpg, mode = 'markers', color = as.factor(mtcars$cyl))

plot_ly(x = mtcars$wt, y = mtcars$mpg, mode = 'markers', color = mtcars$disp)

plot_ly(x = mtcars$wt, y = mtcars$mpg, mode = 'markers',
        color = as.factor(mtcars$cyl), size = mtcars$hp)

# 3D scatter plots.
set.seed(2016-07-21)
temp <- rnorm(100, mean = 30, sd = 5)
pressure <- rnorm(100)
dtime <- 1:100
plot_ly(x = temp, y = pressure, z = dtime,
        type = 'scatter3d', mode = 'markers', color = temp)


# Line graph
data('airmiles')
plot_ly(x = time(airmiles), y = airmiles)

# Multi-Line Graph
library(plotly)
library(tidyr)
library(dplyr)
data('EuStockMarkets')

stocks <- as.data.frame(EuStockMarkets) %>%
        gather(index, price) %>%
        mutate(time = rep(time(EuStockMarkets), 4))
plot_ly(x = stocks$time, y = stocks$price, color = stocks$index)


# Histograms
plot_ly(x = precip, type = 'histogram')

# Boxplot
plot_ly(iris, y = iris$Petal.Length, color = iris$Species, type = 'box')

# Heatmap
terrain1 <- matrix(rnorm(100 * 100), nrow = 100, ncol = 100)
plot_ly(z = terrain1, type = 'heatmap')

# 3D Surface
terrain2 <- matrix(sort(rnorm(100 * 100)), nrow = 100, ncol = 100)
plot_ly(z = terrain2, type = 'surface')


# Choropleth Maps
# Create data frame
state_pop <- data.frame(State = state.abb, Pop = as.vector(state.x77[,1]))
# Create hover text
state_pop$hover <- with(state_pop, paste(State, '<br>', 'Population', Pop))
# Make state borderes red
borders <- list(color = toRGB('red'))
# Set up some mapping options
map_options <- list(
        scope = 'usa',
        projection = list(type = 'albers usa'),
        showlakes = TRUE,
        lakecolor = toRGB('white')
)

plot_ly(z = state_pop$Pop, text = state_pop$hover, locations = state_pop$State,
        type = 'choropleth', locationmode = 'USA-states',
        color = state_pop$Pop, colors = 'Blues', marker = list(line = borders)) %>%
        layout(title = 'US Population in 1975', geo = map_options)

# Interactive ggplot - simply apply function to ggplot object.
set.seed(100)
d <- diamonds[sample(nrow(diamonds), 1000), ]

p <- ggplot(data = d, aes(x = carat, y = price)) +
        geom_point(aes(text = paste('Clarity:', clarity)), size = 4) +
        geom_smooth(aes(col = cut, fill = cut)) + facet_wrap(~ cut)

gg <- ggplotly(p)

# Post plotly graphs
'plotly_POST(gg)'
