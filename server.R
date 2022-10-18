library(shiny)
library(shinyalert)
library(shinyjs)
library(DT)

source('server/data.R')
source('server/vraag.R')
source('server/resultaat.R')

options(
  # whenever there is one account token found, use the cached token
  gargle_oauth_email = TRUE,
  # specify auth tokens should be stored in a hidden directory ".secrets"
  gargle_oauth_cache = ".secrets"
)

server <- function(input, output, session) {
  vragen_data <- load_quiz_drive_data()
  historyData <- reactiveVal()
  
  huidigeQuiz <-
    reactiveVal(
      list(
        gestart = FALSE,
        aantalVragen = NULL,
        huidigeVraag = NULL,
        vragenIdxs = NULL,
        vragen = NULL,
        antwoorden = list()
      )
    )
  
  output$nieuw <- renderUI({
    column(6, align="center", offset = 3,
           div(
             id = "nieuwe_quiz",
             HTML('<h2>Oefenen basistentamen Klinisch Chemie! </h2> <br/>'),
             
             HTML(sprintf('Via deze pagina kunt u een nieuwe oefen quiz starten om
                   het basistentamen van de klinische chemie te oefenen. Standaard
                   zijn alle categorieën geselecteerd. Pas dit aan om specifieke 
                   modules te oefenen. <br/> Er zitten op dit moment <b> %d vragen </b> in 
                   de database! <br/> Succes! <br/> <br/> ', nrow(vragen_data))), 
            
             
             selectInput(
               'aantalvragen',
               'Selecteer het aantal vragen',
               c(10, 20, 50, 100, 200),
               selectize = FALSE
             ),
             
             selectInput(
               'categorien',
               'Selecteer de categoriën',
               multiple = TRUE,
               unique(vragen_data$Cat),
               selected = unique(vragen_data$Cat),
               selectize = FALSE
             ),
             
             actionButton('submit',
                          'Start quiz!')
             
           ))
  })
  
  observeEvent(input$submit, {
    if (is.null(input$categorien)) {
      .cat <- unique(vragen_data$Cat)
    } else {
      .cat <- input$categorien
    }
    
    .vragenData <- vragen_data %>%
      filter(Cat %in% .cat)
    vragenIdx = sample(nrow(.vragenData), size = input$aantalvragen)
    
    huidigeQuiz(
      list(
        gestart = TRUE,
        aantalVragen = as.numeric(input$aantalvragen),
        vraagNr = 1,
        huidigeVraag = .vragenData[vragenIdx[1],],
        vragenIdxs = vragenIdx,
        vragen = .vragenData,
        antwoorden = list()
      )
    )
    
    updateTabsetPanel(session, "quizNav",
                      selected = "Quiz")
  })
  
  output$quiz <- renderUI({
    .hq <- huidigeQuiz()
    
    if (.hq$gestart) {
      if (.hq$vraagNr > .hq$aantalVragen) {
        .history <- append_historical_results(.hq, 
                                              isolate(input$store)$history)
        updateStore(session, 
                    "history", 
                    .history)
        
        historyData(.history)
        
        render_resultaat(.hq)
      } else { 
      render_vraag(.hq)
      }
      
    } else {
      column(6, align="center", offset = 3,
             div(
               HTML('<h2> Quiz is nog niet gestart! </h2>')
             )
      )
      
    }
  })
  
  observeEvent(input$submitVraag, {
    .hq <- huidigeQuiz()
    .hv <- .hq$huidigeVraag
    
    if (.hv$Type %in% c('MC', 'TRUEFALSE')) {
      .c <- input$antwoord == .hv$Correct
      .t <- ifelse(.c, 'success', 'error')
      .ti <- ifelse(.c, 'Goed!', 'Fout!')
      .hq$antwoorden <- append(.hq$antwoorden, .c)
      
      shinyalert(
        html = TRUE,
        title = .ti,
        text = tagList(HTML(sprintf(
          '<h6> Jouw antwoord: </h6> %s <br/>',
          .hv[, input$antwoord]
        )),
        HTML(sprintf(
          '<h6> Correcte antwoord: </h6> %s',
          .hv[, .hv$Correct]
        )),
        if(!is.na(.hv$Toelichting))
          HTML(sprintf(
            '<br> <br> <details><summary>
              <h7> <center> Toelichting </center> </h7></summary>
              <p>%s</p></details>', .hv$Toelichting))
        ),
        type = .t,
        timer = 20000,
        showConfirmButton = TRUE,
        callbackR = function(x) {
          .hq$vraagNr <- .hq$vraagNr + 1
          .hq$huidigeVraag <- .hq$vragen[.hq$vragenIdx[.hq$vraagNr],]
          
          huidigeQuiz(.hq)
        }
      )
    } else {
      shinyalert(
        html = TRUE,
        title = 'Is je antwoord goed?',
        text =
          tagList(HTML(sprintf(
            '<h6>Jouw antwoord:</h6> %s <br/>',
            input$antwoord
          )),
          HTML(
            sprintf('<h6>Correcte antwoord:</h6> %s',
                    .hv[, .hv$Correct])
          ),
          if(!is.na(.hv$Toelichting))
            HTML(sprintf(
              '<br> <br> <details><summary>
              <h7> <center> Toelichting </center> </h7></summary>
              <p>%s</p></details>', .hv$Toelichting))
          ),
        timer = 20000,
        showConfirmButton = TRUE, confirmButtonText = 'Goed',
        showCancelButton = TRUE, cancelButtonText = 'Fout',
        callbackR = function(x) {
          .hq$antwoorden <- append(.hq$antwoorden, x)
          
          .hq$vraagNr <- .hq$vraagNr + 1
          .hq$huidigeVraag <- .hq$vragen[.hq$vragenIdx[.hq$vraagNr],]
          
          huidigeQuiz(.hq)
        }
      )
    }
    
  })
  
  
  output$historie <- renderUI({
    if (is.null(historyData())) {
      historyData(input$store$history)
    }
    
    if (is.null(historyData())) {
      HTML('Geen historische resultaten.')
    } else {
      column(6, align="center", offset=3, 
             div(
               id = 'table',
               DT::renderDataTable(as.data.frame(historyData()),
                             rownames = FALSE, 
               colnames = c('Datum', 'Categoriën',
                            'Aantal vragen', 'Goed (%)'))
             )
      )
    }
  })
}
