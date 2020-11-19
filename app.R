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
                        menuItem("Home", tabName = "Home", icon = icon("table")),
                        menuItem("Settings", tabName = "readMe", icon = icon("cog"))
                      )
                    ),

                    dashboardBody(
                      useShinyjs(),
                      tabItems(
                        tabItem(tabName = "Home",
                                fluidRow(
                                  box(id = "myVideo",
                                      tags$video(width = "640", height = "480", autoplay = T),
                                      tags$canvas(id = "canvas", width = "640", height = "480"),
                                      tags$button(id = "snap", width = "50"),
                                      includeScript(path = "video.js"),

                                  ),
                                )


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