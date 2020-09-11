dash_body <- function(){
  dashboardBody(
    tabItems(
      easy_tab
      , hard_tab
    )
  )
}

easy_tab <- tabItem(
  tabName = "easy"
  , easy_ui("easy")
)

hard_tab <- tabItem(
  tabName = "hard"
  , hard_ui("hard")
)