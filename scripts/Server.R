# Define the server logic
server <- function(input, output) {
    # Championship plot
    output$championshipPlot <- renderPlot({
        season <- input$season
        feature <- input$feature
        championship <- input$championship

        # Filter data for the selected season
        season_results <- results %>%
            inner_join(races, by = "raceId") %>%
            filter(year == season)

        if (championship == "Drivers") {
            # Calculate the selected feature for each driver
            driver_data <- season_results %>%
                group_by(driverId, constructorId) %>%
                summarize(
                    points = sum(points),
                    wins = sum(ifelse(position == 1, 1, 0)),
                    podiums = sum(ifelse(position %in% c(1, 2, 3), 1, 0)),
                    finishes = sum(ifelse(statusId == 1, 1, 0))
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
                    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
                    labs(fill = "Team")
            } else if (feature == "Race Wins") {
                ggplot(driver_data, aes(x = reorder(paste(forename, surname), -wins), y = wins, fill = name)) +
                    geom_bar(stat = "identity") +
                    xlab("Driver") +
                    ylab("Race Wins") +
                    ggtitle(paste("Driver Race Wins in", season)) +
                    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
                    labs(fill = "Team")
            } else if (feature == "Podiums") {
                ggplot(driver_data, aes(x = reorder(paste(forename, surname), -podiums), y = podiums, fill = name)) +
                    geom_bar(stat = "identity") +
                    xlab("Driver") +
                    ylab("Podiums") +
                    ggtitle(paste("Driver Podiums in", season)) +
                    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
                    labs(fill = "Team")
            } else {
                ggplot(driver_data, aes(x = reorder(paste(forename, surname), -finishes), y = finishes, fill = name)) +
                    geom_bar(stat = "identity") +
                    xlab("Driver") +
                    ylab("Finishes") +
                    ggtitle(paste("Driver Finishes in", season)) +
                    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
                    labs(fill = "Team")
            }
        } else {
            # Calculate the selected feature for each constructor
            constructor_data <- season_results %>%
                group_by(constructorId) %>%
                summarize(
                    points = sum(points),
                    wins = sum(ifelse(position == 1, 1, 0)),
                    podiums = sum(ifelse(position %in% c(1, 2, 3), 1, 0)),
                    finishes = sum(ifelse(statusId == 1, 1, 0))
                ) %>%
                left_join(constructors, by = "constructorId")

            # Create the plot based on the selected feature
            if (feature == "Points") {
                ggplot(constructor_data, aes(x = reorder(name, -points), y = points, fill = name)) +
                    geom_bar(stat = "identity") +
                    xlab("Constructor") +
                    ylab("Points") +
                    ggtitle(paste("Constructor Points in", season)) +
                    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
                    labs(fill = "Constructor")
            } else if (feature == "Race Wins") {
                ggplot(constructor_data, aes(x = reorder(name, -wins), y = wins, fill = name)) +
                    geom_bar(stat = "identity") +
                    xlab("Constructor") +
                    ylab("Race Wins") +
                    ggtitle(paste("Constructor Race Wins in", season)) +
                    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
                    labs(fill = "Constructor")
            } else if (feature == "Podiums") {
                ggplot(constructor_data, aes(x = reorder(name, -podiums), y = podiums, fill = name)) +
                    geom_bar(stat = "identity") +
                    xlab("Constructor") +
                    ylab("Podiums") +
                    ggtitle(paste("Constructor Podiums in", season)) +
                    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
                    labs(fill = "Constructor")
            } else {
                ggplot(constructor_data, aes(x = reorder(name, -finishes), y = finishes, fill = name)) +
                    geom_bar(stat = "identity") +
                    xlab("Constructor") +
                    ylab("Finishes") +
                    ggtitle(paste("Constructor Finishes in", season)) +
                    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
                    labs(fill = "Constructor")
            }
        }
    })

    # Championship standings plot
    output$championshipStandingsPlot <- renderPlot({
        season <- input$season
        championship <- input$championship

        if (championship == "Drivers") {
            # Filter data for the selected season
            season_standings <- driver_standings %>%
                inner_join(races, by = "raceId") %>%
                filter(year == season) %>%
                inner_join(drivers, by = "driverId")

            # Prepare data for the line chart
            driver_standings_data <- season_standings %>%
                select(driverId, raceId, position) %>%
                spread(driverId, position) %>%
                left_join(races %>% select(raceId, round), by = "raceId") %>%
                arrange(round) %>%
                gather(driverId, position, -raceId, -round) %>%
                mutate(driverId = as.numeric(driverId)) %>%
                left_join(drivers, by = "driverId")

            # Create the line chart
            ggplot(driver_standings_data, aes(x = round, y = -position, group = driverId, color = paste(forename, surname))) +
                geom_line() +
                xlab("Race") +
                ylab("Position") +
                ggtitle(paste("Driver Standings in", season)) +
                theme(legend.position = "bottom") +
                guides(color = guide_legend(title = "Driver"))
        } else {
            # Filter data for the selected season
            season_standings <- constructor_standings %>%
                inner_join(races, by = "raceId") %>%
                filter(year == season) %>%
                inner_join(constructors, by = "constructorId")

            # Prepare data for the line chart
            constructor_standings_data <- season_standings %>%
                select(constructorId, raceId, position) %>%
                spread(constructorId, position) %>%
                left_join(races %>% select(raceId, round), by = "raceId") %>%
                arrange(round) %>%
                gather(constructorId, position, -raceId, -round) %>%
                mutate(constructorId = as.numeric(constructorId)) %>%
                left_join(constructors, by = "constructorId")

            # Create the line chart
            ggplot(constructor_standings_data, aes(x = round, y = -position, group = constructorId, color = name)) +
                geom_line() +
                xlab("Race") +
                ylab("Position") +
                ggtitle(paste("Constructor Standings in", season)) +
                theme(legend.position = "bottom") +
                guides(color = guide_legend(title = "Constructor"))
        }
    })
}
