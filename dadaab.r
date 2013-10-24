

#Break it into 1 week patterns subset .
resultDF <- subset(result, as.Date(createdAt) >= '2013-09-23' & as.Date(createdAt) <= '2013-09-29')

#quick over plot of how the data is behaving. 
table(resultDF$actionType)
barplot(table(resultDF$actionType))


setwd("/home/ngamita/refunite/dump")

# SET SESSION group_concat_max_len = 100000000;


# create and load all the csv ids for time period by read.csv() 
# - memory limit issues.
accounts <- read.csv('dadaab.csv', header=FALSE, sep=',')

#Convert from data.frame to vector list run class(X) to get the details.
a <- as.vector(t(accounts))
dadaab <- resultDF[ resultDF$actingUserProfileId %in% a, ]
table(dadaab$actionType)
#barplot(table(dadaab$actionType))

# Say we want to pick unique logins -> sieve only the logins. 
dadaab_logins <- dadaab[dadaab$actionType %in% c(104), ]
unique_logins <- aggregate(dadaab_logins$actionType, 
													 by=list(dadaab_logins$actingUserProfileId), FUN=length)
unique_logins
nrow(unique_logins)

#follow above for the unique others TODO: 
dadaab_search <- dadaab[dadaab$actionType %in% c(200), ]
unique_search <- aggregate(dadaab_search$actionType, 
													 by=list(dadaab_search$actingUserProfileId), FUN=length)
unique_search
nrow(unique_search)

dadaab_msgs <- dadaab[dadaab$actionType %in% c(300), ]
unique_msgs <- aggregate(dadaab_msgs$actionType, 
												 by=list(dadaab_msgs$actingUserProfileId), FUN=length)
unique_msgs
nrow(unique_msgs)

