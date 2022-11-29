
# Installing the packages
install.packages("httr")
install.packages("jsonlite")

# Loading packages
library(httr)
library(jsonlite)
base_url <- "https://test-api.hafslund.energydesk.no"

# Token is like a password and should be stored elsewhere/environment
token<-""
hlist <- list(Authorization=paste("Token", token))
headers <- jsonlite::toJSON(hlist, pretty=TRUE, auto_unbox=TRUE)
url<- paste(base_url,"/api/curvemanager/retrieve-forwardcurve/", sep = "")
payloadlist <- list(market_name="Nordic Power", 
                    price_area="NO1",
                    period_resolution="Daily",
                    currency_code="NOK",
                    forward_curve_model="PRICEIT")
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
pricecurve_table<-jsonlite::fromJSON(t) 
pricecurve_table <- pricecurve_table[ , -c(4) ]
print(head(pricecurve_table))   # Price Curve

# Yield curve
url<- paste(base_url,"/api/currencies/yieldcurves/", sep = "")
resp <- GET(
  url = url,
  query = list(country = "NOK"),
  add_headers (
    "Content-Type" = "application/json",
    "Authorization" = paste("Token", token)
  )
)
# You may check resp to see that API call is OK (returning code 200)
t <- content(resp, as="parsed",  encoding = "UTF-8")
yieldcurve_table<-jsonlite::fromJSON(t) 
print(head(yieldcurve_table))
yield_df <- as.data.frame(yieldcurve_table)


periods<-list(period_tag="FWDNO1-BASE-JAN3YR",contract_date_from="2023-01-01", contract_date_until="2026-01-01")
monthly_prof<-c("December","January", "February")
weekday_prof<-c("Monday", "Tuesday")
dayprofile_prof<-c(7,8,9,10,11,12,13,14)
url<- paste(base_url,"/api/bilateral/contractpricer/", sep = "")
# Specify contract_type as BASELOAD to override monthly/weekday profile
payloadlist <- list(currency_code="NOK", 
                    price_area="NO1",
                    period_resolution="Daily", # Alternative Hourly if dayprofile is used on individual hours.  
                    contract_type="BASELOAD",
                    periods=list(periods),
                    curve_model="PRICEIT",
                    monthly_profile=monthly_prof,
                    weekday_profile=weekday_prof,
                    daily_profile=dayprofile_prof
                    )

payload <- jsonlite::toJSON(payloadlist, pretty=TRUE, auto_unbox=TRUE)
print(payload)
resp <- POST(
  url = url,
  body = payload,
  add_headers (
    "Content-Type" = "application/json",
    "Authorization" = paste("Token", token)
  )
)
#print(resp)
t <- content(resp, as="parsed",  encoding = "UTF-8")

for (period in t[['period_prices']]) {
  print(period[['period_tag']])
  print("Calculated fixed price")
  print(period[['contract_price']])
  print("Calculated mean price")
  print(period[['mean_price']])
  details_dict<-jsonlite::fromJSON(period[['pricing_details']]) 
  pricing_details_df <- as.data.frame(details_dict)
  print(head(pricing_details_df))
}

