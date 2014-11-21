



#quick over plot of how the data is behaving. 
#table(resultDF$actionType)
#barplot(table(resultDF$actionType))



accounts <- read.csv('kakuma.csv', header=FALSE, sep=',')
a <- as.vector(t(accounts))

kakuma <- resultDF[ resultDF$actingUserProfileId %in% a, ]
table(kakuma$actionType)

# Say we want to pick unique logins -> sieve only the logins. 
kakuma_logins <- kakuma[kakuma$actionType %in% c(104), ]
unique_logins <- aggregate(kakuma_logins$actionType, by=list(kakuma_logins$actingUserProfileId), FUN=length)
unique_logins
nrow(unique_logins)

#follow above for the unique others TODO: 
kakuma_search <- kakuma[kakuma$actionType %in% c(200), ]
unique_search <- aggregate(kakuma_search$actionType, by=list(kakuma_search$actingUserProfileId), FUN=length)
unique_search
nrow(unique_search)

#Messages sent follow 
kakuma_msgs <- kakuma[kakuma$actionType %in% c(300), ]
unique_msgs <- aggregate(kakuma_msgs$actionType, by=list(kakuma_msgs$actingUserProfileId), FUN=length)
unique_msgs
nrow(unique_msgs)