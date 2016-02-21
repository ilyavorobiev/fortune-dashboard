library(shiny)
library(googleVis)

shinyServer(
  function(input, output) {
    
    # Agregating data by state
    dataByStateSum <- aggregate(companies[,c("Employees","Revenues","Profits")],list(State = companies$geoCode),sum)
    dataByStateAvg <- setNames(aggregate(companies[,c("Years.on.list")],list(State = companies$geoCode),mean),c("State","Years.on.list"))
    dataByState <- merge(dataByStateAvg,dataByStateSum, by=c("State"))
    
    # Agregating data by Sector
    dataBySector <- aggregate(companies[,c("Employees","Revenues","Profits")],list(Sector = companies$Sector),sum)
    
    # Calculating aditional martics for Sector: Margin, Revenue per Employee
    dataBySector$Margin <- dataBySector$Profits / dataBySector$Revenues
    dataBySector$RevenuePerEmployee <- dataBySector$Revenues / dataBySector$Employees
    dataByState$Margin <- dataByState$Profits / dataByState$Revenues
    dataByState$RevenuePerEmployee <- dataByState$Revenues / dataByState$Employees
    
    # Adding amount of companies
    for (stateName in dataByState[,c("State")]) {
      dataByState[dataByState$State == stateName,"Count"] <- sum(companies$geoCode == stateName)
    }
    
    for (sectorName in dataBySector[,c("Sector")]) {
      dataBySector[dataBySector$Sector == sectorName,"Count"] <- sum(companies$Sector == sectorName)
    }
    
    
    output$sourceDataTable <- renderDataTable(companies[,c("Rank","Title","Ticker","Industry","Sector","HQ.Location","Years.on.list","CEO","Employees","Revenues","Profits")],
                                              options = list(
                                                pageLength = 50
                                                )
                                              )
    
    
    geoFilter <- reactive({input$geoFilter})
    
    # Function fo geo filtering data
    geoFilteredData <- function(){
      
      data <- companies[companies$Sector == geoFilter(),]
      
      filteredDataByStateSum <- aggregate(data[, c("Employees","Revenues","Profits")],list(State = data$geoCode),sum)
      filteredDataByStateAvg <- setNames(aggregate(companies[,c("Years.on.list")],list(State = companies$geoCode),mean),c("State","Years.on.list"))
      
      filteredData <- merge(filteredDataByStateAvg,filteredDataByStateSum, by=c("State"))
      
      for (stateName in filteredData[,c("State")]) {
        filteredData[filteredData$State == stateName,"Count"] <- sum(data$geoCode == stateName)
      }
      
      return(filteredData)
    }
    
    # Reactive metrics and dimensions select
    geoMetric <- reactive({input$geoMetric})
    barMetric <- reactive({input$barMetric})
    barDimension <- reactive({input$barDimension})
    
    geoData <- reactive({
      switch(input$geoFilter,
             "All" = dataByState,
             geoFilteredData())
    })
    barData <- reactive({
      switch(input$barDimension,
             "State" = dataByState,
             "Sector" = dataBySector)
    })
    
    
    # Display Geo chart
    output$geoChart <- renderGvis({
                          gvisGeoChart(geoData(), "State", geoMetric(),
                                options=list(
                                            region="US", 
                                            displayMode="regions", 
                                            resolution="provinces",
                                            legend.numberFormat="#,##0",
                                            chartArea="{width:'100%'}"
                                            ))
                        })
    
    
    # Display Bar Chart
    output$barChart <- renderGvis({
                          gvisBarChart(barData(), barDimension(), barMetric(), options = list(
                            height=500,
                            chartArea="{width:'50%',height:'100%'}",
                            legend= "{position: 'none'}"
                          ))
    })
    
  }
)