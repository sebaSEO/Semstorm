require("httr")
require("jsonlite")
key <- "***"
kamp_id <- '***'


# pobranie ID kampanii na koncie (pobiera listę ID wszystkich aktywnych kampanii na koncie). Możliwe dodatkowe filtrowanie (np. po domenie)

URL_ID <- "http://api.semstorm.com/api-v3/monitoring/monitoring-campaign/get-list.json"
POST_ID <- POST(URL_ID, content_type("application/json"), body = list(services_token = key, pager= list(items_per_page = 100, page = 0), status = "active"), encode = c("json"))
pobierz_JSON_ID<-content(POST_ID, "text")
przetworz_JSON_ID <-fromJSON(pobierz_JSON_ID, flatten = F)
lista_ID_kampanii <- przetworz_JSON_ID$results$campaigns$id


# dane szcz. kampanii

w4<- paste("http://api.semstorm.com/api-v3/monitoring/monitoring-campaign/get-overview-data.json?services_token=", key, sep = "")
wojciech4 <- POST(w4, content_type("application/json"))
z_api_wojciech4<-content(wojciech4, "text")
z_api_wojciech4_json$results <-fromJSON(z_api_wojciech4, flatten = F)

ID_kampanii <- list()
i <- 1
for (i in 1:length(a)) {

  ID_kampanii[i]<- a[[i]]$id 
}



# dane konkretnej kampanii

pozycje <- "http://api.semstorm.com/api-v3/monitoring/monitoring-campaign/get-data.json?"
post_pozycje <- POST(pozycje, content_type("application/json"), body = list(id=kamp_id, services_token=key), encode = c("json"))
pozycje_json <- content(post_pozycje, "text")
pozycje_df <-fromJSON(pozycje_json, flatten = F)
pozycje_df$results[[1]]$pracuj.pl$`55174`$keyword$title
pozycje_df$results[[1]]$pracuj.pl$`55174`$keyword$volume
pozycje_df$results[[1]]$pracuj.pl$`55174`$data$`2019-04-26`$google$desktop[[1]]$url
pozycje_df$results[[1]]$pracuj.pl$`55174`$data$`2019-04-26`$google$desktop[[1]]$position
