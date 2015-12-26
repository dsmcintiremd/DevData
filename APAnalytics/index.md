---
title       : DC Airport Analytics
subtitle    : Easy access to airport information
author      : D. McIntire 
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## Washington DC Airport Analytics - Overview

DC Airport Analytics (beta) provides:  
* Detailed analytics on number of flight departures for each DC area airport  
  + Washington Dulles International (IAD)  
  + Ronald Reagan Washington National (DCA)  
  + Baltimore-Washington International (BWI)
* Visualization of daily departures and smoothing curve (locally weighted scatterplot smoothing)  
* Top ten destinations from each airport  
* Visualization of departures by day of week for selected month  

---

## Many Benefits to using DC Area Analytics

* Companies and organizations that benefit from DC Airport Analytics include those that:  
  + Require detailed information on flight counts from the DC Area
  + Need insight on destinations   
  + Plan based on day-of-week departures  
* The benefits include:  
  + Clear and understandable visualizations 
  + Airport analytics across multiple dimensions 
  + Ability to interact with the data and create custom visualizations

---

## Interactive Visualizations

* DC Airport Analytics replaces boring static tables such as the following with interactive, customizable visualizations:



```r
DCFltT10Dest     <- read.csv("../data/DC2008Top10.csv", header = TRUE)
DCFltT10Dest[1:10,]
```

```
##    Dest n.BWI n.DCA n.IAD
## 1   ATL  5972  7296  5362
## 2   MCO  4926    NA  4244
## 3   BOS  4795  8929  3846
## 4   PVD  3988    NA    NA
## 5   CLT  3652  3001  2762
## 6   MHT  3633    NA    NA
## 7   ORD  3545  7427  2948
## 8   TPA  3388    NA    NA
## 9   DTW  3105  2982    NA
## 10  BDL  2863    NA    NA
```


---

## Future Direction

* DC Airport Analytics is constantly evolving  
* Future additions include analytics by:  
  + individual airline, for example, counts by each airline at each airport  
  + delays, for example, delay minutues and reason for each airline at each airport  
  + cancellations, for example, cancellations by each airline for each airport   
* Inclusions of other major airports:  
  + New York area   
  + Los Angles  
  + Chicago  


