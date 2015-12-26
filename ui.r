library(dplyr)
library(shiny)
library(plotly)

shinyUI(navbarPage("Washington DC Airport Analytics",
  
  tabPanel("Main",
  
  fluidRow(
    column(width = 12,
           radioButtons("APRadio", label = h4("Select Airport:"), 
                        choices = list("Washington Dulles International (IAD)" = "IAD", "Ronald Reagan Washington National (DCA)" = "DCA", "Baltimore-Washington International (BWI)" = "BWI"),
                        selected = "IAD", inline = TRUE),
           hr(),
           plotlyOutput("FltbyDayPlot")
    )
  ),
  
  fluidRow(
    column(width = 6,
           plotlyOutput("FltTop10")
    ),   
    
    column(width = 6,
           selectInput("MonSel", label = h4("Select Month:"), 
                       choices = list("January"=1, "February"=2, "March"=3,"April"=4, "May"=5, "June"=6, "July"=7, "August"=8, "September"=9,"October"=10, "November"=11, "December"=12), 
                       selected = 1),
           plotlyOutput("FltbyWeek")
    )
  )  
  
  ), ## -- end tabPanel("Main")
  
  tabPanel("Getting Started",
           #includeHTML("GettingStartedAPA.html")
           includeMarkdown("GettingStartedAPA.md")
           #verbatimTextOutput('text1')
  )
  
  
))