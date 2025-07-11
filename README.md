# [F1-Analysis](https://sammata.shinyapps.io/f1-app/)

An interactive web app for creating custom Formula 1 visualisations.

> [!WARNING]  
> This project is archived and no longer worked on.
---

## 1. Gallery

<img src="https://github.com/sam-mata/F1-Analysis/assets/49130157/0fa15cb8-8392-4255-ae16-f0d419177e36" width="23%"></img> <img src="https://github.com/sam-mata/F1-Analysis/assets/49130157/ca520784-a384-44e0-94af-19d8b032b3de" width="23%"></img> <img src="https://github.com/sam-mata/F1-Analysis/assets/49130157/1426596e-f1d7-4397-9965-00444f8b3a8b" width="23%"></img> <img src="https://github.com/sam-mata/F1-Analysis/assets/49130157/941f7195-888e-4569-becb-bf3b6a13ff2b" width="23%"></img> <img src="https://github.com/sam-mata/F1-Analysis/assets/49130157/2c01138a-462e-4133-be07-4eed83b26ff3" width="23%"></img> <img src="https://github.com/sam-mata/F1-Analysis/assets/49130157/b09b0dcd-5acc-4c0f-96bd-1c84fec580f2" width="23%"></img> <img src="https://github.com/sam-mata/F1-Analysis/assets/49130157/03c770dd-ef91-45e8-aff1-478ba1307efa" width="23%"></img> <img src="https://github.com/sam-mata/F1-Analysis/assets/49130157/caec56ce-d99f-4c8c-ad2d-1e6282d8d6a1" width="23%"></img>

---

## 2. Overview

This repository holds the code and development reporting for an interactive web app. Specifically, the app allows for custom visualisations of various aspects of Formula 1 _(F1)_ data.

---

## 3. Dependencies & Installation

This project is written in [R](https://www.r-project.org/other-docs.html), and utilizes several R packages:

| **LIBRARY**      | **USAGE**                                       | **DOCS**                                                               |
| ---------------- | ----------------------------------------------- | ---------------------------------------------------------------------- |
| `shiny`          | Framework for building web applications with R. | (link)[https://www.rdocumentation.org/packages/shiny/versions/1.8.1.1] |
| `shinydashboard` | Additional user interface controls for Shiny.   | (link)[https://rstudio.github.io/shinydashboard/index.html]            |
| `dplyr`          | Data manipulation functions.                    | (link)[https://www.rdocumentation.org/packages/dplyr/versions/1.0.10]  |
| `ggplot2`        | Plotting library for outputting visualisations. | (link)[https://ggplot2.tidyverse.org/reference/]                       |
| `tidyr`          | Data management functions.                      | (link)[https://www.rdocumentation.org/packages/tidyr/versions/1.3.1]   |

These can be installed together with:

```R
install.packages(c("shiny", "shinydashboard", "dplyr", "ggplot2", "tidyr"))
```

---

## 4. Usage

The current site can be accessed live [here](https://sammata.shinyapps.io/f1-app/).

Alternatively, the project can be run locally _(after downloading the project and installing the required packages)_ with the following command:

```R
runApp("F1-Analyser/global.r", port = 1234, launch.browser = TRUE)
```

---

## 5. Repository

This project contains 3 R files, the several previously described data files, and some deployment files, including:

-   `global.r` – Main project file to be run, loads data and sub-files to be compiled into the application.
-   `ui.r` – Describes the various user interface (UI) elements for input selection and graphing output.
-   `server.r` – Takes selected input features and calculates corresponding outputs.
-   `~.csv` – Various .csv files from the dataset.
-   `/rsconnect/` - Directory for deployment configurations.

---

## 6. Dataset

This project uses the [Formula 1 World Championship (1950 – 2023)](https://www.kaggle.com/datasets/rohanrao/formula-1-world-championship-1950-2020) dataset made publicly available on [Kaggle](https://www.kaggle.com/). This dataset extensively details data on all races, drivers, constructors, qualifying sessions, race sessions, circuits, lap times, pit stops, and championships from 1950 _(F1’s inaugural season)_ to 2023 _(The most recent complete season)_. The data is compiled from the commonly used community-run [Ergast API](https://ergast.com/mrd/), which is updated live as seasons progress.

This project uses a subset of this dataset as follows:
| **File Name** | **Features _(Including IDs)_** |
|---------------------------|---------------------------------------------------------------|
| `constructor_standings.csv` | raceId, constructorId, points, position |
| `constructors.csv` | constructorId, name, nationality |
| `driver_standings.csv` | raceId, driverId, points, position |
| `drivers.csv` | driverId, forename, surname, dob, nationality |
| `races.csv` | raceId, year, round |
| `results.csv` | resultId, raceId, driverId, constructorId, position, points, statusId |

---

## 7. Authorship

All project development completed by [**Sam Mata**](https://www.sammata.nz/) as part of a final project submission for the postgraduate programming project for [**DATA-472**](https://sms.wgtn.ac.nz/Courses/DATA202_2024T1/400Level).
