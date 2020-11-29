library(shiny)
library(shinydashboard)
library(shinyMatrix)
library(shinyjs)
library(shinyEventLogger)
set_logging()
log_init()

ui <- dashboardPage(
  dashboardHeader(title = "Exam Center"),
  dashboardSidebar(sidebarMenu(
    menuItem("Home", tabName = "Home", icon = icon("table")),
    menuItem("Settings", tabName = "readMe", icon = icon("cog"))
  )),
  
  dashboardBody(useShinyjs(),
                tabItems(
                  tabItem(tabName = "Home",
                          fluidRow(column(
                            8,
                            offset = 2,
                            box(
                              id = "myVideo",
                              width = 12,
                              height = NULL ,
                              collapsible = T,
                              solidHeader = T,
                              div(
                                align = 'center',
                                tags$video(
                                  id = "video",
                                  autoplay = T,
                                  width = 640,
                                  height = 480
                                ),
                                
                                tags$canvas(id = "canvas", width = 640, height = 480),
                                
                                includeScript(path = "video.js"),
                                
                                tags$head(
                                  tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
                                ),
                                
                                textAreaInput('imgStr', 'Label'),
                                
                                actionButton('startExam', 'Start')
                                
                                
                              )
                            ),
                          ),),),
                  tabItem(tabName = "Settings",)
                ),)
)

server <- function(input, output) {
  set_logging_session()
  options(shiny.maxRequestSize = 30 * 1024 ^ 2)
  
  
  observeEvent(input$startExam, {
    interval = 5
    
    
    
    repeat {
      startTime = Sys.time()
      
      runjs('
      
             var video = document.getElementById("video");
             console.log("hi")
             var canvas = document.getElementById("canvas");
             var context = canvas.getContext("2d");
             context.drawImage(video, 0, 0);
             str2 = (canvas.toDataURL());
             str3 = str2.split(",").pop();
             console.log(str3);
             Shiny.setInputValue("imgStr", str3);
             console.log("checking");


    ')
      
      log_message(input$imgStr)
      
      sleepTime = startTime + interval - Sys.time()
      if (sleepTime > 0)
        Sys.sleep(sleepTime)
      
    }
    
  })
  
  
}

shinyApp(ui, server)