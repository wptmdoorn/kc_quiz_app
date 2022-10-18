library(shiny)
library(shinythemes)
library(shinyStore)
library(bslib)

ui <-
  navbarPage(
    "Quiz",
    id = 'quizNav',
    collapsible = TRUE,
    inverse = TRUE,
    #theme = shinytheme("spacelab"),
    theme = bs_theme(version = 5, bootswatch = "minty"),
    tabPanel("Nieuw",
             fluidPage(
               initStore("store", "shinyStore-ex1"),
               uiOutput('nieuw'))),
    tabPanel("Quiz",
             fluidPage(uiOutput('quiz'))),
    tabPanel("Historie",
             fluidPage(uiOutput('historie'))),
    
    tags$footer(HTML('<br/> <br/>
                <p style="color:#D0D0D0"> © William van Doorn - 
                <a href="https://github.com/wptmdoorn/kc_quiz_app"> Source</a> - 
                <a href="mailto:wptmdoorn@gmail.com">Contact</a> </p>'), 
                align = "center")
  )
