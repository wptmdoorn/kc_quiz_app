render_resultaat <- function(hq) {
  #browser()
  .format_li <- function(x) { sprintf("<li> %s </li>", x) }
  
  column(6, align="center", offset = 3,
         div(
           HTML("<h2> Einde Quiz! </h2>"),
           HTML(sprintf(paste(
                'Je hebt in totaal <b> %s vragen </b> gemaakt, <br/>',
                'hiervan had je er totaal <b> %s goed</b>. Je speelde <br/>',
                'in de volgende categorien: <br/>'), 
                hq$aantalVragen,
                sum(unlist(hq$antwoorden)))),
           HTML("<ul>"),
           HTML(paste0(lapply(unique(hq$vragen$Cat), FUN=.format_li), "")), 
           HTML("</ul>")
         ))
}