# LEARNING LAB 78: SHINY NEW FEATURES ----
# NIKE THEME ----
# COPYRIGHT BUSINESS SCIENCE UNIVERSITY ----

library(bslib)
library(shiny)

# SPECIALIZED SPECS
TITLE        <- "Sales Dashboard"
LOGO         <- "https://i.pinimg.com/originals/80/52/79/8052793a5b6cb4bc820c893e02035b27.jpg"

FONT_HEADING <- "Changa One"
FONT_BASE    <- "Helvetica Neue"
PRIMARY      <- "black"
SUCCESS      <- "#6ab5da"
INFO         <- "#00F5FB"
WARNING      <- "#ee9c0f"
DANGER       <- "#f06698"
FG           <- "#000000"
BG           <- "#FFFFFF"


app_theme <- bs_theme(
    font_scale   = 1.0,
    heading_font = font_google(FONT_HEADING, wght = c(300, 400, 500, 600, 700, 800), ital = c(0, 1)),
    base_font    = font_google(FONT_BASE, wght = c(300, 400, 500, 600, 700, 800), ital = c(0, 1)),
    primary      = PRIMARY,
    success      = SUCCESS,
    info         = INFO, 
    warning      = WARNING, 
    danger       = DANGER,
    fg           = FG,
    bg           = BG,
    "navbar-bg"  = PRIMARY,
    "body-color" = PRIMARY, 
    "accordion-button-active-bg"    = SUCCESS,
    "accordion-button-active-color" = PRIMARY,
    "bs-accordion-color" = PRIMARY,
    "light" = BG
)

specialized_title <- list(
    tags$img(
        src   = LOGO,
        id    = "logo",
        style = "height:46px;margin-right:24px;-webkit-filter: drop-shadow(5px 5px 5px #222);"
    ),
    h4(TITLE, id = "title")
)