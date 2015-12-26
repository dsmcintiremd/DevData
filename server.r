library(dplyr)
library(shiny)
library(plotly)

DCFltperDay      <- read.csv("data/DC2008Day.csv", header = TRUE)
DCFltbyDayofWeek <- read.csv("data/DC2008Week.csv", header = TRUE)
DCFltT10Dest     <- read.csv("data/DC2008Top10.csv", header = TRUE)

MonNme <- c("January","February","March","April","May","June","July","August","September","October","November","December")

minn <- min(DCFltperDay$n)
maxx <- max(DCFltperDay$n)

shinyServer(
  
  function(input, output) {

    #output$text1 <- renderText({input$APRadio})
    
    output$FltbyDayPlot <- renderPlotly({
      totalbyAP <- summarise(filter(DCFltperDay,Origin==input$APRadio),total=sum(n))
      m <- loess(n ~ as.numeric(fltdate), data=filter(DCFltperDay,Origin==input$APRadio))
      p1 <- plot_ly(data=filter(DCFltperDay,Origin==input$APRadio), x = fltdate, y = n, name = "Daily Flights")
      p1 <- layout(p1, title=paste("Flights Departing",input$APRadio,"| Total Flights:",totalbyAP),xaxis=list(title="Flight Date"), yaxis=list(title="Number of Flights",range=c(minn,maxx)))
      add_trace(p1, y = fitted(m), name = "Regression")
    })
   
    output$FltbyWeek <- renderPlotly({
      p2 <- plot_ly(data=filter(DCFltbyDayofWeek,Month==input$MonSel),x=DayName, y=n, group=Origin,type="bar")
      p2 <- layout(p2, title=paste0("Departures by Month For: ",MonNme[as.numeric(input$MonSel)]),xaxis=list(title="Day"), yaxis=list(title="Number of Flights"))
      p2
    })
    
    output$FltTop10 <- renderPlotly({
      p3 <- plot_ly(DCFltT10Dest, x = n.BWI, y = Dest, name = "BWI",
                    mode = "markers", marker = list(color = "blue",size=15))
      p3 <- add_trace(p3, x = n.DCA, name = "DCA", marker = list(color = "red")) 
      p3 <- add_trace(p3, x = n.IAD, name = "IAD", marker = list(color = "green")) 
      p3 <- layout(p3, title = 'Top 10 Destinations 2008',xaxis=list(title="Number of Flights"), yaxis=list(title="Destination"))
      p3
    })
    
  }
)