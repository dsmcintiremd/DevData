setwd("~/Tiber/DevData")
library(dplyr)
library(stringr)

## Initial data prep - write DC Summary File
flights2008 <- read.csv("data/2008.csv.bz2", header = TRUE)
#DCflights2008 <- filter (flights2008, Origin == "IAD" | Origin == "DCA" | Origin == "BWI" | Dest == "IAD" | Dest == "DCA" | Dest == "BWI" )
DCflights2008 <- filter (flights2008, Origin == "IAD" | Origin == "DCA" | Origin == "BWI" ) 
write.table(DCflights2008,file="data/DC2008.csv",sep = ",")

## read in DC Area data and airport data
DCAreaFlights2008 <- read.csv("data/DC2008.csv", header = TRUE) 
AirportNames <- read.csv("data/airports.csv", header=TRUE)

### Reshape data - filter on flights departing DCA, BWI, IAD

#### Reshape Data - add date 
DCAreaFlights2008 <- mutate(DCAreaFlights2008, fltdate = paste(Year,str_pad(Month,2,pad="0"),str_pad(DayofMonth,2,pad="0"),sep="-") )
DCAreaFlights2008$fltdate <- as.Date(DCAreaFlights2008$fltdate)
#DCAreaFlights2008$cnt <- 1

## --- Working Area ---
AirportNmeLKUP <- function (code) filter(AirportNames,grepl(paste0("^",code), iata)) %>% select(iata,airport)
## --- Working Area ---

### Summarize Data by date (day) and day of the week

# Count
DCFltperDay <- count(DCAreaFlights2008,fltdate,Origin)
DCFltbyDayofWeek <- count(DCAreaFlights2008,Origin, Month,DayOfWeek)
DCFltT10Dest <- count(DCAreaFlights2008,Origin, Dest)

# Reshape
DayLKUP <- data.frame(DayOfWeek = c(1,2,3,4,5,6,7), DayName =c("Mon","Tues","Wed","Thur","Fri","Sat","Sun"))

DCFltbyDayofWeek <- left_join(DCFltbyDayofWeek,DayLKUP,by="DayOfWeek")
DCFltbyDayofWeek$DayName <- factor(DCFltbyDayofWeek$DayName,levels = c("Mon","Tues","Wed","Thur","Fri","Sat","Sun"))
DCFltbyDayofWeek$MonName <- factor(month.name[DCFltbyDayofWeek$Month])

DCFltT10Dest <- arrange(DCFltT10Dest,Origin,-n) %>% group_by(Origin) %>% top_n(10)

#DCFltT10Dest <- left_join(DCFltT10Dest, AirportNames, by=c("Dest"="iata"))
#DCFltT10Dest$hover <- with(DCFltT10Dest, paste(airport, city, state, "Arrivals: ", n))

DCFltT10Dest <- reshape(DCFltT10Dest,direction="wide",idvar = "Dest", timevar = "Origin")



### Write out data files 
write.table(DCFltperDay,file="data/DC2008Day.csv",sep = ",")
write.table(DCFltbyDayofWeek,file="data/DC2008Week.csv",sep = ",")
write.table(DCFltT10Dest,file="data/DC2008Top10.csv",sep = ",")


## Create PLOT then plotly -- flights for each day

#gg <- ggplot (DCFltperDay, aes(x=fltdate,y=n)) 
#gg <- gg + geom_line() 
#gg <- gg + stat_smooth(method="loess")
#gg <- gg + labs(x="Flight Date", y="Number of Flights", title="DC Area Flights 2008")
#gg <- gg + theme_minimal() + expand_limits(y=0)
#gg
#(ggpl <- ggplotly(gg))

## Create PLOT then plotly -- flights for each day, maybe box plot

#gg2 <- ggplot (DCFltbyDayofWeek, aes(x=DayName, y=n))
#gg2 <- gg2 + geom_bar(stat="identity")
#gg2 <- gg2 + labs(x="Day of Week", y="Number of Flights", title="DC Area Flights 2008 by Day of Week")
#gg2 <- gg2 + theme_minimal()
#gg2
#(ggpl2 <- ggplotly(gg2))


#### with ploty only 

m <- loess(n ~ as.numeric(fltdate), data=filter(DCFltperDay,Origin==input$APRadio))
p1 <- plot_ly(data=filter(DCFltperDay,Origin==input$APRadio), x = fltdate, y = n, name = "Daily Flights")
p1 <- layout(p1, xaxis=list(title="Flight Date"), yaxis=list(title="Number of Flights",range=c(minn,maxx)))
add_trace(p1, y = fitted(m), name = "Regression")

p2 <- plot_ly(data=DCFltbyDayofWeek,x=DayName, y=n, group=Origin,type="bar",name="By Day of Week")
p2 <- layout(p2, xaxis=list(title="Day"), yaxis=list(title="Number of Flights"))
p2


### MAP code
mrk <- list(
  colorbar = list(title = "Arriving Flights 2008"),
  size = 8, opacity = 0.8, symbol = 'circle'
)

geo <- list(
  scope = 'usa',
  projection = list(type = 'albers usa'),
  showland = TRUE,
  landcolor = toRGB("gray95"),
  subunitcolor = toRGB("gray85"),
  countrycolor = toRGB("gray85"),
  countrywidth = 0.5,
  subunitwidth = 0.5
)

output$FltTop10 <- renderPlotly({
  p3 <- plot_ly(DCFltT10Dest, lat = lat, lon = long, text = hover, color = n,
                type = 'scattergeo', locationmode = 'USA-states', mode = 'markers',
                marker = mrk)
  p3 <-  layout(p3, title = 'Most trafficked US airports<br>(Hover for airport)', geo = geo)
  p3
})


### 

p3 <- plot_ly(DCFltT10Dest, x = n.BWI, y = Dest, name = "BWI", 
             mode = "markers", marker = list(color = "blue",size=15))
p3 <- add_trace(p3, x = n.DCA, name = "DCA", marker = list(color = "red")) 
p3 <- add_trace(p3, x = n.IAD, name = "IAD", marker = list(color = "green")) 
p3 <- layout(p3, title = 'Top 10 Destinations 2008',xaxis=list(title="Number of Flights"), yaxis=list(title="Destination"))
p3

##

p3 <- plot_ly(DCFltT10Dest,type="heatmap", x=Origin, y=Dest, z=n)
