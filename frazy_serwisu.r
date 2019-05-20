require("httr")
require("jsonlite")
key <- "***" # tu wstaw swój klucz APi
URL<- "http://api.semstorm.com/api-v3/explorer/explorer-keywords/get-data.json"

domena <- array() #tu wstaw domenę do sprawdzenia
ile_wynikow <- 100


# pierwszy post do wyliczenia liczby fraz i pobrania pierwszej partii fraz
POST_konkurencja<-POST(URL, content_type("application/json"),body = list(services_token = key, domains = domena, pager= list(items_per_page = ile_wynikow, page=0)),encode = c("json"))


#przetworzenie pierwszego JSON-a
pobierz_JSON_konkurencja<-content(POST_konkurencja, "text")
przetworz_JSON_konkurencja <-fromJSON(pobierz_JSON_konkurencja, flatten = F)

# wyliczanie ile obrotów pętli dla słów 
liczba_fraz <- przetworz_JSON_konkurencja$results_count
ile_obrotow <- ceiling(liczba_fraz / ile_wynikow)



# df zawierająca dane dla 100 fraz
frazy_i_lp_dla_domeny <- cbind(przetworz_JSON_konkurencja$results$keyword, przetworz_JSON_konkurencja$results$url, przetworz_JSON_konkurencja$results$position)

# df docelowa zawierająca wszystkie frazy 
frazy_i_lp_dla_domenyFull <- frazy_i_lp_dla_domeny


#pętla do pobierania danych 

# pobieranie danych dla 100 fraz

for (i in 1:ile_obrotow) {

#Pobranie kolejnych postów
POST_konkurencja<-POST(URL, content_type("application/json"),body = list(services_token = key, domains = domena, pager= list(items_per_page = ile_wynikow, page=i)),encode = c("json"))

#przetworzenie kolejnego JSON-a
pobierz_JSON_konkurencja<-content(POST_konkurencja, "text")
przetworz_JSON_konkurencja <-fromJSON(pobierz_JSON_konkurencja, flatten = F)


# df zawierająca dane dla 100 fraz
frazy_i_lp_dla_domeny <- cbind(przetworz_JSON_konkurencja$results$keyword, przetworz_JSON_konkurencja$results$url, przetworz_JSON_konkurencja$results$position)

# df docelowa zawierająca wszystkie frazy 
frazy_i_lp_dla_domenyFull <- rbind(frazy_i_lp_dla_domenyFull, frazy_i_lp_dla_domeny)

}

print(frazy_i_lp_dla_domenyFull)
