#pobieranie danych z API http://api.semstorm.com/?api=explorer

require("httr")
require("jsonlite")
key <- "rAM1Tm7joQPLAXNeMXwewkjij_9fxjh-6kEaUTMhPo4"
domena <- array('poradnikpracownika.pl/-ile-zarabia-przedstawiciel-handlowy-poznaj-tajniki-tego-zawodu')
domena2 <- array('poradnikpracownika.pl')

# liczba słów dla domeny 
URL_slowa_domena <-"http://api.semstorm.com/api-v3/explorer/explorer-keywords/basic-stats.json"
POST_slowa_domena<-POST(URL_slowa_domena, content_type("application/json"),body = list(services_token = key, domains = domena2),encode = c("json"))
pobierz_JSON_slowa_domena<-content(POST_slowa_domena, "text")
przetworz_JSON_slowa_domena <-fromJSON(pobierz_JSON_slowa_domena, flatten = F)

#liczba słów w top 50
przetworz_JSON_slowa_domena$results$poradnikpracownika.pl$keywords

#liczba słów w top 10
przetworz_JSON_slowa_domena$results$poradnikpracownika.pl$keywords_top
