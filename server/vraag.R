renderOpenVraag <- function(huidige_quiz) {
  .hv <- huidige_quiz$huidigeVraag
  .hq <- huidige_quiz
  
  column(6, align="center", offset = 3,
         div(
           HTML(
             sprintf(
               '<h2> Vraag %d/%d </h2> <h5> <p style="color:#808080">%s</p> </h5>',
               .hq$vraagNr,
               .hq$aantalVragen,
               .hv$Cat
             )
           ),
           HTML(sprintf('<h4> %s </h4>', .hv$Vraag)),
           
           textAreaInput('antwoord', '',
                         width = '100%',),
           
           actionButton('submitVraag',
                        'Submit!')
         ))
}

renderMCVraag <- function(huidige_quiz) {
  .hv <- huidige_quiz$huidigeVraag
  .hq <- huidige_quiz
  
  .l <- c("A1", "A2", "A3", "A4")
  names(.l) <- c(.hv$A1, .hv$A2, .hv$A3, .hv$A4)
  
  column(6, align="center", offset = 3,
         div(
           HTML(
             sprintf(
               '<h2> Vraag %d/%d </h2> <h5> <p style="color:#808080">%s</p> </h5>',
               .hq$vraagNr,
               .hq$aantalVragen,
               .hv$Cat
             )
           ),
           HTML(sprintf('<h4> %s </h4>', .hv$Vraag)),
           
           selectInput('antwoord', '', width = '100%',
                       .l, selectize = FALSE),
           
           actionButton('submitVraag',
                        'Submit!')
         ))
}

renderTFVraag <- function(huidige_quiz) {
  .hv <- huidige_quiz$huidigeVraag
  .hq <- huidige_quiz
  
  .l <- c("A1", "A2")
  names(.l) <- c(.hv$A1, .hv$A2)
  
  column(6, align="center", offset = 3,
         div(
           HTML(
             sprintf(
               '<h2> Vraag %d/%d </h2> <h5> <p style="color:#808080">%s</p> </h5>',
               .hq$vraagNr,
               .hq$aantalVragen,
               .hv$Cat
             )
           ),
           HTML(sprintf('<h4> %s </h4>', .hv$Vraag)),
           
           selectInput('antwoord', '', width = '100%',
                       .l, selectize = FALSE),
           
           actionButton('submitVraag',
                        'Submit!')
         ))
}

render_vraag <- function(huidige_quiz) {
  .c <- huidige_quiz$huidigeVraag$Type
  print(.c)
  
  if (.c == 'OPEN') {
    print('open vraag')
    renderOpenVraag(huidige_quiz)
  } else if (.c == 'MC') {
    print('mc vraag')
    renderMCVraag(huidige_quiz)
  } else if (.c == 'TRUEFALSE') {
    print('t-f vraag')
    renderTFVraag(huidige_quiz)
  } else {
    print('geen type')
  }
}
