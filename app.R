library(shiny)
library(imager)
library(shinydashboard)
library(shinyMatrix)
library(shinyjs)
library(shinyEventLogger)
library(base64enc)
library(geometry)
library(image.darknet)

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
                              
                              tags$head(
                                tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
                                
                              ),
                              
                              div(
                                align = 'center',
                                tags$video(
                                  id = "video",
                                  autoplay = T,
                                  width = 640,
                                  height = 480
                                ),
                                
                                
                                hidden(tags$canvas(
                                  id = "canvas", width = 640, height = 480
                                )),
                                hidden(textInput('imgStr', 'Label')),
                                
                                p(),
                                
                                actionButton('startExam', 'Start'),
                                
                                includeScript(path = "video.js"),
                                sliderInput(
                                  "threshold",
                                  "Threshold",
                                  min = 0,
                                  max = 100,
                                  value = 98,
                                  step = 1
                                ),
                                
                                
                              )
                            ),
                            
                            
                          ), ),
                          
                          
                          fluidRow(column(
                            8,
                            offset = 2,
                            
                            valueBoxOutput("result", width = 12),
                            
                            
                            
                            
                            
                            
                          ), ), ),
                  
                  
                  
                  tabItem(tabName = "Settings", )
                ), )
)

server <- function(input, output, session) {
  set_logging_session()
  useShinyjs()
  options(shiny.maxRequestSize = 30 * 1024 ^ 2)
  
  
  getDiff <- function(image1, image2) {
    img1 <- load.image(image1)[,,,1]
    img2 <- load.image(image2)[,,,1]
    
    
    
    img1cropped <- data.matrix(img1 [img1 != 0 & img2 != 0])
    img2cropped <- data.matrix(img2[img1 != 0 & img2 != 0])
    dotProd <- dot(img1cropped, img2cropped)
    magImg1 <- norm(img1cropped, type = "F")
    magImg2 <- norm(img2cropped, type = "F")
    cosSim <- dotProd / (magImg1 * magImg2)
    return (cosSim)
    
  }
  
  
  img_str <- reactive({
    input$imgStr
  })
  
  observeEvent(input$startExam, {
    first <<- TRUE
    cosineSimilarity <<- 1
    
    observe({
      invalidateLater(5000, session)
      isolate({
        runjs(
          '
             var video = document.getElementById("video");
             console.log("hi")
             var canvas = document.getElementById("canvas");
             var context = canvas.getContext("2d");
             context.drawImage(video, 0, 0);
             str2 = canvas.toDataURL().split(",").pop();
             //document.getElementById("imgStr").value=str2;
             console.log(str2);
             Shiny.setInputValue("imgStr", str2);
    '
        )
        img <- input$imgStr
        
        
        if (first == FALSE) {
          outconn <- file("img_current.jpg", "wb")
          base64decode(what = img, output = outconn)
          close(outconn)
        }
        
        
        if (first == TRUE & img != "") {
          outconn <- file("img_first.jpg", "wb")
          base64decode(what = img, output = outconn)
          close(outconn)
          first <<- FALSE
        }
        
        if (file.exists("img_first.jpg") == TRUE & file.exists("img_current.jpg") == TRUE) {
          cosineSimilarity <<- getDiff("img_first.jpg", "img_current.jpg")
          log_event(cosineSimilarity)
          
        }
        
        if (cosineSimilarity >= input$threshold / 100) {
          output$result <- renderValueBox({
            valueBox(
              paste0(round(cosineSimilarity * 100, 1), "%"),
              "Cosine Similarity",
              icon = icon("fas fa-thumbs-up"),
              color = "green"
            )
          })
          
        } else {
          output$result <- renderValueBox({
            valueBox(
              paste0(round(cosineSimilarity * 100, 1), "%"),
              "Cosine Similarity",
              icon = icon("fas fa-thumbs-down"),
              color = "red"
            )
          })
          
        }
        
        
        
      })
    })
    
    
    
  })
}

shinyApp(ui, server)
