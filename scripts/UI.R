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
                        title = "Championship Standings Plot",
                        plotOutput("championshipStandingsPlot")
                    )
                )
            ),
            tabItem(
                tabName = "driver",
                "Driver tab content goes here"
            ),
            tabItem(
                tabName = "constructor",
                "Constructor tab content goes here"
            )
        )
    )
)
