library(readr)

circuits <- read_csv("../data/circuits.csv")
constructor_results <- read_csv("../data/constructor_results.csv")
constructor_standings <- read_csv("../data/constructor_standings.csv")
constructors <- read_csv("../data/constructors.csv")
driver_standings <- read_csv("../data/driver_standings.csv")
drivers <- read_csv("../data/drivers.csv")
lap_times <- read_csv("../data/lap_times.csv")
pit_stops <- read_csv("../data/pit_stops.csv")
qualifying <- read_csv("../data/qualifying.csv")
races <- read_csv("../data/races.csv")
results <- read_csv("../data/results.csv")
seasons <- read_csv("../data/seasons.csv")
sprint_results <- read_csv("../data/sprint_results.csv")
status <- read_csv("../data/status.csv")

server <- function(input, output, session) {
    # Load the data inside the server function
    circuits <- read_csv("data/circuits.csv", show_col_types = FALSE)
    constructor_results <- read_csv("data/constructor_results.csv", show_col_types = FALSE)
    constructor_standings <- read_csv("data/constructor_standings.csv", show_col_types = FALSE)
    constructors <- read_csv("data/constructors.csv", show_col_types = FALSE)
    driver_standings <- read_csv("data/driver_standings.csv", show_col_types = FALSE)
    drivers <- read_csv("data/drivers.csv", show_col_types = FALSE)
    lap_times <- read_csv("data/lap_times.csv", show_col_types = FALSE)
    pit_stops <- read_csv("data/pit_stops.csv", show_col_types = FALSE)
    qualifying <- read_csv("data/qualifying.csv", show_col_types = FALSE)
    races <- read_csv("data/races.csv", show_col_types = FALSE)
    results <- read_csv("data/results.csv", show_col_types = FALSE)
    seasons <- read_csv("data/seasons.csv", show_col_types = FALSE)
    sprint_results <- read_csv("data/sprint_results.csv", show_col_types = FALSE)
    status <- read_csv("data/status.csv", show_col_types = FALSE)

    # Create reactive values
    rv <- reactiveValues()

    # Assign the unique season choices to reactive values
    observe({
        rv$seasonChoices <- unique(races$year)
    })

    standings <- reactive({
        req(input$season)
        if ("Driver Standings" %in% input$standingsType) {
            driver_standings %>%
                filter(raceId %in% races$raceId[races$year == input$season]) %>%
                left_join(drivers, by = "driverId") %>%
                select(Position = position, Driver = surname, Points = points, Wins = wins)
        } else {
            data.frame()
        }
    })

    constructorStandings <- reactive({
        req(input$season)
        if ("Constructor Standings" %in% input$standingsType) {
            constructor_standings %>%
                filter(raceId %in% races$raceId[races$year == input$season]) %>%
                left_join(constructors, by = "constructorId") %>%
                select(Position = position, Constructor = name, Points = points, Wins = wins)
        } else {
            data.frame()
        }
    })

    output$standingsTable <- renderDataTable({
        req(input$season)
        rbind(standings(), constructorStandings())
    })

    output$raceResultsTable <- renderDataTable({
        req(input$season)
        results %>%
            filter(raceId %in% races$raceId[races$year == input$season]) %>%
            left_join(drivers, by = "driverId") %>%
            left_join(constructors, by = "constructorId") %>%
            select(Race = name.y, Driver = surname, Constructor = name.x, Grid = grid, Position = position, Points = points)
    })

    # Pass season choices to UI
    output$seasonChoices <- renderUI({
        selectInput("season", "Select Season", choices = rv$seasonChoices)
    })
}
