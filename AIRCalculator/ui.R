#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Airborne Infection Risk"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            numericInput("Area",
                        "Room Area (m^2):",
                        min = 1,
                        max = 2000,
                        value = 200),
            numericInput("Height",
                         "Ceiling Height (m):",
                         min = 1,
                         max = 10,
                         value = 3),
            numericInput("Occupants",
                         "Number of Occupants:",
                         min = 1,
                         max = 200,
                         value = 20, 
                         step = 1),
            sliderInput("Prob",
                         "Current infection rate (per 100,000 people):",
                         min = 0,
                         max = 10000,
                         value = 100, 
                         step = 1),
            selectInput("Activity",
                        "Activty of Participants",
                        choices = c("Resting", "Standing", "Light Exercise", "Heavy Exercise"), 
                        selected = "Resting"),
            numericInput("duration",
                         "Length of Activity (mins):",
                         min = 1,
                         max = 480,
                         value = 60)
            ),
    
                     
        # Show a plot of the risk over time
        mainPanel(
            tabsetPanel(type = "tabs",
                        tabPanel("Instructions",br(), includeMarkdown("./AIRCalcDocumentation.Rmd")),
                        tabPanel("Risk Plot", br(), plotlyOutput("riskplot")),
                        tabPanel("Repeated Risks", br(), textOutput("timerisk"), 
                                 textOutput("tenrisk"),
                                 textOutput("oneprisk"))
                  )
        )
    ) 
))
