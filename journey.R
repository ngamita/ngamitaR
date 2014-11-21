# RU Journey trends. 

# Set directory, import data.
setwd('/home/ngamita/refunite/')
journey <- read.csv('search.csv')

# Preserved the original stats. 
journey_df <- journey

# Fix the date readability. 
journey_df$createdAt <- as.Date(journey_df$createdAt, format="%Y-%m-%d")

# Subset dates at some Point. 

journey_df_x <- subset(journey_df, as.Date(createdAt) >= '2013-04-01' & 
															 	as.Date(createdAt) <= '2013-09-30')
journey_df <- journey_df_x

# Group by activity search, logins, profiles, messages, incoming calls. 

logins <- journey_df[journey_df$actionType == 104, ]
profiles <- journey_df[journey_df$actionType == 103, ]
searches <- journey_df[journey_df$actionType == 200, ]
messages <- journey_df[journey_df$actionType == 300, ]
# TODO: Incoming calls.


# Group by the dates/count. # FUN=length gets the count grouped by date. 
# NB: the nrows are different and think of including NA's. 

logins_df <- aggregate(logins$actionType, by=list(logins$createdAt), FUN=length)
profiles_df <- aggregate(profiles$actionType, by=list(profiles$createdAt), FUN=length)
searches_df <- aggregate(searches$actionType, by=list(searches$createdAt), FUN=length)
messages_df <- aggregate(messages$actionType, by=list(messages$createdAt), FUN=length)


# rename the column names. 
names(logins_df) <- c('createdAt', 'logins')
names(searches_df) <- c('createdAt', 'searches')
names(profiles_df) <- c('createdAt', 'profiles')
names(messages_df) <- c('createdAt', 'messages')

# Convert to week. 
logins_df$createdAt <- format(logins_df$createdAt, format="%Y-%U")
searches_df$createdAt <- format(searches_df$createdAt, format="%Y-%U")
profiles_df$createdAt <- format(profiles_df$createdAt, format="%Y-%U")
messages_df$createdAt <- format(messages_df$createdAt, format="%Y-%U")

# Re-aggretate this time with a SUM per week counted. 
logins_df_s <- aggregate(logins_df$logins, by=list(logins_df$createdAt), FUN=sum)
profiles_df_s <- aggregate(profiles_df$profiles, by=list(profiles_df$createdAt), FUN=sum)
searches_df_s <- aggregate(searches_df$searches, by=list(searches_df$createdAt), FUN=sum)
messages_df_s <- aggregate(messages_df$messages, by=list(messages_df$createdAt), FUN=sum)

# TODO: ngamita FIX this rename the column names. 
names(logins_df_s) <- c('createdAt', 'logins')
names(searches_df_s) <- c('createdAt', 'searches')
names(profiles_df_s) <- c('createdAt', 'profiles')
names(messages_df_s) <- c('createdAt', 'messages')


# Merge all the data frames into 1.
journey_m <- merge(logins_df_s,profiles_df_s, all=TRUE)
journey_m <- merge(journey_m, searches_df_s, all=TRUE)
journey_m <- merge(journey_m, messages_df_s, all=TRUE)


# Import data from Kencall .csv file. Messsed up damn!! 
calls <- read.csv('calls.csv', header=F, sep=",") # Import
calls <- data.frame(t(calls)) #Transpose the data.
calls <-data.frame(calls, row.names=NULL) # Remove row.names issues
calls = calls[-1,] # Drop row 1
names(calls) <- c('createdAt', 'calls') # Rename the columns. 
calls$createdAt <- as.Date(calls$createdAt, "%Y-%m-%d") # Apparently convert to date from Char.
calls$createdAt <- format(calls$createdAt, format="%Y-%U") # Convert to Weekly
calls$calls <- as.numeric(as.character(calls$calls)) # Convert from factor to numeric.
calls <- aggregate(calls$calls, by=list(calls$createdAt), FUN=sum) # Aggregate per Weekly
names(calls) <- c('createdAt', 'calls')
journey_m <- merge(journey_m, calls, all=TRUE) #Merge with the rest of the frames. 



