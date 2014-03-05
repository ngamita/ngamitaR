

accounts <- read.csv('all.csv', header=FALSE, sep=',')
a <- as.vector(t(accounts))

all <- resultDF[ resultDF$actingUserProfileId %in% a, ]
table(all$actionType)

# Say we want to pick unique logins -> sieve only the logins. 
all_logins <- all[all$actionType %in% c(104), ]
unique_logins <- aggregate(all_logins$actionType, by=list(all_logins$actingUserProfileId), FUN=length)
unique_logins
nrow(unique_logins)

#follow above for the unique others TODO: 
all_search <- all[all$actionType %in% c(200), ]
unique_search <- aggregate(all_search$actionType, by=list(all_search$actingUserProfileId), FUN=length)
unique_search
nrow(unique_search)

#Messages sent follow 
all_msgs <- all[all$actionType %in% c(300), ]
unique_msgs <- aggregate(all_msgs$actionType, by=list(all_msgs$actingUserProfileId), FUN=length)
unique_msgs
nrow(unique_msgs)