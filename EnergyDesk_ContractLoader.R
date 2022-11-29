
# Installing the packages
install.packages("httr")
install.packages("jsonlite")

# Loading packages
library(httr)
library(jsonlite)

# Token is like a password and should be stored elsewhere/environment
base_url="http://127.0.0.1:8001"
token<-"f055196eec79742e0d46fe3a5e31b1d2ae8df7ce"
hlist <- list(Authorization=paste("Token", token))
headers <- jsonlite::toJSON(hlist, pretty=TRUE, auto_unbox=TRUE)
url<- paste(base_url,"/api/portfoliomanager/tradingbook/")
payload <- jsonlite::toJSON(payloadlist, pretty=TRUE, auto_unbox=TRUE)
payload
resp <- GET(
  url = url,
  add_headers (
    "Content-Type" = "application/json",
    "Authorization" = paste("Token", token)
  )
)
# You may check resp to see that API call is OK (returning code 200)
t <- content(resp, as="text",  encoding = "UTF-8")
tradingbooks_data_table<-jsonlite::fromJSON(t) 
tradingbooks_data_table


payloadlist <- list(trading_book_key=1, 
                    last_trades_count=0)  #0 means all records, N means N latest contracts
payload <- jsonlite::toJSON(payloadlist, pretty=TRUE, auto_unbox=TRUE)
url<- paste(base_url,"/api/portfoliomanager/query_contracts_ext/")
resp <- POST(
  url = url,
  body = payload,
  add_headers (
    "Content-Type" = "application/json",
    "Authorization" = paste("Token", token)
  )
)
t <- content(resp, as="text",  encoding = "UTF-8")
tradingbooks_data_table<-jsonlite::fromJSON(t) 
tradingbooks_data_table
