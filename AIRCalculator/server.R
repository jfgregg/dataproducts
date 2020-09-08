#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(plotly)
library(ggplot2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    
    model <- reactive({
        
            time <- NULL
            
            # calculate the volume of the room
            vol  <- input$Area*input$Height
            
            # set the IVRR
            IVRR <- 1.4
            
            # Based on activity select Eq and Iq
            if(input$Activity == "Resting"){
                EQ = 9.49
                IQ = 0.49
            }
            if(input$Activity == "Standing"){
                EQ = 11.5
                IQ = 0.54
            }
            if(input$Activity == "Light Exercise"){
                EQ = 26.5
                IQ = 1.38
            }
            if(input$Activity == "Heavy Exercise"){
                EQ = 63.7
                IQ = 3.3
            }
            
            #Expected number of infected people
            expinf <- input$Occupants*(input$Prob/100000)*(1-input$Prob/100000)
            
            time <- seq(0,8,by = 1/60)
            
            model <- data.frame(time) %>%
                mutate(quanta = (EQ/(IVRR*vol))*(1-exp(-IVRR*time))) %>%
                mutate(totalquanta = quanta*expinf) %>%
                mutate(ndt = totalquanta/60) %>%
                mutate(cumndt = cumsum(ndt)) %>%
                mutate(risk = 15*(1-exp(-IQ*cumndt)))
    })
            
    output$riskplot <- renderPlotly({
                
        # draw the risk versus time graph
        g <- ggplot(data = model(), aes(x = time, y = risk))
        g <- g + geom_point(colour = "red", shape = 4, size = 0.1)
        g <- g + xlab("Time (hours)") + ylab("Risk %")
        g <- g + geom_vline(xintercept = input$duration/60, linetype = "dashed")
        ggplotly(g)
    })

    output$timerisk <- renderText({
        
        timestep <- input$duration + 1
        risk <- round(model()$risk[timestep],3)
        timerisk <- paste("The risk after", as.character(input$duration), "minutes is ", as.character(risk), "%")
    })

    output$tenrisk <- renderText({
        
        timestep <- input$duration + 1
        risk <- round(1 - pbinom(prob = (model()$risk[timestep]/100),0,size = 10),3)*100
        tenrisk <- paste("The risk of infection if you do this activity 10 times is", as.character(risk), "%")
    })
    
    output$oneprisk <- renderText({
        
        timestep <- input$duration + 1
        onep <- round(log(0.99, base = (1-model()$risk[timestep]/100)),0)
        oneprisk <- paste("In order to have a risk of infection of 1% you must do this activity", onep, "times")
    })
    
       
})
