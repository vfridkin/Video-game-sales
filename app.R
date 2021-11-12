source("global.R")

shinyApp(
  ui = dashboardPage(
    header = dash_header()
    , sidebar = dash_side_bar()
    , body = dash_body()
  ),
  server = function(input, output, session){ 
    
    callModule(easy_server, "easy")
    callModule(hard_server, "hard")
    
    }
)