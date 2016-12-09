library(shiny)
library(plotly)
pollutants <- 1:16
names(pollutants) <- c('Barium', 'Beryllium', 'Cadmium', 'Calcium', 'Chromium', 'Copper',
                        'Iron', 'Lead', 'Manganese', 'Molybdenum', 'Nickel', 'Vanadium', 'Zinc',
                        'Sulfur dioxide', 'Carbon monoxide', 'Ozone')
shinyUI(fluidPage(
        titlePanel('Gas and Metal Dust Pollutions in the US'),
        h4('Guang Yang'),
        h4('December, 9, 2016'),
        br(),
        h3('Introduction to the Web Application'),
        h5('This web application visualizes the air pollutions in the US by state. 
           The raw data are from EPA webpage. The left panel below allows to select
           the specific graph to look at:'),
        h5(' - The slider on top part of the panel serves to browse through the selected 
           data in one year, ranging between 1990 and 2016.'),
        h5(' - The drop down box provides 16 specific pollutant types to be plotted, 
           in the year selected by the slider bar above.'),
        h5("The right plot area displays the data plot with the selected variables. 
           The pollution levels are represented by deepness of the blue color (with 
           the bar legend on the right of graph). The title tells the pollutant type, 
           year, and unit of pollutant concentration. Hovering the cursor onto the 
           territory of each state in the map will show up a box with relevant info: 
           state name, mean pollution level (average of multiple monitoring sites in 
           the state), and number of sites in the state. Note some states have no sites 
           and their levels are shown as 'NA', while some other states don't show 
           statistics due to completely lack of data."),
        
        sidebarLayout(
                sidebarPanel(
                        sliderInput('SliderYear', h3('Slide to select year:'),
                                    1990, 2016, value = 2016),
                        selectInput('SelectPol',
                                     label = h3('Click to select pollutant type:'),
                                     choices = pollutants,
                                     selected = 1)
                ),
                mainPanel(
                        plotlyOutput('plot')
                )
        ),
        h5('For more information regarding Air Quality division of the Environmental 
           Protection Agency, please follow below link to the webpage:'),
        a(href = 'https://www.epa.gov/outdoor-air-quality-data', 'EPA Air Quality'),
        br(),
        h5('For more information regarding sources of raw data, please follow below 
           links to the webpages:'),
        a(href = 'https://aqsdr1.epa.gov/aqsweb/aqstmp/airdata/download_files.html', 'EPA Data Download'),
        a(href = 'https://aqsdr1.epa.gov/aqsweb/aqstmp/airdata/FileFormats.html#_annual_summary_files',
          'EPA Data Documentation'),
        br(),
        h5('For more information regarding codes of data processing and web app construction, 
           please follow below links to the Github repo:'),
        a(href = 'https://github.com/imreyes/datasciencecoursera/tree/master/DevelopingDataProduct/Week4_ProgrammingAssignment',
          'Github repo'),
        br(),
        h5('To contact the web app author, please email to:'),
        h4('guangyang11231987@gmail.com'),
        br(),
        h3('Thank you!')
))