library(shiny)
library(shinydashboard)
library(shinyMatrix)
library(shinyjs)
library(shinyEventLogger)
library(EBImage)
set_logging()
log_init()

ui <- dashboardPage(dashboardHeader(title = "Exam Center"),
                    dashboardSidebar(
                      sidebarMenu(
                        menuItem("Home", tabName = "home", icon = icon("table")),
                        menuItem("Settings", tabName = "readMe", icon = icon("cog"))
                      )
                    ),

                    dashboardBody(
                      useShinyjs(),
                      tabItems(
                        tabItem(tabName = "Home",

                                



                        ),

                        tabItem(tabName = "Settings",

                        )
                      ),
                    )
)

server <- function(input, output) {
  set_logging_session()
  options(shiny.maxRequestSize = 30 * 1024^2)



}

shinyApp(ui, server)