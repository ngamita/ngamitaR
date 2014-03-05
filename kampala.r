

accounts <- read.csv('kampala.csv', header=FALSE, sep=',')
a <- as.vector(t(accounts))

kampala <- resultDF[ resultDF$actingUserProfileId %in% a, ]
table(kampala$actionType)

# Say we want to pick unique logins -> sieve only the logins. 
kampala_logins <- kampala[kampala$actionType %in% c(104), ]
unique_logins <- aggregate(kampala_logins$actionType, by=list(kampala_logins$actingUserProfileId), FUN=length)
#length(unique_logins$x)
unique_logins
nrow(unique_logins)


#follow above for the unique others TODO: 
kampala_search <- kampala[kampala$actionType %in% c(200), ]
unique_search <- aggregate(kampala_search$actionType, by=list(kampala_search$actingUserProfileId), FUN=length)
unique_search
nrow(unique_search)

#Messages sent follow 
kampala_msgs <- kampala[kampala$actionType %in% c(300), ]
unique_msgs <- aggregate(kampala_msgs$actionType, by=list(kampala_msgs$actingUserProfileId), FUN=length)
unique_msgs
nrow(unique_msgs)