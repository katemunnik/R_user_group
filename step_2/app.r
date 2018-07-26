# R USERS GROUP - SHINY INTRODUCTION
# Lesson 2 - Basic data explorer
# Original code: James Lawson, adapted by Kate Dodds

#note: Now that we're using an app template, there's a "RUN APP" button
#at the top right of the page. 
#Also a handy drop down alongside it to toggle viewing options for your app. 

#for publishing, the correct path needs to be set:
# insert your correct path to the downloaded files, and the step_2 folder here:
path<-"./step_2"
setwd(path)
getwd()
# best to comment these above lines out before running the app.

library(rsconnect)
library(shiny)
library(ggplot2)
library(plotly) #free for non-commercial use

ui <- fluidPage(
   
  # Application title
  titlePanel("mtcars data explorer"), # give our app a title - watch out for the commas within each function.
  
  tags$a(href="https://shiny.rstudio.com","Shiny Page"),
  tags$p("may help with looking at more examples and playing with code"), #adding HTML prettiness
  
  
  sidebarLayout( # this is Shiny's basic type of layout - more complex layouts exist
    
    # Sidebar with input widgets
    sidebarPanel(
        ## add x-axis selector
        selectInput("x_axis", "Select x-axis", choices=c("Miles per gallon" = "mpg",
                                                         "Weight" = "wt",
                                                         "Horsepower" = "hp",
                                                         "Engine displacement" = "disp")),
        ## add y-axis selector
        selectInput("y_axis", "Select y-axis", choices=c("Miles per gallon" = "mpg",
                                                         "Weight" = "wt",
                                                         "Horsepower" = "hp",
                                                         "Engine displacement" = "disp")),
        ## add factor selector
        selectInput("fac", "Select factor", choices=c("Miles per gallon" = "mpg",
                                                         "Weight" = "wt",
                                                         "Horsepower" = "hp",
                                                         "Engine displacement" = "disp")),
        ## display a table 
        tableOutput('table')
      ),
      
    # Show a graph of the selected relationships in a 'main panel'
    
    mainPanel(
        ## display the graph
        plotOutput('plot') # plotlyOutput
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # code to generate the table
  output$table <- renderTable({
    # create a dataframe from the mtcars dataset with just the columns selected by the user using the selectInput()'s
    mtcars[, c(input$x_axis, input$y_axis, input$fac), drop = FALSE]
  })
  
  # code to generate the graph (plotly type plot is rendered)
  #can add dimension and resolution arguments here too (?renderPlot)
  #note the use of aes_string: aes_string requires a quoted variable "". 
  # in this case the user dedfined input/choice is quoted (""), and aes on its own won't work. 
  output$plot <- renderPlot({ 
    ggplot(mtcars, aes_string(x = input$x_axis, y = input$y_axis)) + 
      geom_point(aes_string(col = input$fac)) +
      scale_color_gradientn(colours = rainbow(5))+
      theme_minimal()
  })

  
}

# Run the application 
shinyApp(ui = ui, server = server)

###Publishing this app -

# You can of course share your scripts, with someone who has R on their computer and is 
# relatively familiar with using it...then they can simply run the app from your script.
# HOWEVER - the whole point was to develop a web app so this is how to share that:
#  Go to www.Sinyapps.io - this is where free apps can be hosted. 
# There are other options too: https://shiny.rstudio.com/tutorial/written-tutorial/lesson7/ 
# - Sign up for an account with shinyapps.io
# - Next, associate your rstudio IDE with your shinyapps.io account (NB STEP!)
# - To do this install package rsconnect
#    This first step allows you to deploy apps to the shiny.io server
#install.packages('rsconnect')  
#library(rsconnect)
# - once you've logged inot your shinyapps.io account, 
# - click on dashboard, and show token: This will show the below code with a secret & token
# - copy this and paste it here:

#rsconnect::setAccountInfo(name="<ACCOUNT>", token="<TOKEN>", secret="<SECRET>")

# once this line is run you should be "linked up"
# you can set your publishing options from your RStudio IDE by clicking:
# Tools > Global Options > Publishing

#once ready to publish (ie after you've checked the app works locally on your computer)
# set the working directory to the directory of your app
# CHECK that you have all of your files in the apps directory including the data! (NB!)
# the app should be called app.r within the names folder, all files/associated items to be stored 
# in this same folder. 
# use the rsconnect function: deployapp
#deployApp("insert path to app directory")
#alternatively use the publish icon in RStudio at the top right of the screen. 
# Test here: https://katedodds.shinyapps.io/test_publish/

#if you need to make changes to your app, make them and then run the deployApp()
# command again, this time the upload should be much faster. 

#Some notes on packages used in your app:
#Only packages installed from GitHub with devtools::install_github in version 1.4 (or later)
#of devtools are supported. Packages installed with an earlier version of devtools must
#be reinstalled before you can deploy your application. If you get an error such as 
#"PackageSourceError" when you attempt to deploy, check that you have installed any package
#from Github with devtools 1.4 or later.

# For error logging thefollowing is useful:
#rsconnect::showLogs()
 
# You	Can build a linux web server using shiny server also free.. 
# this allowes you to have your own server if you're worried about security.. 

# want to delete your app:
#terminateApp("path to app directory")

