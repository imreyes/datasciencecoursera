# First example

library(leaflet)
library(dplyr)

# World Map
my_map <- leaflet() %>%
        addTiles()
my_map
addTiles(leaflet())

# Add marker
my_map <- addMarkers(my_map, lat = 39.2980803, lng = -76.5898802,
                     popup = "Jeff Leak's Office")
my_map

# Add multiple markers using data frame.
df <- data.frame(lat = runif(20, min = 39.2, max = 39.4),
                 lng = runif(20, min = -76.6, max = -76.5))

addMarkers(addTiles(leaflet(df)))       # Markers as a data frame are added to leaflet().
addMarkers(addTiles(leaflet(data.frame(lat = 39.2980803, lng = -76.5898802))))
# Pipeline notation
df %>% leaflet() %>% addTiles() %>%
        addMarkers()

# Making custom markers.
hopkinsIcon <- makeIcon(
        iconUrl = 'https://lh4.googleusercontent.com/-vt0qVScbeaE/AAAAAAAAAAI/AAAAAAAAAZY/PJXCeqlyXc0/s0-c-k-no-ns/photo.jpg',
        iconWidth = 31*215/230, iconHeight = 31,
        iconAnchorX = 31*215/230/2, iconAnchorY = 16
)
# Define locations with data frame.
hopkinsLatLong <- data.frame(
        lat = c(39.2973166, 39.3288851, 39.2906617, 39.2970681, 39.2824806),
        lng = c(-76.5929798, -76.6206598, -76.5469683, -76.6150537, -76.6016766)
)
# Add popups with links to webpages.
hopkinsSites <- c(
        "<a href='http://www.jhsph.edu/'>East Baltimore Campus</a>",
        "<a href='https://apply.jhu.edu/visit/homewood/'>Homewood Campus</a>",
        "<a href='http://www.hopkinsmedicine.org/johns_hopkins_bayview/'>Bayview Medical Center</a>",
        "<a href='http://www.peabody.jhu.edu/'>Peabody Institute</a>",
        "<a href='http://carey.jhu.edu/'>Carey Businiess School</a>"
)
# Add marker icons and popups (including hyperlinks to webpages).
hopkinsLatLong %>%
        leaflet() %>%
        addTiles() %>%
        addMarkers(icon = hopkinsIcon, popup = hopkinsSites)


# Too many markers?
# Use cluster options.
df <- data.frame(lat = runif(500, min = 39.25, max = 39.35),
                 lng = runif(500, min = -76.65, max = -76.55))
# Fancy automated plot with interactive clusters of points.
df %>%
        leaflet() %>%
        addTiles() %>%
        addMarkers(clusterOptions = markerClusterOptions())

# Mapping Circle Markers
df <- data.frame(lat = runif(20, min = 39.25, 39.35),
                 lng = runif(20, min = -76.65, -76.55))
df %>%
        leaflet() %>%
        addTiles() %>%
        addCircleMarkers(clusterOptions = markerClusterOptions())

# Drawing Circles.
md_cities <- data.frame(name = c('Baltimore', 'Frederick', 'Rockville', 'Gaithersburg',
                                 'Bowie', 'hagerstown', 'Annapolis', 'College Park',
                                 'Salisbury', 'Laurel'),
                        pop = c(619493, 66169, 62334, 61045,
                                55232, 39890, 38880, 30587,
                                30484, 25346),
                        lat = c(39.2920592, 39.4143921, 39.0840, 39.1434,
                                39.0068, 39.6148, 38.9784, 38.9897,
                                38.3607, 39.0993),
                        lng = c(-76.6077852, -77.4204875, -77.1528, -77.2014,
                                -76.7791, -77.7200, -76.4922, -76.9378,
                                -75.5994, -76.8483))
md_cities %>%
        leaflet() %>%
        addTiles() %>%
        addCircles(weight = 1, radius = sqrt(md_cities$pop) * 30)
# Similarly, draw rectangles.
leaflet() %>%
        addTiles() %>%
        addRectangles(lat1 = 37.3858, lng1 = -122.0595,
                      lat2 = 37.3890, lng2 = -122.0625)

# Add legends.
df <- data.frame(lat = runif(20, min = 39.25, max = 39.35),
                 lng = runif(20, min = -76.65, max = -76.55),
                 col = sample(c('red', 'blue', 'green'), 20, replace = TRUE),
                 stringsAsFactors = FALSE)

df %>%
        leaflet() %>%
        addTiles() %>%
        addCircleMarkers(color = df$col, clusterOptions = markerClusterOptions()) %>%
        addLegend(labels = LETTERS[1:3], color = c('blue', 'red', 'green'))
