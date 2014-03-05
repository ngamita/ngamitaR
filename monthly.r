## Automate Status script. 
## This is the main code 
## for the KPIs document at http://goo.gl/k3FE7y
## Kind of manual but work in progress 
## __Author__ 'ngamita@refunite.org'

# Fix warning --> set quote = ""
# Load the data into Rstudio memory. 
# CSVs always come in handy ofcourse. 

add_sql <- read.csv('rusql.csv', header=F, sep=',', quote = "", as.is = T, 
										row.names = NULL, 
										na.strings = c("", "\\N")) # load sql dump, Df called add_sql

# Fix the date readability/ column names. 
# give the columsn some nice names :). 

names(add_sql) <- c( 'id', 'owningMonitorProfile_id', 'owningPartner_id', 
										 'dialCode', 'createDate', 'userProfileState_id')

# Fixing dates issue hacked. 
# TODO: This is a fake hack 
# fix this to change dates
# to a format that is well readable. 

setClass("myDate")
setAs("character","myDate", function(from) as.Date(from, format="%Y-%m-%d %H:%M:%S") )
tmp <- add_sql$createDate
con <- textConnection(tmp) 
dates <- read.csv(con, colClasses=c('myDate'), header=FALSE) # It's a DF. so dates$V1
add_sql$createDate <- dates$V1
#str(dates)

## subset and Pick all ids with userProfilestate_id in (1,2)
#Subset by condition: 
## UserProfileStates (1,2) represent
state_sql <- add_sql[add_sql$userProfileState_id %in% c(1, 2), ]

#Subset by dates:
#regs_accum <- subset(state_sql, as.Date(createDate) < '2013-07-01')
#regs <- subset(state_sql, as.Date(createDate) >= '2013-01-01')


## group count(id) by monthly. 
## Total monthlt registrations below. 
## aggregate(regs$id,by=list((substr(regs$createDate,1,7))),length) # grouped totals

regs_month <- subset(state_sql, as.Date(createDate) >= '2013-12-01' &
										 	as.Date(createDate) <= '2013-12-31')

##################   assisted and organic stats ###################

## Assited regs with owningMonitorProfile_id not null
## Groups the data on a monthly basis below or next line. 
assisted <- regs[!is.na(regs$owningMonitorProfile_id), ]
#aggregate(assisted$id,by=list((substr(assisted$createDate,1,7))),length) 
assisted_month <- subset(assisted, as.Date(createDate) >= '2013-12-01' &
										 	as.Date(createDate) <= '2013-12-31')
nrow(assisted_month)



#############     Partner level stats ######################################################
## Redcross stats and regs
redcross_ovs <- regs[regs$owningPartner_id %in% c(9,10), ]
unique_ovs <- aggregate(redcross_ovs$owningMonitorProfile_id, 
													 by=list(redcross_ovs$id), FUN=length)
#ovsgma <- paste(as.character(unique_ovs$Group.1), collapse=", ")
ov_regs_redcross <- regs_month[as.character(regs_month$owningMonitorProfile_id)
															 %in% unique_ovs$Group.1, ] # Fixed
nrow(ov_regs_redcross)


## Tadamon stats and regs
tadamon_ovs <- regs[regs$owningPartner_id %in% c(6), ]
unique_ovs <- aggregate(tadamon_ovs$owningMonitorProfile_id, 
#												by=list(tadamon_ovs$id), FUN=length)
#ovsgma <- paste(as.character(unique_ovs$Group.1), collapse=", ")
#unique_ovs <- c(11,31,42,43,53,56,70,74,88,121,350534)
ov_regs_tadamon <- regs_month[as.character(regs_month$owningMonitorProfile_id)
															%in% as.character(unique_ovs), ]
nrow(ov_regs_tadamon)

## Kampala stats and regs
kampala_ovs <- regs[regs$owningPartner_id %in% c(12), ]
unique_ovs <- aggregate(kampala_ovs$owningMonitorProfile_id, 
												by=list(kampala_ovs$id), FUN=length)
#ovsgma <- paste(as.character(unique_ovs$Group.1), collapse=", ")
ov_regs_kampala <- regs_month[as.character(regs_month$owningMonitorProfile_id)
															%in% unique_ovs$Group.1, ] # Error issue showing 0 :()
nrow(ov_regs_kampala)


#########################        Mongo Loads #####################################
## Omit the NAs
## na.omit(add_sql$createDate)
## Fix the dates readability (Char - as.Date conversion)
#add_sql$createDate <- as.Date(as.character(add_sql$createDate),  format="%Y-%m-%d")
add_mongo <- read.csv('refunite.csv', header=T, sep=',')  # load Mongo dump, Df called add_mongo
head(add_mongo)
add_mongo$createdAt <- as.Date(add_mongo$createdAt, format="%Y-%m-%d")

acts <- subset(add_mongo, as.Date(createdAt) >= '2013-12-01' 
							 & as.Date(createdAt) < '2014-01-01')


# Say we want to pick unique logins -> sieve only the logins. 

acts_logs <- subset(add_mongo, as.Date(createdAt) >= '2013-09-01' 
							 & as.Date(createdAt) < '2013-12-01')
add_mongo_logins <- acts_logs[acts_logs$actionType %in% c(104), ]
unique_logins <- aggregate(add_mongo_logins$actionType, 
													 by=list(add_mongo_logins$actingUserProfileId), FUN=length)
#unique_logins
#aggregate(add_mongo_logins$actionType,by=list((substr(add_mongo_logins$createdAt,1,7))),length) 

nrow(unique_logins)
#Months JFMAMJJASON

# Loop and find all those logins >=2 

loop = 0
for (i in 1:length(unique_logins$x)){
	if (unique_logins$x[i] >= 2) {
		loop = loop + 1
	}
}

loop

###############################   Mongo activity stats ##################
#follow above for the unique others TODO: 
add_mongo_search <- acts[acts$actionType %in% c(200), ]
unique_search <- aggregate(add_mongo_search$actionType, by=list(add_mongo_search$actingUserProfileId), FUN=length)
#unique_search
nrow(unique_search)
nrow(add_mongo_search)

#Messages sent follow 
add_mongo_msgs <- acts[acts$actionType %in% c(300), ]
unique_msgs <- aggregate(add_mongo_msgs$actionType, by=list(add_mongo_msgs$actingUserProfileId), FUN=length)
#unique_msgs
nrow(unique_msgs)
nrow(add_mongo_msgs)

#Messages read
add_mongo_read <- acts[acts$actionType %in% c(301), ]
unique_read <- aggregate(add_mongo_read$actionType, by=list(add_mongo_read$actingUserProfileId), FUN=length)
#unique_msgs
nrow(unique_read)
nrow(add_mongo_read)