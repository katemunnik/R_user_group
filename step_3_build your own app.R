# R USERS GROUP - SHINY INTRODUCTION
# Lesson 3 - creating an app with your own data
# Original code: James Lawson, adapted by Kate Dodds

#the below code is set to work correclty, but try these exercises anyway and see where these 
# particular aspects are changing. 
# Exercise 1: use the help for updateSelectedInput() and work out how to preselect some values (rather than have them start all the same)
# Exercise 2: use the help for fileUpload() and work out how to add the file name as a title to the plot - in ggtitle()
# hint: ?updateSelectInput()
#hint:  ??fileUpload()

library(shiny)
library(ggplot2)
library(plotly)


ui <- fluidPage(
  
  # Application title
  titlePanel("Interactive data explorer"), # give our app a title
  
  sidebarLayout( # this is Shiny's basic type of layout - more complex layouts exist
    
    # Sidebar with input widgets
    sidebarPanel(
      
      ## add fileInput widget
      fileInput("uploadedfile", "Choose CSV File",
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
      ## add x-axis selector - no choices are needed yet.. these depend on uploaded file
      selectInput("x_axis", "Select x-axis", choices=NULL),
      ## add y-axis selector
      selectInput("y_axis", "Select y-axis", choices=NULL),
      ## add factor selector
      selectInput("fac", "Select factor", choices=NULL),
      ## display a table 
      tableOutput('table')
      
    ),
    
    # Show a graph of the selected relationships in a 'main panel'
    
    mainPanel(
      ## display the graph
      plotlyOutput('plot') # plotlyOutput  - plotly instead of plot.. better! (but you do need to pay eventually)
    )
  )
)


# Define server logic required to draw a histogram
#server now has session as an argument!
server <- function(input, output, session) {
   #this is an event reactive function... 
  #its waiting for the first argument before it does anything
  #now there's something between the round and curly brackets. 
  #when this file changes - then do things... 
  uploaded_file <- eventReactive(input$uploadedfile, {
    df <- read.csv(input$uploadedfile$datapath)  #dataframe made from reading this file
    
    vars <- names(df)  # names of the cols!
    updateSelectInput(session, "x_axis", choices = vars) #now update choices with those associated with new file
    updateSelectInput(session, "y_axis", choices = vars) 
    updateSelectInput(session, "fac", choices = vars)
    
    return(df)
  })
  
  #subset the new file into what you want displayed...
  output$table <- renderTable({
    uploaded_file()[, c(input$x_axis, input$y_axis, input$fac), drop = FALSE]
  })
    
  output$plot <- renderPlotly({
    ggplot(uploaded_file(), aes_string(x = input$x_axis, y = input$y_axis)) + 
      geom_point(aes_string(col = input$fac)) +
      scale_color_gradientn(colours = rainbow(5))+
      ggtitle(input$uploadedfile$name) +
      theme_minimal()
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

