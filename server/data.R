library(readxl)
library(dplyr)
library(googledrive)
library(googlesheets4)

load_quiz_data <- function() {
  data <- readxl::read_excel('data/quiz.xlsx')
  
  data %>%
    dplyr::filter(!is.na(Cat)) %>%
    dplyr::filter(!is.na(Type))
}

load_quiz_drive_data <- function() {
  googledrive::drive_auth(use_oob = TRUE)
  googlesheets4::gs4_auth(token = drive_token())
  
  data <-
    googlesheets4::read_sheet('10_nzLc4-o_6gUuROKWOSGGARvtxrzYUcBg4MSq5C1H8')
  
  data %>%
    dplyr::filter(!is.na(Cat)) %>%
    dplyr::filter(!is.na(Type)) %>%
    mutate(A1 = as.character(A1)) %>%
    mutate(A2 = as.character(A2)) %>%
    mutate(A3 = as.character(A3)) %>%
    mutate(A4 = as.character(A4))
}

append_historical_results <- function(hq, history) {
  
  if (is.null(history)) {
    return(data.frame(Time = as.character(Sys.Date()),
                      Cats = paste(unique(hq$vragen$Cat), collapse=", "),
                      Aantal = hq$aantalVragen,
                      PercGoed = (sum(unlist(hq$antwoorden)) / hq$aantalVragen) * 100
                      ))
  } else {
    return(rbind(as.data.frame(history),
                 data.frame(Time = as.character(Sys.Date()),
                            Cats = paste(unique(hq$vragen$Cat), collapse=", "),
                            Aantal = hq$aantalVragen,
                            PercGoed = (sum(unlist(hq$antwoorden))/ hq$aantalVragen) * 100
                 )))
  }
}