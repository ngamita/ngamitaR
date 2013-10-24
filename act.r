
# Convert the result DF to this DF
ru.data.r <- result

# Total Searches. 
ru.data.searches <- ru.data.df[ru.data.df$actionType %in% c(200), ]
nrow(ru.data.searches)

searches <- data.frame(ru.data.searches$createdAt, ru.data.searches$actingUserProfileId)


# Unique users from Logins. 
ru.data.usearches <- aggregate(ru.data.searches$actionType, 
															 by=list(ru.data.searches$actingUserProfileId), FUN=length)
nrow(ru.data.usearches)

shist <- ru.data.usearches[ru.data.usearches$x <= 100, ]
hist(shist$x, breaks=100, col="red")
# OV or Organic. 
#paste(as.character(ru.data.usearches$Group.1), collapse=", ")

#hist(cars$mpg, col='grey')
# df[df$age >= 50, ]
















# Total Logins. 
ru.data.logins <- ru.data.df[ru.data.df$actionType %in% c(104), ]
nrow(ru.data.logins)

# Unique users from Logins. 
ru.data.ulogins <- aggregate(ru.data.logins$actionType, 
														 by=list(ru.data.logins$actingUserProfileId), FUN=length)
nrow(ru.data.ulogins)

logins <- data.frame(ru.data.logins$createdAt, ru.data.logins$actingUserProfileId)


ru.data.messages <- ru.data.df[ru.data.df$actionType %in% c(300), ]
nrow(ru.data.messages)


#paste(as.character(ru.data.ulogins$Group.1), collapse=", ")



lhist <- ru.data.ulogins[ru.data.ulogins$x <= 100, ]
hist(ru.data.ulogins$x, breaks=200, col="red")







# Total Profile Viewed. 
ru.data.profile <- ru.data.df[ru.data.df$actionType %in% c(103), ]
nrow(ru.data.profile)

# Unique users from ProfileViewed. 
ru.data.uprofile <- aggregate(ru.data.profile$actionType, 
														 by=list(ru.data.profile$actingUserProfileId), FUN=length)
nrow(ru.data.uprofile)

#paste(as.character(ru.data.uprofile$Group.1), collapse=", ")


phist <- ru.data.uprofile[ru.data.uprofile$x <= 100, ]
hist(ru.data.umessages$x, breaks=50, col="red")
hist(phist$x, breaks=100, col="red")











ru.data.messages <- ru.data.df[ru.data.df$actionType %in% c(300), ]
nrow(ru.data.messages)









# Unique users Messaging. 
ru.data.umessages <- aggregate(ru.data.messages$actionType, 
															 by=list(ru.data.messages$actingUserProfileId), FUN=length)
nrow(ru.data.umessages)

messages <- data.frame(ru.data.messages$createdAt, ru.data.messages$actingUserProfileId)

#paste(as.character(ru.data.umessages$Group.1), collapse=", ")



mhist <- ru.data.umessages[ru.data.umessages$x <= 100, ]
hist(ru.data.umessages$x, breaks=50, col="red")
hist(mhist$x, breaks=100, col="red")




# The total registrations. 
registrations <- ru.data.d[ ru.data.d$userProfileState_id %in% c(1, 2), ]
nrow(registrations)
regists <- data.frame(registrations$createDate, registrations$id)

names(searches) <- c('createdAt', 'searches.id')
names(logins) <- c('createdAt', 'logins.id')
names(messages) <- c('createdAt', 'messages.id')
names(regists) <- c('createdAt', 'regists.id')


# Convert to 
searches.table <- aggregate(searches$searches.id, by=list(searches$createdAt), FUN=length)
logins.table <- aggregate(logins$searches.id, by=list(logins$createdAt), FUN=length)
messages.table <- aggregate(messages$messages.id, by=list(messages$createdAt), FUN=length)
regists.table <- aggregate(regists$regists.id, by=list(regists$createdAt), FUN=length)

# Activities from looping all above. 
activities <- merge(x = t1, y = regists.table, by = "createdAt", all = TRUE)


# Convert the dates to Week number format. 
library(plyr)
activities$week <- format(activities$createdAt, format="%Y-%U")

activities_weeks <- ddply(activities, .(week), summarize, searches.count = sum(searches.count), logins.count = sum(logins.count), messages.count = sum(messages.count, na.rm = T), regists.count = sum(regists.count))


# Melt the above 
activities_df <- melt(activities_weeks, id="week")

# Plot, stick to 25k max scale. 
p <- ggplot(data=activities_df, aes(x=week, y=value, colour=variable, group=variable)) + geom_line() + ylim(0, 15000)

# Organise x text vertical. 
p + theme(axis.text.x=element_text(angle = 90, vjust = 0.5))





ggplot(data=activities_df, aes(createdAt)) + geom_area(aes(y = value, fill = variable, group = variable), stat = "bin")
g <- ggplot(activities_df, aes(createdAt, y=value, fill = variable)) + geom_line(stat="identity")

qplot(value, data=activities_df, geom="density", fill=variable, alpha=I(.5), main="Distribution of Gas Milage", xlab="Miles Per Gallon", ylab="Density")




p <- ggplot(data=activities_df, aes(x=week, y=value, colour=variable, group=variable)) + geom_line() + ylim(0, 10000)
p + geom_area(aes(colour = variable, fill= variable), position = 'stack')




g <- ggplot(activities_df, aes(week, y=value, fill = variable, group = variable)) + geom_area(stat="identity")

g <- ggplot(activities_df, aes(week)) + geom_area(aes(..value.., fill = variable, group = variable)) + stat_bin()


library(plyr)
df$week <- format(df$date, format="%Y-%U")
ddply(df, .(week), summarize, income=sum(income))
week income
1 2011-52    413
2 2012-01    435
3 2012-02    379