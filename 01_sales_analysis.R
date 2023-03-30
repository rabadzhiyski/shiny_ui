# LEARNING LAB 79: SHINY NEW FEATURES ----
# PART 2: SHINY UI EDITOR ----
# COPYRIGHT BUSINESS SCIENCE UNIVERSITY ----

# PREREQUISITE PACKAGES (NOT ON CRAN)

# remotes::install_github("mdancho84/gridlayout")
# remotes::install_github("mdancho84/shinyuieditor")


# LIBRARIES ----

# Core
library(tidyverse)
library(tidyquant)
library(here)
library(plotly)
library(timetk)

# SCRIPTS ----
source(here::here("00_scripts/utilities.R"))

# Data
processed_data_tbl <- read_csv(here::here("00_data/bike_sales_data.csv"))
processed_data_tbl


# USER SELECTIONS ----

processed_data_filtered_tbl <- processed_data_tbl %>%
    
    # Input 1
    filter(order.date %>% between(
        left  = as_date("2011-01-01"),
        right = as_date("2016-01-01"))
    ) %>%
    
    # Input 2
    filter(category_1 %in% "Mountain")  

# VISUALIZATION 1 ----

processed_data_filtered_tbl %>%
    aggregate_geospatial() %>%
    plot_geospatial()

# VISUALIZATION 2 ----

# Input 3
processed_data_filtered_tbl %>%
    aggregate_time_series(time_unit = "monthly") %>%
    plot_time_series()
