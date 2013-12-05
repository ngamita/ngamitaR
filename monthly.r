## Automate Status script. 
## __Author__ 'ngamita@refunite.org'

# Fix warning --> set quote = ""
add_sql <- read.csv('rusql.csv', header=F, sep=',', quote = "", as.is = T, 
										row.names = NULL, 
										na.strings = c("", "\\N")) # load sql dump, Df called add_sql

# Fix the date readability/ column names. 

names(add_sql) <- c( 'id', 'owningMonitorProfile_id', 'owningPartner_id', 'createDate', 'userProfileState_id')

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
regs <- subset(state_sql, as.Date(createDate) >= '2013-01-01')

## Assited regs with owningMonitorProfile_id not null
## Groups the data on a monthly basis below or next line. 
assisted <- regs[!is.na(regs$owningMonitorProfile_id), ]
aggregate(assisted$id,by=list((substr(assisted$createDate,1,7))),length) 


## group count(id) by monthly. 
## Total monthlt registrations below. 
aggregate(regs$id,by=list((substr(regs$createDate,1,7))),length) 

regs_month <- subset(state_sql, as.Date(createDate) >= '2013-11-01' & as.Date(createDate) <= '2013-11-30')


## Redcross stats and regs
redcross_ovs <- regs[regs$owningPartner_id %in% c(9,10), ]
unique_ovs <- aggregate(redcross_ovs$owningMonitorProfile_id, 
													 by=list(redcross_ovs$id), FUN=length)
#ovsgma <- paste(as.character(unique_ovs$Group.1), collapse=", ")
ov_regs_redcross <- regs_month[as.character(regs_month$owningMonitorProfile_id) %in% unique_ovs$Group.1, ] # Fixed
nrow()


## Tadamon stats and regs
kampala_ovs <- regs[regs$owningPartner_id %in% c(12), ]
unique_ovs <- aggregate(kampala_ovs$owningMonitorProfile_id, 
												by=list(kampala_ovs$id), FUN=length)
#ovsgma <- paste(as.character(unique_ovs$Group.1), collapse=", ")
ov_regs_kampala <- regs_month[as.character(regs_month$owningMonitorProfile_id) %in% unique_ovs$Group.1, ] # Error issue showing 0 :()
nrow(ov_regs_kampala)

## Kampala stats and regs
kampala_ovs <- regs[regs$owningPartner_id %in% c(12), ]
unique_ovs <- aggregate(kampala_ovs$owningMonitorProfile_id, 
												by=list(kampala_ovs$id), FUN=length)
#ovsgma <- paste(as.character(unique_ovs$Group.1), collapse=", ")
ov_regs_kampala <- regs_month[as.character(regs_month$owningMonitorProfile_id) %in% unique_ovs$Group.1, ] # Error issue showing 0 :()
nrow(ov_regs_kampala)



## Omit the NAs
## na.omit(add_sql$createDate)
## Fix the dates readability (Char - as.Date conversion)
#add_sql$createDate <- as.Date(as.character(add_sql$createDate),  format="%Y-%m-%d")
add_mongo <- read.csv('refunite.csv', header=T, sep=',')  # load Mongo dump, Df called add_mongo
head(add_mongo)
add_mongo$createdAt <- as.Date(add_mongo$createdAt, format="%Y-%m-%d")

acts <- subset(add_mongo, as.Date(createdAt) >= '2013-01-01' 
							 & as.Date(createdAt) < '2013-11-01')


# Say we want to pick unique logins -> sieve only the logins. 
add_mongo_logins <- acts[acts$actionType %in% c(104), ]
unique_logins <- aggregate(add_mongo_logins$actionType, 
													 by=list(add_mongo_logins$actingUserProfileId), FUN=length)
#unique_logins
#aggregate(add_mongo_logins$actionType,by=list((substr(add_mongo_logins$createdAt,1,7))),length) 

#nrow(unique_logins)



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
