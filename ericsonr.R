## Automate Monthly Ericson script. 
## __Author__ 'ngamita@refunite.org'

## ************** Statistics to summarise for Monthly *************

## 1. Accumulated total number of registrations:
## 2. Number of new registrations:
## 3. Number of active users** 

## git stepps: 
## git add *
## git commit -m "Commit ericson stats"
## git push origin master 



## *** Defaults *** 
directory <- "/home/ngamita/refunite/R/data"


## 1. Dump all Mysql stats (Format: )
## 2. Dump all Mongo stats (Format: )


## Move to /dir load rusql.csv

file <- paste('rusql', "csv", sep=".")
path_sql <- paste(directory, file, sep="/")
#print(path_sql)
# Fix warning --> set quote = ""
add_sql <- read.csv(path_sql, header=F, sep=',', quote = "",
										row.names = NULL, 
										na.strings = c("", "\\N")) # load sql dump, Df called add_sql

# Fix the date readability/ column names. 

names(add_sql) <- c('id', 'createDate', 'owningMonitorProfile_id', 'owningPartner_id')

## Omit the NAs
## na.omit(add_sql$createDate)

## Fix the dates readability (Char - as.Date conversion)
add_sql$createDate <- as.Date(add_sql$createDate,  format="%Y-%m-%d")


head(add_sql$createDate)

## Move to /dir load rumongo.csv

file <- paste('rumongo', "csv", sep=".")
path_mongo <- paste(directory, file, sep="/")
#print(path_mongo)
add_mongo <- read.csv(path_mongo, header=T, sep=',')  # load Mongo dump, Df called add_mongo
head(add_mongo)


