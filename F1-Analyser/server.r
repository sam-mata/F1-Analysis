library(shiny)
library(dplyr)
library(ggplot2)
library(tidyr)

# Define the server logic
server <- function(input, output) {
    ### SEASON TAB

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

    # Feature plot
    output$featureOverSeasonPlot <- renderPlot({
        season <- input$season
        championship <- input$championship
        feature <- input$feature

        if (championship == "Drivers") {
            # Filter data for the selected season
            season_results <- results %>%
                inner_join(races, by = "raceId") %>%
                filter(year == season) %>%
                inner_join(drivers, by = "driverId")

            # Prepare data for the line chart
            driver_feature_data <- season_results %>%
                group_by(driverId, round) %>%
                summarize(feature_value = case_when(
                    feature == "Points" ~ sum(points),
                    feature == "Race Wins" ~ sum(ifelse(position == 1, 1, 0)),
                    feature == "Podiums" ~ sum(ifelse(position %in% c(1, 2, 3), 1, 0)),
                    feature == "Finishes" ~ sum(ifelse(statusId == 1, 1, 0))
                )) %>%
                group_by(driverId) %>%
                mutate(cumulative_value = cumsum(feature_value)) %>%
                left_join(drivers, by = "driverId")

            # Create the line chart
            ggplot(driver_feature_data, aes(x = round, y = cumulative_value, group = driverId, color = paste(forename, surname))) +
                geom_line() +
                xlab("Race") +
                ylab(feature) +
                ggtitle(paste("Driver", feature, "in", season)) +
                theme(legend.position = "bottom") +
                guides(color = guide_legend(title = "Driver"))
        } else {
            # Filter data for the selected season
            season_results <- results %>%
                inner_join(races, by = "raceId") %>%
                filter(year == season) %>%
                inner_join(constructors, by = "constructorId")

            # Prepare data for the line chart
            constructor_feature_data <- season_results %>%
                group_by(constructorId, round) %>%
                summarize(feature_value = case_when(
                    feature == "Points" ~ sum(points),
                    feature == "Race Wins" ~ sum(ifelse(position == 1, 1, 0)),
                    feature == "Podiums" ~ sum(ifelse(position %in% c(1, 2, 3), 1, 0)),
                    feature == "Finishes" ~ sum(ifelse(statusId == 1, 1, 0))
                )) %>%
                group_by(constructorId) %>%
                mutate(cumulative_value = cumsum(feature_value)) %>%
                left_join(constructors, by = "constructorId")

            # Create the line chart
            ggplot(constructor_feature_data, aes(x = round, y = cumulative_value, group = constructorId, color = name)) +
                geom_line() +
                xlab("Race") +
                ylab(feature) +
                ggtitle(paste("Constructor", feature, "in", season)) +
                theme(legend.position = "bottom") +
                guides(color = guide_legend(title = "Constructor"))
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

    ### DRIVER TAB
    observeEvent(input$searchButton, {
        driver_name <- input$driverSearch
        driver_info <- drivers %>%
            filter(grepl(driver_name, paste(forename, surname), ignore.case = TRUE)) %>%
            select(driverId, forename, surname, dob, nationality)

        if (nrow(driver_info) > 0) {
            output$driverDetails <- renderPrint({
                driver_info
            })

            # Create the driver points chart
            driver_points <- results %>%
                inner_join(races, by = "raceId") %>%
                filter(driverId == driver_info$driverId) %>%
                group_by(year, constructorId) %>%
                summarize(points = sum(points)) %>%
                left_join(constructors, by = "constructorId")

            output$driverPointsChart <- renderPlot({
                ggplot(driver_points, aes(x = year, y = points, fill = name)) +
                    geom_bar(stat = "identity") +
                    xlab("Season") +
                    ylab("Points") +
                    ggtitle(paste("Points Scored by", driver_info$forename, driver_info$surname)) +
                    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
                    labs(fill = "Constructor")
            })

            driver_status <- results %>%
                filter(driverId == driver_info$driverId) %>%
                left_join(status, by = "statusId") %>%
                group_by(status) %>%
                summarize(count = n()) %>%
                mutate(percentage = count / sum(count) * 100)

            output$driverStatusPie <- renderPlot({
                ggplot(driver_status, aes(x = "", y = percentage, fill = status)) +
                    geom_bar(width = 1, stat = "identity") +
                    coord_polar("y", start = 0) +
                    theme_void() +
                    scale_fill_discrete(name = "Status") +
                    ggtitle(paste("Status Distribution for", driver_info$forename, driver_info$surname)) +
                    theme(plot.title = element_text(hjust = 0.5))
            })
        } else {
            output$driverDetails <- renderPrint({
                "Driver not found."
            })

            # Clear the driver points chart
            output$driverPointsChart <- renderPlot({})
        }
    })

    ### CONSTRUCTOR TAB
    observeEvent(input$constructorSearchButton, {
        constructor_name <- input$constructorSearch
        constructor_info <- constructors %>%
            filter(grepl(constructor_name, name, ignore.case = TRUE))

        if (nrow(constructor_info) > 0) {
            output$constructorDetails <- renderPrint({
                constructor_info
            })

            # Create the constructor points chart
            constructor_points <- results %>%
                inner_join(races, by = "raceId") %>%
                filter(constructorId == constructor_info$constructorId) %>%
                group_by(year, driverId) %>%
                summarize(points = sum(points)) %>%
                left_join(drivers, by = "driverId")

            output$constructorPointsChart <- renderPlot({
                ggplot(constructor_points, aes(x = year, y = points, fill = paste(forename, surname))) +
                    geom_bar(stat = "identity") +
                    xlab("Season") +
                    ylab("Points") +
                    ggtitle(paste("Points Scored by", constructor_info$name)) +
                    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
                    labs(fill = "Driver")
            })
        } else {
            output$constructorDetails <- renderPrint({
                "Constructor not found."
            })

            # Clear the constructor points chart
            output$constructorPointsChart <- renderPlot({})
        }
    })
}
