easy_ui <- function(id){
  ns <- NS(id)
  uiOutput(ns("easy_ui"))
}

easy_server <- function(input, output, session){
  
  ns <- session$ns
  
  output$easy_ui <- renderUI({
    
    h4("Hello!")
    
    fluidRow(
      column(
        width = 6
        , div(
          style = "font-size: 80%;"
          , reactableOutput(ns("unit_sale_summary_rt"))
        )
      )
      , column(
        width = 6
        , echarts4rOutput(ns("sales_by_year_chart"))
      )
    )
    
  })
  
  # Summary reactable ----------------------------------------------------------------------------- 
  
  output$unit_sale_summary_rt <- renderReactable({
    
    df <- vgs()$summary$unit_sales
    columns <- column_definitions()
    
    # Filter columns on those in data
    columns <- columns[names(columns) %in% names(df)] 
    
    reactable(
      df
      , columns = columns
      , compact = TRUE
      , bordered = TRUE
      , striped = TRUE
      , highlight = TRUE
      , defaultColDef = colDef(footerStyle = list(fontWeight = "bold"))
      )
    
  })
  
  # Sales by year chart --------------------------------------------------------------------------- 
  
  output$sales_by_year_chart <- renderEcharts4r({
    
    df <- vgs()$summary$country_year_sales
    
    df %>% 
      e_charts(year_of_release) %>% 
      e_bar(other_sales, name = "Sales (Other)", stack = "country") %>% 
      e_bar(na_sales, name = "Sales (USA)", stack = "country") %>% 
      e_bar(jp_sales, name = "Sales (Japan)", stack = "country") %>% 
      e_bar(eu_sales, name = "Sales (EU)", stack = "country") %>% 
      e_format_y_axis(suffix = "bn") %>%
      e_line(games, name = "Games", y_index = 1, color = "red") %>%
      e_hide_grid_lines(which = "y") %>%
      e_legend(top = 30) %>%
      e_title("Unit Sales by Region & Release Year")
  })
  
  
  
  
  # END -------------------------------------------------------------------------------------------
}