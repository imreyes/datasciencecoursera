#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

shinyUI(fluidPage(
        titlePanel('Tabs!'),
        sidebarLayout(
                sidebarPanel(
                        textInput('box1', 'Enter Tab1 Text:', value = 'Tab 1!'),
                        textInput('box2', 'Enter Tab2 Text:', value = 'Tab 2!'),
                        textInput('box3', 'Enter Tab3 Text:', value = 'Tab 3!')
                ),
                mainPanel(
                        tabsetPanel(type = 'tabs',
                                tabPanel('Tab 1', br(), textOutput('out1')),
                                tabPanel('Tab 2', br(), textOutput('out2')),
                                tabPanel('Tab 3', br(), textOutput('out3'))
                        )
                )
        )
))