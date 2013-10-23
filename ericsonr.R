## Automate Monthly Ericson script. 
## __Author__ 'ngamita@refunite.org'
## 

## git stepps: 
## git add *
## git commit -m "Commit ericson stats"
## git push origin master 



## *** Defaults *** 
directory_local <- "/home/ngamita/refunite/R/data"

## 1. Dump all Mysql stats (Format: )
## 2. Dump all Mongo stats (Format: )


## Move to /dir load rusql.csv

file <- paste('rusql', "csv", sep=".")
path_sql <- paste(directory, file, sep="/")
print(path_sql)
#add_sql <- read.csv(path_sql, header=T, sep=',') # load sql dump, Df called add_sql

## Move to /dir load rumongo.csv

file <- paste('rumongo', "csv", sep=".")
path_mongo <- paste(directory, file, sep="/")
print(path_mongo)
add_mongo <- read.csv(path_mongo, header=T, sep=',')  # load Mongo dump, Df called add_mongo



