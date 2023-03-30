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
source(here::here("00_themes/THEME_SPECIALIZED.R"))
source(here::here("00_scripts/utilities.R"))

# DATA ----
processed_data_tbl <- read_csv(here::here("00_data/bike_sales_data.csv"))
processed_data_tbl

# Chick weights investigated over three panels
ui <- navbarPage(
  title = specialized_title,
  # arrange the logo
  tags$head(
    tags$style(HTML(
      "
      .navbar-brand {
      display: flex;
      }
      "
    ))
    ),
  collapsible = TRUE,
  theme = app_theme,
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
          inputId = "date_range",
          label = h3("Date Range"),
          min = as_date("2011-01-01"),
          max = as_date("2016-01-01"),
          value = as_date("2011-01-01"),
          width = "100%"
        ),
        checkboxGroupInput(
          inputId = "category_1",
          label = h3("Product Category"),
          choices = list(
            Mountain = "Mountain",
            Road = "Road"
          ),
          selected = c("Mountain", "Road")
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
          inputId = "time_unit",
          label = h3("Time Unit"),
          choices = list(
            D = "day",
            W = "weekly",
            M = "monthly",
            Q = "quarterly"
          ),
          selected = "monthly",
          inline = TRUE
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
        left  = input$date_range,
        right = as_date("2016-01-01"))
      ) %>%
      
      # Input 2
      filter(category_1 %in% input$category_1)  
    
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
      aggregate_time_series(time_unit = input$time_unit) %>%
      plot_time_series()
 
   })
}

shinyApp(ui, server)
