source_dir <- function(dir_name){
  files = list.files(dir_name, full.names = TRUE, pattern = ".\\.R$")
  files %>% walk(source)  
}

sar <- function(){
  rstudioapi::documentSaveAll()
  shiny::runApp()
}

kpi <- function(number = NULL, numberColor = NULL, numberIcon = NULL, 
                header = NULL, text = NULL, rightBorder = TRUE, marginBottom = FALSE) 
{
  cl <- "description-block"
  if (isTRUE(rightBorder)) 
    cl <- paste0(cl, " border-right")
  if (isTRUE(marginBottom)) 
    cl <- paste0(cl, " margin-bottom")
  numcl <- "description-percentage"
  if (!is.null(numberColor)) numcl <- paste0(numcl, " text-", numberColor)
  shiny::tags$div(
    class = cl
    , style = "margin-left: 10px; margin-right: 10px;"
    , shiny::tags$span(class = numcl, number, if (!is.null(numberIcon)) shiny::icon(numberIcon))
    # , shiny::tags$h5(class = "description-header", header)
    , shiny::tags$span(style = 'font-size: 24px; color: #3c8dbc;', header)
    , br()
    # , shiny::tags$span(class = "description-text", text)
    , shiny::tags$span(style = 'color: #3c8dbc;', text)
  )
}