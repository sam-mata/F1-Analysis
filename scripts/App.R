library(shiny)
library(dplyr)
library(ggplot2)

# Read the necessary ../data files
drivers <- read.csv("../data/drivers.csv")
constructors <- read.csv("../data/constructors.csv")
results <- read.csv("../data/results.csv")
races <- read.csv("../data/races.csv")

# Define the UI
ui <- fluidPage(
    titlePanel("Formula 1 Analysis"),
    tabsetPanel(
        tabPanel(
            "Drivers",
            sidebarLayout(
                sidebarPanel(
                    selectInput("season", "Select Season", choices = unique(races$year)),
                    selectInput("feature", "Select Feature", choices = c("Points", "Race Wins"))
                ),
                mainPanel(
                    plotOutput("driverPlot")
                )
            )
        ),
        tabPanel(
            "Constructors",
            # Add constructor tab content here
            "Constructor tab content goes here"
        )
    )
)

# Define the server logic
server <- function(input, output) {
    # Driver tab plot
    output$driverPlot <- renderPlot({
        season <- input$season
        feature <- input$feature

        # Filter data for the selected season
        season_results <- results %>%
            inner_join(races, by = "raceId") %>%
            filter(year == season)

        # Calculate the selected feature for each driver
        driver_data <- season_results %>%
            group_by(driverId, constructorId) %>%
            summarize(
                points = sum(points),
                wins = sum(ifelse(position == 1, 1, 0))
            ) %>%
            left_join(drivers, by = "driverId") %>%
            left_join(constructors, by = "constructorId")

        # Create the plot based on the selected feature
        if (feature == "Points") {
            ggplot(driver_data, aes(x = reorder(paste(forename, surname), -points), y = points, fill = name)) +
                geom_bar(stat = "identity") +
                xlab("Driver") +
                ylab("Points") +
                ggtitle(paste("Driver Points in", season)) +
                theme(axis.text.x = element_text(angle = 45, hjust = 1))
        } else {
            ggplot(driver_data, aes(x = reorder(paste(forename, surname), -wins), y = wins, fill = name)) +
                geom_bar(stat = "identity") +
                xlab("Driver") +
                ylab("Race Wins") +
                ggtitle(paste("Driver Race Wins in", season)) +
                theme(axis.text.x = element_text(angle = 45, hjust = 1))
        }
    })
}

# Run the app
shinyApp(ui = ui, server = server)
