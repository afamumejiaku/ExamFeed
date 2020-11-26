library(shiny)
library(shinydashboard)
library(shinyMatrix)
library(shinyjs)
library(shinyEventLogger)

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
                                  column(8, offset = 2,
                                         box(id = "myVideo", width = 12, height = NULL , collapsible = T, solidHeader = T,
                                             div(align = 'center',
                                                 tags$video(id = "video", autoplay = T, width = "100%", height="100%"),
                                                 tags$canvas(id = "canvas"),
                                                 includeScript(path = "video.js"),
                                                 tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "style.css"))
                                             )
                                         ),
                                  ),
                                ),

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