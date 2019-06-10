
nowe_utracone <- function() {

  require("httr")
  require("jsonlite")
  require(openxlsx)
  require("dplyr")
  
  
  
key <- "rAM1Tm7joQPLAXNeMXwewkjij_9fxjh-6kEaUTMhPo4"
URL <- "http://api.semstorm.com/api-v3/explorer/explorer-keywords/get-data"
ile_wynikow <- 100
domena <- array('kadromierz.pl')
rodzaj_slowa <- 'new'

# Raport nowych fraz dla domeny

# pierwszy post do wyliczenia liczby fraz i pobrania pierwszej partii fraz
POST_domena_nowe_frazy <-
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


#przetworzenie pierwszego JSON-a
JSON_domena_nowe_frazy <-
  POST_domena_nowe_frazy %>% content("text") %>% fromJSON(flatten = F)

liczba_fraz_new <- JSON_domena_nowe_frazy$results_count
ile_obrotow_new <- ceiling(liczba_fraz_new / ile_wynikow)

# pierwsza p?tla

# df zawierająca dane dla 100 fraz
frazy_i_lp_dla_domeny_new <-
  cbind(
    JSON_domena_nowe_frazy$results$keyword,
    JSON_domena_nowe_frazy$results$url,
    JSON_domena_nowe_frazy$results$position,
    JSON_domena_nowe_frazy$results$volume,
    JSON_domena_nowe_frazy$results$cpc
  )
frazy_i_lp_dla_domeny_new_Full <- frazy_i_lp_dla_domeny_new


#pętla do pobierania danych

# pobieranie danych dla 100 fraz

for (i in 1:ile_obrotow_new) {
  #Pobranie kolejnych postów
  POST_konkurencja <-
    POST(
      URL,
      content_type("application/json"),
      body = list(
        services_token = key,
        domains = domena,
        result_type = rodzaj_slowa,
        pager = list(items_per_page = ile_wynikow, page = i)
      ),
      encode = c("json")
    )
  
  #przetworzenie kolejnego JSON-a
  JSON_domena_nowe_frazy <-
    POST_konkurencja %>% content("text") %>% fromJSON(flatten = F)
  
  # df zawierająca dane dla 100 fraz
  frazy_i_lp_dla_domeny_new_2 <-
    cbind(
      JSON_domena_nowe_frazy$results$keyword,
      JSON_domena_nowe_frazy$results$url,
      JSON_domena_nowe_frazy$results$position,
      JSON_domena_nowe_frazy$results$volume,
      JSON_domena_nowe_frazy$results$cpc
    )
  
  # df docelowa zawierająca wszystkie frazy
  frazy_i_lp_dla_domeny_new_Full <-
    rbind(frazy_i_lp_dla_domeny_new_Full,
          frazy_i_lp_dla_domeny_new_2)
  
  
  
  #wyliczenie ruchu na podstawie pozycji
  
  
  for (i in 1:length(frazy_i_lp_dla_domeny_new_Full$kadromierz.pl))
    if (round(frazy_i_lp_dla_domeny_new_Full[i, 3] == 10)) {
      frazy_i_lp_dla_domeny_new_Full$Ruch[i] <-
        round(as.numeric(as.character(frazy_i_lp_dla_domeny_new_Full[i, 4])) *
                0.3258)
    } else if (round(frazy_i_lp_dla_domeny_new_Full[i, 3] == 9)) {
      frazy_i_lp_dla_domeny_new_Full$Ruch[i] <-
        round(as.numeric(as.character(frazy_i_lp_dla_domeny_new_Full[i, 4])) *
                0.1669)
    } else if (round(frazy_i_lp_dla_domeny_new_Full[i, 3] == 8)) {
      frazy_i_lp_dla_domeny_new_Full$Ruch[i] <-
        round(as.numeric(as.character(frazy_i_lp_dla_domeny_new_Full[i, 4])) *
                0.1034)
    } else if (round(frazy_i_lp_dla_domeny_new_Full[i, 3] == 7)) {
      frazy_i_lp_dla_domeny_new_Full$Ruch[i] <-
        round(as.numeric(as.character(frazy_i_lp_dla_domeny_new_Full[i, 4])) *
                0.0724)
    } else if (round(frazy_i_lp_dla_domeny_new_Full[i, 3] == 6)) {
      frazy_i_lp_dla_domeny_new_Full$Ruch[i] <-
        round(as.numeric(as.character(frazy_i_lp_dla_domeny_new_Full[i, 4])) *
                0.0527)
    } else if (round(frazy_i_lp_dla_domeny_new_Full[i, 3] == 5)) {
      frazy_i_lp_dla_domeny_new_Full$Ruch[i] <-
        round(as.numeric(as.character(frazy_i_lp_dla_domeny_new_Full[i, 4])) *
                0.0393)
    } else if (round(frazy_i_lp_dla_domeny_new_Full[i, 3] == 4)) {
      frazy_i_lp_dla_domeny_new_Full$Ruch[i] <-
        round(as.numeric(as.character(frazy_i_lp_dla_domeny_new_Full[i, 4])) *
                0.0302)
    } else if (round(frazy_i_lp_dla_domeny_new_Full[i, 3] == 3)) {
      frazy_i_lp_dla_domeny_new_Full$Ruch[i] <-
        round(as.numeric(as.character(frazy_i_lp_dla_domeny_new_Full[i, 4])) *
                0.0235)
    } else if (round(frazy_i_lp_dla_domeny_new_Full[i, 3] == 2)) {
      frazy_i_lp_dla_domeny_new_Full$Ruch[i] <-
        round(as.numeric(as.character(frazy_i_lp_dla_domeny_new_Full[i, 4])) *
                0.0186)
    } else if (round(frazy_i_lp_dla_domeny_new_Full[i, 3] == 1)) {
      frazy_i_lp_dla_domeny_new_Full$Ruch[i] <-
        round(as.numeric(as.character(frazy_i_lp_dla_domeny_new_Full[i, 4])) *
                0.0153)
    } else {
      frazy_i_lp_dla_domeny_new_Full$Ruch[i] <- 0
    }
  
  #
  #  write.xlsx(
  #   frazy_i_lp_dla_domeny_new,
  #   file = file.choose(),
  #   row.names = TRUE,
  #   col.names = TRUE,
  #   sheetName = 'nowe',
  #   append = T
  # )
  
  openxlsx::write.xlsx(x = frazy_i_lp_dla_domeny_utracone_Full, file = file.choose(new = T))
  ###########Utracone frazy
  
}
rodzaj_slowa <- 'lost'

# Raport nowych fraz dla domeny

# pierwszy post do wyliczenia liczby fraz i pobrania pierwszej partii fraz
POST_domena_utracone_frazy <-
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


#przetworzenie pierwszego JSON-a
JSON_domena_utracone_frazy <-
  POST_domena_utracone_frazy %>% content("text") %>% fromJSON(flatten = F)

liczba_fraz_utracone <- JSON_domena_utracone_frazy$results_count
ile_obrotow_utracone <-
  ceiling(liczba_fraz_utracone / ile_wynikow)

# pierwsza p?tla

# df zawierająca dane dla 100 fraz
frazy_i_lp_dla_domeny_utracone <-
  cbind(
    JSON_domena_utracone_frazy$results$keyword,
    JSON_domena_utracone_frazy$results$url,
    JSON_domena_utracone_frazy$results$position,
    JSON_domena_utracone_frazy$results$volume,
    JSON_domena_utracone_frazy$results$cpc
  )
frazy_i_lp_dla_domeny_utracone_Full <-
  frazy_i_lp_dla_domeny_utracone

###########

#pętla do pobierania danych

# pobieranie danych dla 100 fraz

for (i in 1:ile_obrotow_utracone) {
  #Pobranie kolejnych postów
  POST_konkurencja_utracone <-
    POST(
      URL,
      content_type("application/json"),
      body = list(
        services_token = key,
        domains = domena,
        result_type = rodzaj_slowa,
        pager = list(items_per_page = ile_wynikow, page = i)
      ),
      encode = c("json")
    )
  
  #przetworzenie kolejnego JSON-a
  JSON_domena_utracone_frazy <-
    POST_konkurencja_utracone %>% content("text") %>% fromJSON(flatten = F)
  print(paste(i, "z ", ile_obrotow_new, sep = " "))
  
  # df zawierająca dane dla 100 fraz
  frazy_i_lp_dla_domeny_utracone_2 <-
    cbind(
      JSON_domena_utracone_frazy$results$keyword,
      JSON_domena_utracone_frazy$results$url,
      JSON_domena_utracone_frazy$results$position,
      JSON_domena_utracone_frazy$results$volume,
      JSON_domena_utracone_frazy$results$cpc
    )
  
  
  # df docelowa zawierająca wszystkie frazy
  frazy_i_lp_dla_domeny_utracone_Full <-
    rbind(frazy_i_lp_dla_domeny_utracone_Full,
          frazy_i_lp_dla_domeny_utracone_2)
  
}
# dodanie kolumny w której będzie wyliczony ruch z pozycji
frazy_i_lp_dla_domeny_utracone_Full$Ruch <- NA

# wyliczanie ruchu z pozycji

for (i in 1:length(frazy_i_lp_dla_domeny_utracone_Full$kadromierz.pl)) {
  if (frazy_i_lp_dla_domeny_utracone_Full$kadromierz.pl[i] > 10) {
    frazy_i_lp_dla_domeny_utracone_Full$Ruch[i] <- 0
  }
}

openxlsx::write.xlsx(x = frazy_i_lp_dla_domeny_utracone_Full, file = file.choose(new = T))

}

nowe_utracone()
