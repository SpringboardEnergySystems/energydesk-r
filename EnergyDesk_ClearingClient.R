
# Installing the packages
install.packages("httr")
install.packages("jsonlite")

# Loading packages
library(httr)
library(jsonlite)

# Token is like a password and should be stored elsewhere/environment
token<-""
hlist <- list(Authorization=paste("Token", token))
headers <- jsonlite::toJSON(hlist, pretty=TRUE, auto_unbox=TRUE)
url<- "https://dev.heco.energydesk.no/api/clearing/query_clearing_report_data/"
payloadlist <- list(clearing_report_type="POSITIONS", 
                    from_datetime="2022-08-01T00:00:00+00:00",
                    to_datetime="2022-08-13T00:00:00+00:00",
                    clearing_house="NASDAQOMX")
payload <- jsonlite::toJSON(payloadlist, pretty=TRUE, auto_unbox=TRUE)
payload
resp <- POST(
  url = url,
  body = payload,
  add_headers (
    "Content-Type" = "application/json",
    "Authorization" = paste("Token", token)
  )
)
# You may check resp to see that API call is OK (returning code 200)
t <- content(resp, as="parsed",  encoding = "UTF-8")
data_table<-jsonlite::fromJSON(t) 
data_table


