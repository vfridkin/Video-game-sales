library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
shinyApp(
  ui = dashboardPagePlus(
    header = dashboardHeaderPlus()
    , sidebar = dashboardSidebar()
    , body = dashboardBody()
  ),
  server = function(input, output) { }
)