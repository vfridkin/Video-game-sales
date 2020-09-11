vgs <- reactive({
  df <- read_csv("data/Video_Games.csv") %>%
    clean_names()
  df
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
      , width = 50
    )
    , year_of_release = colDef(
      name = "Released"
      , width = 50
    )
    , genre = colDef(
      name = "Genre"
    )
    , publisher = colDef(
      name = "Publisher"
      , minWidth = 150
    )
    , developer = colDef(
      name = "Developer"
      , minWidth = 150
    )
  )
  
})