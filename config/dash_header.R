dash_header <- function(){
  dashboardHeader(
    title = tagList(
      span(class = "logo-lg", "Video game sales")
      , img(src = "game_controller.svg", style = "height: 40px; margin-left: -9px;")
    )
  )  
}
