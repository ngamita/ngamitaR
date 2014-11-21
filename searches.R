## __Author__ Richard Ngamita 
## ------ Understanding Query Searches @refunite -------#########


## R text Mining ideas. 
## Example code worked from twitteR usage 
## with R . 


## Add SQL logged queries 
messages <- read.csv('messages.csv', header=F, sep=',', quote = "") 

## Rename the column headers. 
names(messages) <- c('id', 'thread_id', 'messageBody', 'sentDate', 'messageDirection_id', 'spam')

## wrap char strings to format paragraphs. 
strwrap(tweets[[320]]$text, width = 50)

## Convert tweets to data. 
df <- do.call("rbind", lapply(messages$messageBody, as.data.frame))

####### Text cleaning. #####

## Library tm import
library(tm)

## Build a corpus
myCorpus <- Corpus(VectorSource(df$text))

## to lower case. 
myCorpus <- tm_map(myCorpus, tolower)

## remove puntuation and dots. 
myCorpus <- tm_map(myCorpus, removePunctuation)
myCorpus <- tm_map(myCorpus, removeNumbers)

## remove URLs
removeURL <- function(x) gsub("http[[:alnum:]]*", "",x )
myCorpus <- tm_map(myCorpus, removeURL)

## remove 'r' and 'big' from stop words. 
myStopwords <- setdiff(stopwords("english"), c("r", "big"))

## remove stop words
# myCorpus <- tm_map(myCorpus, removeWords, stopwords('english'))
myCorpus <- tm_map(myCorpus, removeWords, myStopwords)


#################    Stemming #####################

## Keep a copy of myCorpus. 
myCorpuscopy <- myCorpus

## stem words
myCorpus <- tm_map(myCorpus, stemDocument)

## stem completion. 
myCorpus <- tm_map(myCorpus, stemCompletion, dictionary = myCorpuscopy)

## Replace "Miners" with "Mining"
myCorpus <- tm_map(myCorpus, gsub, pattern = 'miners', replacement = 'mining')
strwrap(myCorpus[320], width= 50)

## Frequent terms. 

myTdm <- TermDocumentMatrix(myCorpus, control=list(wordLengths = c(1, Inf)))

## inspect frequent terms
(freq.terms <- findFreqTerms(myTdm, lowfreq=20))

## Associations, which words associated with r. 
findAssocs(myTdm, "mine", 0.25)


## Network of graphs. 
library(graph)
library(Rgraphviz)
plot(myTdm, term = freq.terms, corThreshold=0.1, weighting=T)
