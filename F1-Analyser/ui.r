library(dplyr)
library(ggplot2)
library(tidyr)

dashboardPage(
    dashboardHeader(title = "Formula 1 Analysis"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Season", tabName = "season", icon = icon("calendar")),
            menuItem("Driver", tabName = "driver", icon = icon("user")),
            menuItem("Constructor", tabName = "constructor", icon = icon("building"))
        )
    ),
    dashboardBody(
        tabItems(
            # Season tab
            tabItem(
                tabName = "season",
                fluidRow(
                    box(
                        title = "Filters",
                        selectInput("championship", "Select Championship", choices = c("Drivers", "Constructors")),
                        selectInput("season", "Select Season", choices = unique(races$year)),
                        selectInput("feature", "Select Feature", choices = c("Points", "Race Wins", "Podiums", "Finishes"))
                    ),
                    box(
                        title = "Championship Plot",
                        plotOutput("championshipPlot")
                    ),
                    box(
                        title = "Feature Over Season",
                        plotOutput("featureOverSeasonPlot")
                    ),
                    box(
                        title = "Championship Standings Plot",
                        plotOutput("championshipStandingsPlot")
                    )
                )
            ),
            # Driver tab
            tabItem(
                tabName = "driver",
                fluidRow(
                    box(
                        title = "Driver Search",
                        textInput("driverSearch", "Enter driver name:", ""),
                        actionButton("searchButton", "Search")
                    ),
                    box(
                        title = "Driver Details",
                        verbatimTextOutput("driverDetails")
                    ),
                    box(
                        title = "Driver Points by Season",
                        plotOutput("driverPointsChart")
                    ),
                    box(
                        title = "Driver Status Distribution",
                        plotOutput("driverStatusPie")
                    )
                )
            ),
            # Constructor tab
            tabItem(
                tabName = "constructor",
                fluidRow(
                    box(
                        title = "Constructor Search",
                        textInput("constructorSearch", "Enter constructor name:", ""),
                        actionButton("constructorSearchButton", "Search")
                    ),
                    box(
                        title = "Constructor Details",
                        verbatimTextOutput("constructorDetails")
                    ),
                    box(
                        title = "Constructor Points by Driver",
                        plotOutput("constructorPointsChart")
                    )
                )
            )
        )
    )
)
