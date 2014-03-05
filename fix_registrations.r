## Automate Status script. 
## __Author__ 'ngamita@refunite.org'

## Set the working directory. 


# Fix warning --> set quote = ""
add_sql <- read.csv('rusql.csv', header=F, sep=',', quote = "", as.is = T, 
										row.names = NULL, 
										na.strings = c("", "\\N")) # load sql dump, Df called add_sql

# Fix the date readability/ column names. 

names(add_sql) <- c( 'id', 'owningMonitorProfile_id', 'owningPartner_id', 'dialCode', 'createDate', 'userProfileState_id')

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
start_date <- '2013-11-18'
end_date <- '2013-11-24'
weekly_regs <- subset(state_sql, as.Date(createDate) >= start_date 
											& as.Date(createDate) <= end_date )
#nrow(weekly_regs)


## Subset by KE or "+254" country code
## This means only KE lines here for registrations. 
weekly_ke <- weekly_regs[grep("+254", weekly_regs$dialCode),] 
nrow(weekly_ke)

## Active users related to logins. 




## Assited regs with owningMonitorProfile_id not null
#assisted <- regs[!is.na(regs$owningMonitorProfile_id), ]
#aggregate(assisted$id,by=list((substr(assisted$createDate,1,7))),length) 


## group count(id) by monthly. 
#aggregate(regs$id,by=list((substr(regs$createDate,1,7))),length) 


## Redcross stats and regs
#redcross_ovs <- regs[regs$owningPartner_id %in% c(9,10), ]
#unique_ovs <- aggregate(redcross_ovs$owningMonitorProfile_id, 
												by=list(redcross_ovs$id), FUN=length)
#ovsgma <- paste(as.character(unique_ovs$Group.1), collapse=", ")
#ov_regs <- regs[regs$owningMonitorProfile_id %in% ovs, ] # Error issue showing 0 :()



## Kampala OVs stats and regs
##kampala_ovs <- regs[regs$owningPartner_id %in% c(365102,385775,386948,387235,387236,387544,388833,398432), ]
##												by=list(redcross_ovs$id), FUN=length)
#ovs <- paste(as.character(unique_ovs$Group.1), collapse=", ")
#ov_regs <- regs[regs$owningMonitorProfile_id %in% ovs, ] # Error issue showing 0 :()


## Omit the NAs
## na.omit(add_sql$createDate)
## Fix the dates readability (Char - as.Date conversion)
#add_sql$createDate <- as.Date(as.character(add_sql$createDate),  format="%Y-%m-%d")
add_mongo <- read.csv('refunite.csv', header=T, sep=',')  # load Mongo dump, Df called add_mongo
head(add_mongo)
add_mongo$createdAt <- as.Date(add_mongo$createdAt, format="%Y-%m-%d")

start_date <- '2013-10-07'
end_date <- '2013-10-13'
acts <- subset(add_mongo, as.Date(createdAt) >= start_date
							 & as.Date(createdAt) <= end_date )


# Say we want to pick unique logins -> sieve only the logins. 
add_mongo_logins <- acts[acts$actionType %in% c(104), ]
unique_logins <- aggregate(add_mongo_logins$actionType, 
													 by=list(add_mongo_logins$actingUserProfileId), FUN=length)
#unique_logins
#aggregate(add_mongo_logins$actionType,by=list((substr(add_mongo_logins$createdAt,1,7))),length) 

#nrow(unique_logins)


#Months JFMAMJJASOND

# Loop and find all those logins >=2 

loop = 0
for (i in 1:length(unique_logins$x)){
	if (unique_logins$x[i] >= 1) {
		loop = loop + 1
	}
}

loop






















#follow above for the unique others TODO: 
add_mongo_search <- acts[acts$actionType %in% c(200), ]
unique_search <- aggregate(add_mongo_search$actionType, by=list(add_mongo_search$actingUserProfileId), FUN=length)
#unique_search
#nrow(unique_search)
nrow(add_mongo_search)

#Messages sent follow 
add_mongo_msgs <- acts[acts$actionType %in% c(300), ]
unique_msgs <- aggregate(add_mongo_msgs$actionType, by=list(add_mongo_msgs$actingUserProfileId), FUN=length)
#unique_msgs
#nrow(unique_msgs)
nrow(add_mongo_msgs)

#Messages read
add_mongo_read <- acts[acts$actionType %in% c(301), ]
unique_read <- aggregate(add_mongo_read$actionType, by=list(add_mongo_read$actingUserProfileId), FUN=length)
#unique_msgs
#nrow(unique_read)
nrow(add_mongo_read)
