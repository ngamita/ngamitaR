# Dive into Analytics. 
# Loading the RGoogleAnalytics library
require("RGoogleAnalytics")

# 1. Authorize your account and paste the accesstoken 
query <- QueryBuilder()
access_token <- 'ya29.AHES6ZTxIqmfITivRcBM1crBHxN81iDakEEEUbbgldfHhQ'                                            

# 2. Create a new Google Analytics API object
ga <- RGoogleAnalytics()
ga.profiles <- ga$GetProfileData(access_token)

# List the GA profiles 
ga.profiles

# 3. Build the query string, use the profile by setting its index value 
query$Init(start.date = "2013-04-01",
					 end.date = "2013-09-30",
					 dimensions = "ga:deviceCategory",
					 metrics = "ga:visits",
					 #sort = "ga:visits",
					 #filters="",
					 #segment="",
					 max.results = 200000000,
					 table.id = paste("ga:",ga.profiles$id[6],sep="",collapse=","),
					 access_token=access_token)

# 4. Make a request to get the data from the API
ga.data <- ga$GetReportData(query)

# 5. Look at the returned data
head(ga.data)