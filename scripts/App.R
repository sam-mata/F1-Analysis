# app.R

library(shiny)
library(shinydashboard)

source("loading.R")
ui <- source("ui.R")$value
server <- source("server.R")$value

shinyApp(ui = ui, server = server)
