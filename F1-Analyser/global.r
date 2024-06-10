# app.R

library(shiny)
library(shinydashboard)

# Read the necessary data files
drivers <- read.csv("drivers.csv")
constructors <- read.csv("constructors.csv")
results <- read.csv("results.csv")
races <- read.csv("races.csv")
driver_standings <- read.csv("driver_standings.csv")
constructor_standings <- read.csv("constructor_standings.csv")
status <- read.csv("status.csv")

# Build the app
ui <- source("ui.r")$value
server <- source("server.r")$value
shinyApp(ui = ui, server = server)
