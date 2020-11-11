easy_ui <- function(id){
  ns <- NS(id)
  uiOutput(ns("easy_ui"))
}

easy_server <- function(input, output, session){
  
  ns <- session$ns
  
  output$easy_ui <- renderUI({
    
    tagList(
      fluidRow(
        column(
          width = 6
          , style = "display: flex;"
          , img(src = "game_controller.png", style="height: 70px; margin-right: 10px")
          , h1("Video Game Sales (1982-2016)")
        )
        , column(
          width = 3
          , sliderInput(
            inputId = ns("critic_review_slider")
            , label = "Average Critic Review" 
            , min = 0
            , max = 100
            , step = 1
            , value = c(0, 100)
          )
        )
        , column(
          width = 3
          , sliderInput(
            inputId = ns("user_review_slider")
            , label = "Average User Review" 
            , min = 0
            , max = 100
            , step = 1
            , value = c(0, 100)
          )
        )
      )
      , fluidRow(
        column(
          width = 12
          , uiOutput(ns("kpi_ui"))
        )
      )
      , hr()
      , fluidRow(
        column(
          width = 6
          , tags$style(HTML("
            #easy-unit_sale_summary_rt > div > div.rt-table > div.rt-thead.-header {
              color: white;
              background-color: #3c8dbc;
            }
            #easy-unit_sale_summary_rt > div > div.rt-table > div.rt-tfoot {
              color: white;
              background-color: #3c8dbc;
            }
                            "))
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
    )
    
  })
  
  observeEvent(
    input$critic_review_slider
    , {
      v$critic_range <- input$critic_review_slider
    }
  )
  
  observeEvent(
    input$user_review_slider
    , {
      v$user_range <- input$user_review_slider
    }
  )

    
  # KPI --------------------------------------------------------------------------------------------
  
  output$kpi_ui <- renderUI({
    
    vgs <- vgs_filtered()
    
    # Country totals
      country_year_sales <- vgs$summary$country_year_sales
      country_totals <- country_year_sales[, 
                                           .(
                                             na_sales = sum(na_sales)
                                             , eu_sales = sum(eu_sales)
                                             , jp_sales = sum(jp_sales)
                                             , other_sales = sum(other_sales)
                                           )
      ] %>% 
        as.list() %>% 
        map(
          function(x){
            x <- x %>% round(digits = 2)
            if(x > 1){
              paste0(x, "bn")
            } else {
              paste0(1000*x, "M")
            }  
          }
        )
    
    # summary
      df <- vgs$data[, 
        .(
          critic_count = sum(critic_count, na.rm = TRUE)
          , user_count = sum(user_count, na.rm = TRUE)
          , platforms = uniqueN(platform)
          , publishers = uniqueN(publisher)
          , developers = uniqueN(developer)
          , games = .N 
          , years = uniqueN(year_of_release)
        )
      ] %>%
        as.list()

    # games/year
      df$games_per_year <- round(df$games/df$years, 0)
      
      df <- df %>%
        map(
        function(x){
          if(x > 1000000) return(paste0(round(x/1000000, 2), "M"))
          if(x > 1000) return(paste0(round(x/1000, 1), "K"))
          x            
        }
      )
      
    fluidRow(
      kpi_helper("Sales (EU)", country_totals$eu_sales)
      , kpi_helper("Sales (JP)", country_totals$jp_sales)
      , kpi_helper("Sales (USA)", country_totals$na_sales)
      , kpi_helper("Sales (Other)", country_totals$other_sales)
      , kpi_helper("Critic Reviews", df$critic_count)
      , kpi_helper("User Reviews", df$user_count)
      , kpi_helper("Games/Year", df$games_per_year)
      , kpi_helper("Platforms", df$platforms)
      , kpi_helper("Publishers", df$publishers)
      , kpi_helper("Developers", df$developers)
      , kpi_helper("Games", df$games)
    )

  })
  
  kpi_helper <- function(text, header){
    column(
      width = 1
      , kpi(header = header, text = text)
    )
  }


  # Summary reactable ----------------------------------------------------------------------------- 
  
  output$unit_sale_summary_rt <- renderReactable({
    
    df <- vgs_filtered()$summary$unit_sales
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
    
    df <- vgs_filtered()$summary$country_year_sales
    
    df %>% 
      e_charts(year_of_release) %>% 
      e_grid(left = "12%") %>%
      e_y_axis(name = "Total Unit Sales", index = 0, position = "left", nameLocation = "center", nameGap = 50) %>%
      # e_y_axis(name = "Sales", index = 0, position = "left") %>%
      e_x_axis(name = "Release Year", nameLocation = "center", nameGap = 25) %>%
      e_bar(other_sales, name = "Sales (Other)", stack = "country") %>% 
      e_bar(na_sales, name = "Sales (USA)", stack = "country") %>% 
      e_bar(jp_sales, name = "Sales (Japan)", stack = "country") %>% 
      e_bar(eu_sales, name = "Sales (EU)", stack = "country") %>% 
      e_format_y_axis(suffix = "bn") %>%
      e_line(games, symbol = "circle", showSymbol = FALSE, name = "Games", y_index = 1, color = "red"
             , symbolStyle = list(normal = list(opacity = 0.5)), lineStyle = list(normal = list(opacity = 1))) %>%
      e_y_axis(name = "Games Released", index = 1, position = "right", nameLocation = "center", nameGap = 40) %>%
      # e_y_axis(name = "Games", index = 1, position = "right") %>%
      e_hide_grid_lines(which = "y") %>%
      e_legend(top = 30) %>%
      e_title("Unit Sales by Region & Release Year") %>%
      e_theme("macarons")

  })
  
  
  
  
  # END -------------------------------------------------------------------------------------------
}