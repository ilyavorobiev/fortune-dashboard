library(shiny)
library(googleVis)

# Define UI for application that plots random distributions 
shinyUI(#pageWithSidebar(
  
  navbarPage("Fortune 500 Analysis",
    tabPanel("Geo distribution",
      sidebarLayout(
        sidebarPanel(
          # Metric select box
          selectInput("geoMetric", label = h3("Metric"), 
                      choices = list("Amount of companies" = "Count", "Profits" = "Profits", "Revenues" = "Revenues",
                                     "Amount of Employees" = "Employees", "Years on the list" = "Years.on.list"),
                      selected = "Count"),
          # Filter select box
          selectInput("geoFilter", label = h3("Filter by Sector"), 
                      choices = sectors,
                      selected = "All")
          ),
        mainPanel(
          # GEO Chart
          p("In this section you can find information on geo distribution of Fortune 500 companies by common metrics. Also, you can filter by Sector to see State tendency to some Sector."),
          htmlOutput("geoChart")
        )
      )
    ),
    tabPanel("Comparison",
      sidebarLayout(
        sidebarPanel(
          # Metric select box
          selectInput("barDimension", label = h3("Dimension"), 
                      choices = list("State" = "State", "Sector" = "Sector"),
                      selected = "State"),
          # Metric select box
            selectInput("barMetric", label = h3("Metric"), 
              choices = list("Amount of companies" = "Count", "Profits" = "Profits", "Revenues" = "Revenues",
                "Amount of Employees" = "Employees", "Margin" = "Margin", "Revenue per Employee" = "RevenuePerEmployee"),
                selected = "Count")
          ),
          mainPanel(
            # Bar Chart
            p("In this section you can see comparison of Fortune 500 companies common metrics by State and Sector."),
            htmlOutput("barChart")
          )
      )  
    ),
    tabPanel("Source data",
      # Source data table
      dataTableOutput("sourceDataTable")
    )
  )
)