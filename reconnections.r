## Understand Messages and Reconnections. 
## Author "Richard Ngamita" ngamita@gmail.com
## 

## Set the working directory. 


## Fix warning --> set quote = ""
add_msgs <- read.csv('messages.csv', header=F, sep=',', as.is = T, 
										 fill = TRUE) # load sql dump

## Fix the date readability/ column names. 
names(add_msgs) <- c('id', 'thread_id', 'messageBody', 'sentDate',
										 'messageDirection_id', 'spam')

## Add  
add_thds <- read.csv('threads.csv', header=F, sep=',', as.is = T,
										 fill = TRUE) # load sql dump
names(add_thds) <- c('id', 'owningProfile_id', 'targetProfile_id')





## Limit dates for the last 6 months, Initial analysis. 
## Pick the constants for start and end dates
## Find a way to fix this called from user TODO: @ngamita
start_date <- '2013-05-01'
train_set <- subset(add_msgs, as.Date(sentDate) >= start_date)
## Sum all training set. 
##nrow(train_set)

## Get all threads with messageDirection_id with 1 or 2. 
## Avoid all the message threads with only 1 direction id
## threads with 1 ONLY or 2 ONLY. 
require(plyr)
directions <- ddply(train_set,.(train_set$thread_id,train_set$messageDirection_id),nrow)
names(directions) <- c('ids', 'dir', 'count')


## Check for the thread_id, if got more than 2 messages. i.e. thread id's more than 2.
## Use the plyr package with count()
## require(plyr), leave out as already added above. 
## dirs = 2 sent out, dirs = 1 received.
thread_freq <- count(directions, 'directions$ids') 
#names(thread_freq) <- c('thrd', 'freq')

## Now check for all those with more than 2 i.e. >= 2? into df threads_df!!
threads_df <- thread_freq[thread_freq$freq >= 2, ]
bf_messages <- nrow(threads_df)
## Total threads with atleast back and forth conversation. 
bf_messages


## How many messages are in these threads. 
## Aggregate according to sum. 
## Find the intersection, those that appear in both. 
aggregate_df <- aggregate(directions$count ~ directions$ids, data = directions, sum)
names(aggregate_df) <- c('ids', 'count')

## Match aggregate_df vs threads_df find similarities aggregate aggregate_df ONLY. 
#intersect_v <- intersect(aggregate_df$ids, threads_df$directions.ids)

sms_threads <- aggregate_df[aggregate_df$ids %in% threads_df$directions.ids, ]
## randomly clean out all those with more than 20 messages FYI- just an estimate.
clean_spam_df <- sms_threads[sms_threads$count <= 20, ]
## total SMS exchanged in system.
sum(sms_threads$count)




## TExt MiNing to find Phone numbers or Email. 
## Pull out all threads that have a compltete loop send and receive messages. 
## Check them all for occurrences of phone number and highlight them out. 

phone_threads <- train_set[train_set$thread_id %in% threads_df$directions.ids, ]

got_phone <- phone_threads[grep("(\\(?(\\d{3})\\)?\\s?-?\\s?(\\d{3})\\s?-?\\s?(\\d{3}))", phone_threads$messageBody),] 
got_email <- phone_threads[grep("([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})", phone_threads$messageBody),] 


## cleaned too 
clean_phone_df <- clean_spam_df[clean_spam_df$ids %in% got_phone$thread_id, ]
clean_email_df <- clean_spam_df[clean_spam_df$ids %in% got_email$thread_id, ]
nrow(clean_phone_df)