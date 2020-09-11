hard_ui <- function(id){
  ns <- NS(id)
  uiOutput(ns("hard_ui"))
}

hard_server <- function(input, output, session){
  
  ns <- session$ns
  
  output$hard_ui <- renderUI({
    
    h4("Hello hard!")
    
    
  })
  
  
  
  # END -------------------------------------------------------------------------------------------
}