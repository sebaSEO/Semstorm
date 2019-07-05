#instalowanie koniecznych bibliotek

  library("httr")
  library("jsonlite")
  library("openxlsx")
  library("dplyr")
  
  URL <-"http://api.semstorm.com/api-v3/explorer/explorer-keywords/get-data"
  ile_wynikow <- 100
  
  
  EntryBox <- function(label = 'Klucz', title = 'Podaj swój klucz API') {
    tt <- tktoplevel()
    tkwm.title(tt, title)   
    done <- tclVar(0)
    tkbind(tt,"<Destroy>", function() tclvalue(done) <- 2)
    result <- tclVar("")
    cancel.but <- tkbutton(tt, text='Zamknij', command=function() tclvalue(done) <- 2)
    submit.but <- tkbutton(tt, text="Dodaj", command=function() tclvalue(done) <- 1)
    tkgrid(tklabel(tt, text=label),  tkentry(tt, textvariable=result), pady=3, padx=3)
    tkgrid(submit.but, cancel.but, pady=3, padx=3)
    tkfocus(tt)
    tkwait.variable(done)
    if(tclvalue(done) != 1) result <- "" else result <- tclvalue(result)
    tkdestroy(tt)
    return(result)
  }
  
  key <- EntryBox(label = 'Podaj swój klucz API '); x
  #
  
  EntryBox <- function(label = 'Domena', title = 'Wpisz domenę') {
    tt <- tktoplevel()
    tkwm.title(tt, title)   
    done <- tclVar(0)
    tkbind(tt,"<Destroy>", function() tclvalue(done) <- 2)
    result <- tclVar("")
    cancel.but <- tkbutton(tt, text='Zamknij', command=function() tclvalue(done) <- 2)
    submit.but <- tkbutton(tt, text="Dodaj", command=function() tclvalue(done) <- 1)
    tkgrid(tklabel(tt, text=label),  tkentry(tt, textvariable=result), pady=3, padx=3)
    tkgrid(submit.but, cancel.but, pady=3, padx=3)
    tkfocus(tt)
    tkwait.variable(done)
    if(tclvalue(done) != 1) result <- "" else result <- tclvalue(result)
    tkdestroy(tt)
    return(result)
  }
  
  domena <- EntryBox(label = 'Wpisz domenę'); x
  
  
  domena <- array(domena)
  
  # dostępne rodzaje słowa new/all/lost
  rodzaj_slowa <- "all"
  
  # pierwsza pętla słowa new
  
  POST_1_new <-
    POST(
      URL,
      content_type("application/json"),
      body = list(
        services_token = key,
        domains = domena,
        keywords_type = rodzaj_slowa,
        pager = list(items_per_page = ile_wynikow, page = 0)
      ),
      encode = c("json")
    )
  
  # przetworzenie pierwszego JSON-a
  JSON_1_new <-
    POST_1_new %>% content("text") %>% fromJSON(flatten = F)
  
  liczba_fraz_new <- JSON_1_new$results_count
  ile_obrotow_new <- floor(liczba_fraz_new / ile_wynikow)
  
  # zapisanie wyników pierwszej pętli
  
  frazy_new_Full <-
    cbind(
      JSON_1_new$results$keyword,
      JSON_1_new$results$url,
      JSON_1_new$results$position,
      JSON_1_new$results$volume,
      JSON_1_new$results$cpc,
      Sys.Date()
    )
  colnames(frazy_new_Full) <-c("fraza", "lp", "pozycja", "ilośc wyszukań", "cpc", "data")
  
  #kolejne pętle frazy new
  
  for (i in 1:ile_obrotow_new) {
    # Pobranie kolejnych postów
    POST_next_new <-
      POST(
        URL,
        content_type("application/json"),
        body = list(
          services_token = key,
          domains = domena,
          keywords_type = rodzaj_slowa,
          pager = list(items_per_page = ile_wynikow, page = i)
        ),
        encode = c("json")
      )
    
    #  # przetworzenie kolejnego JSON-a
    JSON_next_new <-
      POST_next_new %>% content("text") %>% fromJSON(flatten = F)
    
    
    frazy_new_Part <- cbind(
      JSON_next_new$results$keyword,
      JSON_next_new$results$url,
      JSON_next_new$results$position,
      JSON_next_new$results$volume,
      JSON_next_new$results$cpc,
      Sys.Date()
    )
    
    
    colnames(frazy_new_Part) <-c("fraza", "lp", "pozycja", "ilośc wyszukań", "cpc", "data")
    
    # połączeniu plików (pierwsza pętla i kolejne)
    
    frazy_new_Full <-
      rbind(frazy_new_Full,
            frazy_new_Part)
  }
  
  # wyliczanie ruchu na podstawie pozycji wg. https://www.advancedwebranking.com/ctrstudy/
  
  
  for (i in 1:length(frazy_new_Full$pozycja))
    if (frazy_new_Full[i, 3] == 10) {
      frazy_new_Full$Ruch[i] <-
        round(as.numeric(as.character(frazy_new_Full[i, 4])) * 0.0112)
    } else if (frazy_new_Full[i, 3] == 9) {
      frazy_new_Full$Ruch[i] <-
        round(as.numeric(as.character(frazy_new_Full[i, 4])) * 0.0136)
    } else if (round(frazy_new_Full[i, 3] == 8)) {
      frazy_new_Full$Ruch[i] <-
        round(as.numeric(as.character(frazy_new_Full[i, 4])) * 0.0168)
    } else if (round(frazy_new_Full[i, 3] == 7)) {
      frazy_new_Full$Ruch[i] <-
        round(as.numeric(as.character(frazy_new_Full[i, 4])) * 0.0217)
    } else if (round(frazy_new_Full[i, 3] == 6)) {
      frazy_new_Full$Ruch[i] <-
        round(as.numeric(as.character(frazy_new_Full[i, 4])) * 0.0301)
    } else if (round(frazy_new_Full[i, 3] == 5)) {
      frazy_new_Full$Ruch[i] <-
        round(as.numeric(as.character(frazy_new_Full[i, 4])) * 0.0421)
    } else if (round(frazy_new_Full[i, 3] == 4)) {
      frazy_new_Full$Ruch[i] <-
        round(as.numeric(as.character(frazy_new_Full[i, 4])) * 0.0618)
    } else if (round(frazy_new_Full[i, 3] == 3)) {
      frazy_new_Full$Ruch[i] <-
        round(as.numeric(as.character(frazy_new_Full[i, 4])) * 0.0989)
    } else if (round(frazy_new_Full[i, 3] == 2)) {
      frazy_new_Full$Ruch[i] <-
        round(as.numeric(as.character(frazy_new_Full[i, 4])) * 0.1529)
    } else if (round(frazy_new_Full[i, 3] == 1)) {
      frazy_new_Full$Ruch[i] <-
        round(as.numeric(as.character(frazy_new_Full[i, 4])) * 0.3128)
    } else {
      frazy_new_Full$Ruch[i] <- 0
    }
  
  frazy_new_Full <-frazy_new_Full[order(-frazy_new_Full$Ruch), ]
  
  frazy_new_Full_Grupowanie <-
    frazy_new_Full %>% group_by(lp) %>% summarise(
      ile_fraz = n(),
      ile_Ruchu = sum(Ruch),
      sr_pozycja = mean(as.numeric(pozycja)),
      ile_wyszukan = sum(as.numeric(`ilośc wyszukań`)),
      Data = Sys.Date()
    )
  
  frazy_new_Full_Grupowanie <-frazy_new_Full_Grupowanie[order(-frazy_new_Full_Grupowanie$ile_wyszukan), ]
  
  write.xlsx(
    x = frazy_new_Full_Grupowanie, 
    file = file.choose(new = T)
    )
  
  
  write.xlsx(
    frazy_new_Full,
    file = file.choose(new = T),
    row.names = TRUE,
    col.names = TRUE,
    sheetName = 'nowe',
    append = T
  )
