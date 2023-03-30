library(gridlayout)
library(shiny)
library(ggplot2)

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

# Chick weights investigated over three panels
ui <- navbarPage(
  title = "Sales Dashboard",
  collapsible = TRUE,
  theme = bslib::bs_theme(),
  tabPanel(
    title = "Main",
    grid_container(
      layout = c(
        "area0 area1 area2",
        "area0 area1 area3"
      ),
      row_sizes = c(
        "0.36fr",
        "1.64fr"
      ),
      col_sizes = c(
        "0.53fr",
        "1.23fr",
        "1.24fr"
      ),
      gap_size = "1rem",
      grid_card(
        area = "area0",
        sliderInput(
          inputId = "mySlider",
          label = "Slider Input",
          min = 0L,
          max = 10L,
          value = 5L,
          width = "100%"
        ),
        checkboxGroupInput(
          inputId = "myCheckboxGroup",
          label = "Checkbox Group",
          choices = list(
            Mountain = "Mountain",
            Road = "Road"
          )
        )
      ),
      grid_card(
        area = "area1",
        plotlyOutput(
          outputId = "geospatial_plot",
          width = "100%",
          height = "400px"
        )
      ),
      grid_card(
        area = "area2",
        radioButtons(
          inputId = "myRadioButtons",
          label = "Radio Buttons",
          choices = list(
            D = "day",
            W = "weekly",
            M = "monthly",
            Q = "quarterly"
          )
        )
      ),
      grid_card(
        area = "area3",
        plotlyOutput(
          outputId = "timeseries_plot",
          width = "100%",
          height = "400px"
        )
      )
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # USER SELECTIONS ----
  
  processed_data_filtered_tbl <- reactive({
    
    processed_data_tbl %>%
      
      # Input 1
      filter(order.date %>% between(
        left  = as_date("2011-01-01"),
        right = as_date("2016-01-01"))
      ) %>%
      
      # Input 2
      filter(category_1 %in% "Mountain")  
    
  })
    
  # Output PLotly PLot Geospatial ---- 
  output$geospatial_plot <- renderPlotly({
    
    processed_data_filtered_tbl() %>%
      
      aggregate_geospatial() %>%
      plot_geospatial()
    
  })
  
  # Output Plotly Time Series Plot ----
  output$timeseries_plot <- renderPlotly({
    
    processed_data_filtered_tbl() %>%
      aggregate_time_series(time_unit = "monthly") %>%
      plot_time_series()
 
   })
}

shinyApp(ui, server)
