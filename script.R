## This script is for testing inserui and removeui 

## Test data

library(shiny)
library(shinydashboard)
library(ggplot2)

########################################################################################
######                          USER INTERFACE                                    ######
########################################################################################

ui <- dashboardPage(
  dashboardHeader(),
  
  dashboardSidebar(
    actionButton("add", "Add"),
    radioButtons("add_elements", "Elements", c("Element1",	"Element2")),
    hr()
  ),
  dashboardBody(
    fluidPage(
      tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
      ),
      tags$div(id="placeholder")
    )
  )
)


########################################################################################
######                          SERVER FUNCTIONS                                  ######
########################################################################################


server <- function(input, output, session) {
  
  # Test data set
  
  a<-(letters)
  b<-rnorm(length(letters), 4,2)
  c<-rnorm(length(letters), 10,15)
  d<-c(1:10,20:30,45:49)
  
  data<-data.frame(a,b,c,d)
  names(data)<-c("name","v1","v2","v3")
  
  
  ### Elements ###
  
  observeEvent(input$add, {
    id_add <- paste0(input$add, input$add_elements)
    insertUI(selector = '#placeholder', where = "afterEnd",
             ui= switch(input$add_elements,
                        'Element1'= plotOutput(id_add),
                        'Element2' = plotOutput(id_add))
    )
    
    output[[id_add]] <- 
      if (input$add_elements == "Element1") renderPlot({ 
        plot(data[,1],data[,2])
      }, height=200)
    else if (input$add_elements == "Element2") renderPlot({
      g<-ggplot(data=data, aes(x=data[,1], y=data[,4])) + geom_point()
      plot(g)
    }, height=200)
  })
  
  
}

shinyApp(ui = ui, server = server)