source_dir <- function(dir_name){
  files = list.files(dir_name, full.names = TRUE, pattern = ".\\.R$")
  files %>% walk(source)  
}

sar <- function(){
  rstudioapi::documentSaveAll()
  shiny::runApp()
}

