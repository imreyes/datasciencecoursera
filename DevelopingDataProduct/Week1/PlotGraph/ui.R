#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
        titlePanel("Plot Random Numbers"),
  
  # Sidebar with a slider input for number of bins 
        sidebarLayout(
                numericInput('numeric', 'How Many Random Numbers Should be Plotted',
                             value = 1000, min = 1, max = 1000, step = 1),
                sliderInput('sliderX', 'Pick Minimum and Maximum X Values',
                            -100, 100, value = c(-50, 50)),
                sliderInput('sliderY', 'Pick Minimum and Maximum Y Values',
                            -100, 100, value = c(-50, 50)),
                checkboxInput('show_xlab', 'Show/Hide X Axis Label', value = TRUE),
                checkboxInput('show_ylab', 'Show/Hide Y Axis Label', value = TRUE),
                checkboxInput('show_title', 'Show/Hide Title'),
                # Show a plot of the generated distribution
                mainPanel(
                        h3('Graph of Random Points'),
                        plotOutput('plot1')
                        )
  )
))
