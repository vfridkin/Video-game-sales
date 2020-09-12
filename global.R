library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(reactable)
library(purrr)
library(readr)
library(janitor)
library(data.table)
library(scales)
library(echarts4r)

source("R/common_functions.R")

source_dir("reactives")
source_dir("tabs")
source_dir("config")

# Stop sci notation
options(scipen=999)

