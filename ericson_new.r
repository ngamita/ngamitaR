## Automate Status script. 
## __Author__ 'ngamita@refunite.org'

## Set the working directory. 


# Fix warning --> set quote = ""
add_sql <- read.csv('rusql.csv', header=F, sep=',', quote = "", as.is = T, 
										row.names = NULL, 
										na.strings = c("", "\\N")) # load sql dump, Df called add_sql

# Fix the date readability/ column names. 

names(add_sql) <- c( 'id', 'owningMonitorProfile_id', 'owningPartner_id', 'dialCode', 
										 'createDate', 'userProfileState_id')

# Fixing dates issue hacked. 
setClass("myDate")
setAs("character","myDate", function(from) as.Date(from, format="%Y-%m-%d %H:%M:%S") )
tmp <- add_sql$createDate
con <- textConnection(tmp)
dates <- read.csv(con, colClasses=c('myDate'), header=FALSE) # It's a DF. so dates$V1
add_sql$createDate <- dates$V1
#str(dates)

## subset and Pick all ids with userProfilestate_id in (1,2)
#Subset by condition: 
state_sql <- add_sql[add_sql$userProfileState_id %in% c(1, 2), ]

#Subset by dates:
#regs_accum <- subset(state_sql, as.Date(createDate) < '2013-07-01')
#regs <- subset(state_sql, as.Date(createDate) >= '2013-01-01')


## Pick the constants for start and end dates
## Find a way to fix this called from user TODO: @ngamita
start_date <- '2013-11-01'
end_date <- '2013-11-30'
weekly_regs <- subset(state_sql, as.Date(createDate) >= start_date 
											& as.Date(createDate) <= end_date )
#nrow(weekly_regs)


## Subset by OwningMonitorProfile_id is not NA
## to find all assited registrations.
assisted <- subset(weekly_regs, !is.na(weekly_regs$owningMonitorProfile_id))
nrow(assisted)

## Organic signups. 
organic <- subset(weekly_regs, is.na(weekly_regs$owningMonitorProfile_id))

## Subset by KE or "+254" country code
## This means only KE lines here for registrations. 
#weekly_ke <- weekly_regs[grep("+254", weekly_regs$dialCode),] 
#nrow(weekly_ke)




## Mongo data load.
add_mongo <- read.csv('refunite.csv', header=T, sep=',')  # load Mongo dump, Df called add_mongo
head(add_mongo)
add_mongo$createdAt <- as.Date(add_mongo$createdAt, format="%Y-%m-%d")


start_date <- '2013-08-01'
end_date <- '2013-10-31'
acts <- subset(add_mongo, as.Date(createdAt) >= start_date
							 & as.Date(createdAt) <= end_date )

## Subset by 100 account creation 
month_acts <- acts[grep("100", acts$actionType),] 
nrow(month_acts)

## Subset by "+xxx" country code.
month_ctry <- month_acts[grep("+256", month_acts$data.dialCode),] 
nrow(month_ctry)




# Say we want to pick unique logins -> sieve only the logins. 
add_mongo_logins <- acts[acts$actionType %in% c(104), ]
unique_logins <- aggregate(add_mongo_logins$actionType, 
													 by=list(add_mongo_logins$actingUserProfileId), FUN=length)
#unique_logins
#aggregate(add_mongo_logins$actionType,by=list((substr(add_mongo_logins$createdAt,1,7))),length) 

#nrow(unique_logins)

## Sieve the unique accounts. 
unique_login_a <- subset(unique_logins, unique_logins$x >=2)
#accounts <- paste(as.character(unique_login_a$Group.1), collapse=", ")

## Go back in time, will all the data *** even state_sql not enuff. 
## Use add_sql find also status = 4 or deleted accounts
df <- add_sql[add_sql$id %in% unique_login_a$Group.1, ]

## Why is there a diff , ok this will tell you so. 
## Apparently deleted accounts :) sweet. userProfileState_id = 4
##miss <- setdiff(unique_login_a$Group.1, df$id)
##missin <- paste(as.character(miss), collapse=", ")


