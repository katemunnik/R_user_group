# R USERS GROUP - SHINY INTRODUCTION
# Lesson 1 - under the hood of a Shiny app
# Original code: James Lawson, adapted by Kate Dodds

#all shiny commands are included in the one shiny package:
install.packages('shiny') # comment out once you've done this

library(shiny)
# these instructive examples come with the Shiny package
# check out https://shiny.rstudio.com/articles/basics.html for a guide to the code


# UI 
# - user interface
# -	Input widgets collect information from the user
# -	Displays outputs, such as plots or tables
# -	Define how visual elements are laid out
# -	Written in R syntax, but most functions won't be familiar (unless you're into HTML)
# 
# Server
# -	Where data is processed
# -	Regular R code combined with special shiny:: functions that implement reactivity
# - Reactive expressions are re-evaluated when their dependent values have changed

# in practice the shiny template looks like this in its simplest form: 
library(shiny)

ui<- fluidPage()

server<- function(input,output){}

shinyApp(ui=ui,server=server)
# this is an actual app and will work,
# try typing some text between the fluidpage brackets.. 
# then selecting these lines and running them.

###################################################################################

# Now lets look at some slightly more complicated examples
## Example 1: 

runExample("01_hello")

# 01_hello shows a basic example of reactivity: one input, one output
# -	User changes the position of the slider, and this alters the binwidth of the histogram
# -	The user interface updates pretty quickly, gives a seamless experience
# - Look at the associated code and see that it follows the tempate pattern
# - All shiny apps have a two part template, a UI and a SERVER component:

# The sliderInput widget defined in the UI allows the user to set a value,
# which is retrieved and used to set the binwidth in the Server.
# renderPlot is a reactive expression: 
# code wrapped within renderPlot({}) will be re-evaluated any time an input changes

# N.B. if you want to use 'reactive values' (i.e. those that are updated), 
# you MUST use them within one of Shiny's reactive expressions

###################################################################################
 
runExample("02_text")

# 02_text uses multiple input widgets and displays multiple outputs
# this example also implements a 'chain of reactivity', using the reactive({}) expression
# reactive({}) allows us to assign an expression to an object, 
# which can be called upon in other reactive expressions.
  
# To save on computing power you should always try to define these early and independedntly
# and then refer to their results in later code (rather than always repeating them in your code)

# Exercise 1: trace the path from the "dataset" input in the UI through the Server, and back to the "view" table in the UI
# (hint, think in terms of inputs and outputs)
# NOTE: Look at how the names are defined, slightly different useage to normal. 
#
# Exercise 2: play around with resizing the Shiny application window - notice what happens to the layout
#
# Extra note.. when the app goes grey in your browser.. its idle/dead and proabbly need reloading.
#             - Always select STOP before opening a new app. 

