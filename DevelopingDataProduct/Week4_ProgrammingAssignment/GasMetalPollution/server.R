library(shiny)
library(plotly)

# Fetch the data object from the web.
if(!file.exists('DataGalleryMetal.rda')) {
        Url <- 'https://github.com/imreyes/datasciencecoursera/raw/master/DevelopingDataProduct/Week4_ProgrammingAssignment/DataGalleryGasMetal.rda'
        download.file(Url, destfile = 'DataGalleryGasMetal.rda')
}
load('DataGalleryGasMetal.rda')

shinyServer(function(input, output, session) {
        output$plot <- renderPlotly({
                # Get the subset to plot.
                year <- input$SliderYear - 1989
                pol <- as.integer(input$SelectPol) - 1
                idx <- pol * 4 + 1:4
                plotData <- as.data.frame(data.gallery.all[idx, year])
                names(plotData) <- c('State', 'Mean', 'Num.Monitors', 'hover')
                plotData$Mean[is.na(plotData$Mean)] <- 0
                
                # Make black border between states.
                border <- list(color = toRGB('black'), lwd = 2)
                # Specify Map options.
                opt <- list(scope = 'usa', projection = list(type = 'albers usa'),
                            showlakes = TRUE, lakecolor = toRGB('white'))
                # Specify unit.
                Unit <- if(pol < 13) 'mg/m3' else {ifelse(pol == 13, 'ppb', 'ppm')}
                # Specify pollutant name.
                pols <-  c('Barium', 'Beryllium', 'Cadmium', 'Calcium', 'Chromium', 'Copper',
                                       'Iron', 'Lead', 'Manganese', 'Molybdenum', 'Nickel', 'Vanadium', 'Zinc',
                                       'Sulfur dioxide', 'Carbon monoxide', 'Ozone')
                Title <- paste0(pols[pol + 1], ' Pollution in ', input$SliderYear,
                                ' (Unit: ', Unit, ')')
                
                # Plot map
                plot_ly(z = plotData$Mean, text = plotData$hover, locations = plotData$State,
                        type = 'choropleth', locationmode = 'USA-states',
                        color = plotData$Mean, colors = 'Blues', marker = list(line = border)) %>%
                        layout(title = Title, geo = opt)
                
        })
})