dash_side_bar <- function(){
  dashboardSidebar(
    sidebarMenu(
      menuItem(
        text = "Noob mode"
        , tabName = "easy"
        , icon = icon("cube")
      ),
      menuItem(
        text = "Pro mode", 
        tabName = "hard",
        icon = icon("dice-d20")
      )
    )
  )
}