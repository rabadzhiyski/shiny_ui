library(gridlayout)
library(shiny)
library(ggplot2)

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
        plotOutput(
          outputId = "plot",
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
            M = "monthly"
          )
        )
      ),
      grid_card(
        area = "area3",
        plotOutput(
          outputId = "plot",
          width = "100%",
          height = "400px"
        )
      )
    )
  )
)

# Define server logic
server <- function(input, output) {
  output$linePlots <- renderPlot({
    obs_to_include <- as.integer(ChickWeight$Chick) <= input$numChicks
    chicks <- ChickWeight[obs_to_include,]

    ggplot(
      chicks,
      aes(
        x = Time,
        y = weight,
        group = Chick
      )
    ) +
      geom_line(alpha = 0.5) +
      ggtitle("Chick weights over time")
  })

  output$dists <- renderPlot({
    ggplot(
      ChickWeight,
      aes(x = weight)
    ) +
      facet_wrap(~Diet) +
      geom_density(fill = "#fa551b", color = "#ee6331") +
      ggtitle("Distribution of weights by diet")
  })
}

shinyApp(ui, server)
