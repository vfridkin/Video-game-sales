vgs <- reactive({

  df <- fread(
    "data/Video_Games.csv"
    , colClasses = c(
      Critic_Score = "double" 
    )
  ) %>%
    clean_names()
  
  # Convert user score to number - sets 'tbc' to NAs
  df <- df[, 
     user_score := as.numeric(user_score)
  ]
  
  # Filter on 1983-2016
  df <- df[
    year_of_release %in% 1983:2016
  ]
  
  # Rating to factor
    # In 1998 K-A rating changed to E (https://www.esrb.org/history/)
    df <- df[rating == "K-A", 
             rating := "E"
    ]
    
    # Change missing rating to NA
    df <- df[rating == "", 
             rating := NA
    ]
  
    # Create factor
    rating_levels <- c("EC", "E", "E10+", "T", "M", "AO", "RP")
    df <- df[,
             rating := factor(rating, levels = rating_levels)
    ]
  
  # Sales to units
  # Ratings to decimal
    df <- df[,
           ':='(
              na_sales = na_sales*1000000
              , eu_sales = eu_sales*1000000
              , jp_sales = jp_sales*1000000
              , other_sales = other_sales*1000000
              , global_sales = global_sales*1000000
              , critic_score = critic_score/100
           )
  ]

  cols <- c("name", "platform", "year_of_release", "genre", "publisher", 
            "na_sales", "eu_sales", "jp_sales", "other_sales", "global_sales", 
            "critic_score", "critic_count", "user_score", "user_count", "developer", 
            "rating")
  
  # Summary of unit sales for table view
  summary_unit_sales <- df[, 
                          .(
                            global_sales = sum(global_sales, na.rm = TRUE)
                            , critic_score = mean(critic_score, na.rm = TRUE)
                          )
                          , by = c("platform", "genre", "publisher")
  ][order(-global_sales)]
    
  # Summary of sales by country for chart view
  summary_country_year_sales <- df[,
                                   .(
                                     na_sales = sum(na_sales)/1000000000
                                     , eu_sales = sum(eu_sales)/1000000000
                                     , jp_sales = sum(jp_sales)/1000000000
                                     , other_sales = sum(other_sales)/1000000000
                                     , games = .N
                                   )
                                   , by = c("year_of_release")
  ][order(year_of_release)]
  
  
  
  list(
    data = df
    , summary = list(
      unit_sales = summary_unit_sales
      , country_year_sales = summary_country_year_sales
    )
  )
})



column_definitions <- reactive({
  
  cols <- c("name", "platform", "year_of_release", "genre", "publisher", 
            "na_sales", "eu_sales", "jp_sales", "other_sales", "global_sales", 
            "critic_score", "critic_count", "user_score", "user_count", "developer", 
            "rating")
  
  list(
    name = colDef(
      name = "Game"
      , minWidth = 180
    )
    , platform = colDef(
      name = "Platform"
      , width = 60
      , footer = "Total"
    )
    , year_of_release = colDef(
      name = "Released"
      , width = 50
    )
    , genre = colDef(
      name = "Genre"
      , width = 80
    )
    , publisher = colDef(
      name = "Publisher"
      , minWidth = 150
    )
    , developer = colDef(
      name = "Developer"
      , minWidth = 150
    )
    , global_sales = colDef(
      name = "Sales"
      , minWidth = 80
      , format = colFormat(separators = TRUE, digits = 0)
      , footer = function(x){ format(sum(x, na.rm = TRUE), digits = 0, big.mark = ",")}
    )
    , critic_score = colDef(
      name = "Critic Score (Avg)"
      , width = 95
      , format = colFormat(percent = TRUE, digits = 0)
      , footer = function(x) { percent(mean(x, na.rm = TRUE))}
    )
  )
  
})