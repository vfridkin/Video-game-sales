easy_ui <- function(id){
  ns <- NS(id)
  uiOutput(ns("easy_ui"))
}

easy_server <- function(input, output, session){
  
  ns <- session$ns
  
  output$easy_ui <- renderUI({
    
    h4("Hello!")
    
    div(
      style = "font-size: 60%;"
      , reactableOutput(ns("vgs_rt"))
    )
    
  })
  
  
  
  output$vgs_rt <- renderReactable({
    
    df <- vgs()
    column_definitions <- column_definitions()
    
    reactable(
      df
      , columns = column_definitions
      , compact = TRUE
      , bordered = TRUE
      , striped = TRUE
      , highlight = TRUE
      )
    
  })
  
  
  
  # END -------------------------------------------------------------------------------------------
}