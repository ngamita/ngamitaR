

accounts <- read.csv('tadamon.csv', header=FALSE, sep=',')
a <- as.vector(t(accounts))

tadamon <- resultDF[ resultDF$actingUserProfileId %in% a, ]
table(tadamon$actionType)

# Say we want to pick unique logins -> sieve only the logins. 
tadamon_logins <- tadamon[tadamon$actionType %in% c(104), ]
unique_logins <- aggregate(tadamon_logins$actionType, by=list(tadamon_logins$actingUserProfileId), FUN=length)
#length(unique_logins$x)
unique_logins
nrow(unique_logins)


#follow above for the unique others TODO: 
tadamon_search <- tadamon[tadamon$actionType %in% c(200), ]
unique_search <- aggregate(tadamon_search$actionType, by=list(tadamon_search$actingUserProfileId), FUN=length)
unique_search
nrow(unique_search)

#Messages sent follow 
tadamon_msgs <- tadamon[tadamon$actionType %in% c(300), ]
unique_msgs <- aggregate(tadamon_msgs$actionType, by=list(tadamon_msgs$actingUserProfileId), FUN=length)
unique_msgs
nrow(unique_msgs)