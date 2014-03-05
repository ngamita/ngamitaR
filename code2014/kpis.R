## Automate Status script. 
## This is the main code for NEW KPIs format Feb. 2014
## for the KPIs document at http://goo.gl/ZhBjwz
## Kind of manual but work in progress 
## __Author__ 'ngamita@refunite.org'

# Fix warning --> set quote = ""
# Load the data into Rstudio memory. 
# CSVs always come in handy ofcourse. Total Platform Registrations - Accumulated 

add_sql <- read.csv('rusql.csv', header=F, sep=',', quote = "", as.is = T, 
										row.names = NULL, 
										na.strings = c("", "\\N")) # load sql dump, Df called add_sql

# Fix the date readability/ column names. 
# give the columsn some nice names :). 

names(add_sql) <- c( 'id', 'owningMonitorProfile_id', 'owningPartner_id', 
										 'primaryEmail','dialCode',  'cellphone','createDate', 'userProfileState_id')

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

# Total Platform Registrations - eNew
# Represent on monthly basis stats. 
state_sql$month <- as.yearmon(state_sql$createDate, "%Y-%m") ## add new column (%Y-%m)
monthly_regs <- aggregate(id ~ month, data=state_sql, length) ## monthly registrations.

# TODO: "ngamita@refunite.org" Implement, cumulative from monthly_regs DF. 
# Create another column, totals or cumulates the month activities.

# Number of Reachable User Profiles - Accumulated
# reachable, has email or has (dialcode+cellphone)
monthly_reach <- subset(state_sql, (!is.na(state_sql$primaryEmail) | (!is.na(state_sql$dialCode) & (!is.na(state_sql$cellphone)))))
monthly_reach_cnt <- aggregate(id ~ month, data=monthly_reach, length) ## monthly registrations.

################################ Add Mongo db stats ##################################
## Mongo data load.
add_mongo <- read.csv('refunite.csv', header=T, sep=',')  # load Mongo dump, Df called add_mongo
head(add_mongo)
add_mongo$createdAt <- as.Date(add_mongo$createdAt, format="%Y-%m-%d")

# Set Monthly freq count. 
add_mongo$month <- as.yearmon(add_mongo$createdAt, "%Y-%m") ## add new column (%Y-%m)


# Total Number of Searches - New
#Unique Number of Users Performing one or more Searches - New

# Say we want to pick all searches  -> sieve only the searches 
# Codes explained here: http://goo.gl/mfh5Yw

total_searches <- add_mongo[add_mongo$actionType %in% c(200), ]
unique_searches <- aggregate(total_searches$actionType, 
													 by=list(total_searches$actingUserProfileId), FUN=length)

nrow(total_searches)
nrow(unique_searches)
monthly_searches <- aggregate(actionType ~ month, data=total_searches, length) ## monthly registrations.
monthly_searches_u <- aggregate(actionType ~ month + actingUserProfileId, data=total_searches, length) ## monthly registrations.

## Set the counts per month now. 
monthly_searches_unique <- aggregate(monthly_searches_u$actingUserProfileId ~ monthly_searches_u$month, data=monthly_searches_u, length)
monthly_searches_unique


#Total Number of Sent Messages - New
#Unique Number of Users Sending at least one Message - New

total_msg_sent <- add_mongo[add_mongo$actionType %in% c(300), ]


#nrow(total_searches)
#nrow(unique_searches)
monthly_msg_sent <- aggregate(actionType ~ month, data=total_msg_sent, length) ## monthly registrations.
monthly_msg_sent_u <- aggregate(actionType ~ month + actingUserProfileId, data=total_msg_sent, length) ## monthly registrations.

## Set the counts per month now. 
monthly_msg_sent_unique <- aggregate(monthly_msg_sent_u$actingUserProfileId ~ monthly_msg_sent_u$month, data=monthly_msg_sent_u, length)
monthly_msg_sent_unique

##################   User Activation Stats.  ###################


# Total Number of Profiles with ONLY a Phone Number - Accumulated
# check out cool use of within() function --> adds within DF. 
monthly_got_phone <- subset(state_sql, (!is.na(state_sql$dialCode) & (!is.na(state_sql$cellphone))))
monthly_got_phone_u <- aggregate(id ~ month, data=monthly_got_phone, length)
monthly_got_phone_u <- within(monthly_got_phone_u, acc_sum <- cumsum(id))


# Total Number of Profiles with a Phone Number AND an Email Address - Accumulated
monthly_got_phone_email <- subset(state_sql, (!is.na(state_sql$primaryEmail)) & (!is.na(state_sql$dialCode) & (!is.na(state_sql$cellphone))))
monthly_got_phone_email_u <- aggregate(id ~ month, data=monthly_got_phone_email, length)
monthly_got_phone_email_u <- within(monthly_got_phone_email_u, acc_sum <- cumsum(id))

# Total Number of Profiles with ONLY an Email Address - Accumulated
monthly_got_email <- subset(state_sql, (!is.na(state_sql$primaryEmail)) & (is.na(state_sql$dialCode) & (is.na(state_sql$cellphone))))
monthly_got_email_u <- aggregate(id ~ month, data=monthly_got_email, length)
monthly_got_email_u <- within(monthly_got_email_u, acc_sum <- cumsum(id))


##################   assisted and organic stats ###################

## Redcross stats and regs
redcross_ovs <- state_sql[state_sql$owningPartner_id %in% c(9,10), ]
unique_ovs <- aggregate(redcross_ovs$owningMonitorProfile_id, 
												by=list(redcross_ovs$id), FUN=length)
#ovsgma <- paste(as.character(unique_ovs$Group.1), collapse=", ")
ov_regs_redcross <- state_sql[as.character(state_sql$owningMonitorProfile_id)
															 %in% unique_ovs$Group.1, ] # Fixed
monthly_ov_regs_redcross <- aggregate(id ~ month, data=ov_regs_redcross, length) ## monthly registrations.
monthly_ov_regs_redcross <- within(monthly_ov_regs_redcross, acc_sum <- cumsum(id))


## Uganda OV stats and regs
uganda_ovs <- state_sql[state_sql$owningPartner_id %in% c(12), ]
unique_ovs <- aggregate(uganda_ovs$owningMonitorProfile_id, 
												by=list(uganda_ovs$id), FUN=length)
#ovsgma <- paste(as.character(unique_ovs$Group.1), collapse=", ")
ov_regs_uganda <- state_sql[as.character(state_sql$owningMonitorProfile_id)
															%in% unique_ovs$Group.1, ] # Fixed
monthly_ov_regs_uganda <- aggregate(id ~ month, data=ov_regs_uganda, length) ## monthly registrations.
monthly_ov_regs_uganda <- within(monthly_ov_regs_uganda, acc_sum <- cumsum(id))

## Other Registrations - Accumulated
## remove redcross and uganda partner_ids (9,10,12) ovs. Also take out NAs. 
other_ovs <- state_sql[!(state_sql$owningPartner_id %in% c(9, 10, 12)) & (!is.na(state_sql$owningPartner_id)), ]
unique_ovs <- aggregate(other_ovs$owningMonitorProfile_id, 
												by=list(other_ovs$id), FUN=length)
#ovsgma <- paste(as.character(unique_ovs$Group.1), collapse=", ")
ov_regs_other <- state_sql[as.character(state_sql$owningMonitorProfile_id)
														%in% unique_ovs$Group.1, ] # Fixed
monthly_ov_regs_other <- aggregate(id ~ month, data=ov_regs_other, length) ## monthly registrations.
monthly_ov_regs_other <- within(monthly_ov_regs_other, acc_sum <- cumsum(id))

## Assited regs with owningMonitorProfile_id not null
## Groups the data on a monthly basis below or next line. 
assisted <- state_sql[!is.na(state_sql$owningMonitorProfile_id), ]
monthly_assisted <- aggregate(id ~ month, data=assisted, length) ## monthly assisted registrations.
monthly_assisted <- within(monthly_assisted, acc_sum <- cumsum(id))

nrow(assisted_month)



#############     USSD stats and logs ######################################################

########################### Logins USSD stats
total_ussd_logins <- add_mongo[(add_mongo$actionType %in% c(104)) & (add_mongo$source %in% c('ussd-infobip', 'ussd-safaricom')), ]
unique_ussd_logins <- aggregate(total_ussd_logins$actionType, 
														 by=list(total_ussd_logins$actingUserProfileId), FUN=length)


monthly_ussd_logins <- aggregate(actionType ~ month, data=total_ussd_logins, length) ## monthly registrations.
monthly_ussd_logins_u <- aggregate(actionType ~ month + actingUserProfileId, data=total_ussd_logins, length) ## monthly registrations.

## Set the counts per month now. 
monthly_ussd_logins_unique <- aggregate(monthly_ussd_logins_u$actingUserProfileId ~ monthly_ussd_logins_u$month, data=monthly_ussd_logins_u, length)
monthly_ussd_logins_unique

# Total non unique ussd logins
monthly_total_ussd_logins <- aggregate(actionType ~ month, data=total_ussd_logins, length) ## monthly registrations.


# searches USSD
################## Searches USSD stats
total_ussd_searches <- add_mongo[(add_mongo$actionType %in% c(200)) & (add_mongo$source %in% c('ussd-infobip', 'ussd-safaricom')), ]

monthly_ussd_searches <- aggregate(actionType ~ month, data=total_ussd_searches, length) ## monthly registrations.
monthly_ussd_searches_u <- aggregate(actionType ~ month + actingUserProfileId, data=total_ussd_searches, length) ## monthly registrations.

## Set the counts per month now. 
monthly_ussd_searches_unique <- aggregate(monthly_ussd_searches_u$actingUserProfileId ~ monthly_ussd_searches_u$month, data=monthly_ussd_searches_u, length)
monthly_ussd_searches_unique

# Total non unique ussd logins
monthly_total_ussd_searches <- aggregate(actionType ~ month, data=total_ussd_searches, length) ## monthly registrations.


# ##########Sent Messages USSD stats
total_ussd_sent_msg <- add_mongo[(add_mongo$actionType %in% c(300)) & (add_mongo$source %in% c('ussd-infobip', 'ussd-safaricom')), ]

monthly_ussd_sent_msg <- aggregate(actionType ~ month, data=total_ussd_sent_msg, length) ## monthly registrations.
monthly_ussd_sent_msg_u <- aggregate(actionType ~ month + actingUserProfileId, data=total_ussd_sent_msg, length) ## monthly registrations.

## Set the counts per month now. 
monthly_ussd_sent_msg_unique <- aggregate(monthly_ussd_sent_msg_u$actingUserProfileId ~ monthly_ussd_sent_msg_u$month, data=monthly_ussd_sent_msg_u, length)
monthly_ussd_sent_msg_unique

# Total non unique ussd logins
monthly_total_ussd_sent_msg <- aggregate(actionType ~ month, data=total_ussd_sent_msg, length) ## monthly registrations.


############# Registrations USSD stats

total_ussd_regs <- add_mongo[(add_mongo$actionType %in% c(100)) & (add_mongo$source %in% c('ussd-infobip', 'ussd-safaricom')), ]

# Total non unique ussd registrations
monthly_total_regs <- aggregate(actionType ~ month, data=total_ussd_regs, length) ## monthly registrations.
monthly_total_regs <- within(monthly_total_regs, acc_sum <- cumsum(actionType))

############################################  Mobile web and Wap ################################################
total_wap_regs <- add_mongo[(add_mongo$actionType %in% c(100)) & (add_mongo$source %in% c('wap')), ]

# Total non unique wap registrations
monthly_total_wap_regs <- aggregate(actionType ~ month, data=total_wap_regs, length) ## monthly registrations.
monthly_total_wap_regs <- within(monthly_total_wap_regs, acc_sum <- cumsum(actionType))


################################################## Organic Registrations ##############################################
## Groups the data on a monthly basis below or next line. 
organic <- state_sql[is.na(state_sql$owningMonitorProfile_id), ] # owningProfile == NULL
monthly_organic <- aggregate(id ~ month, data=organic, length) ## monthly assisted registrations.
monthly_organic <- within(monthly_organic, acc_sum <- cumsum(id))

##########################         Call Center Registrations ####################################
## Kencall stats and regs
kencall_ovs <- state_sql[state_sql$owningPartner_id %in% c(11), ]
unique_ovs <- aggregate(kencall_ovs$owningMonitorProfile_id, 
												by=list(kencall_ovs$id), FUN=length)
#ovsgma <- paste(as.character(unique_ovs$Group.1), collapse=", ")
ov_regs_kencall <- state_sql[as.character(state_sql$owningMonitorProfile_id)
															%in% unique_ovs$Group.1, ] # Fixed
monthly_ov_regs_kencall <- aggregate(id ~ month, data=ov_regs_kencall, length) ## monthly registrations.
monthly_ov_regs_kencall <- within(monthly_ov_regs_kencall, acc_sum <- cumsum(id))

