# Simple script to breakdown and aggrgate 
# SMS payments for songs. 

# Author: 'ngamita@gmail.com'

# Whats the file format xlsx or csv.
# If xlsx convert to csv, mind sheets.
# If .csv
# sudo python xlsx2csv.py --sheet=3 raw/REPORTS-JAN13-MAR13\ v2.xlsx mar.csv
# sudo python xlsx2csv.py --sheet = SHEETID raw-xlsx-file set-csv-file

setwd('/home/ngamita/Downloads/xlsx2csv-master/')
# Read files Jan/Feb/Mar (previously tabs.)
# Refactor the code with loop. 

#print(files)
# List all files in dir() assign to files. 
files = list.files(pattern = '*.csv')

# Loop through files(list) find exactly only .csv with fixed=T
# assign the pre-name to file read strsplit and assign usages.
for(i in 1:length(files)){
	#print(files[i])
	if(regexpr(".csv", files[i], fixed = T) > 0){
		#print(unlist(strsplit(files[i], '[.]'))) # Split and Unlist an action
		#unlist(strsplit(files[i], '[.]'))[1] = read.csv(files[i])
		assign(unlist(strsplit(files[i], '[.]'))[1], read.csv(files[i])) # Assign and read cool. 
	}
}

# regexpr("csv", "oct.csv") > 0 


#jan <- read.csv('jan.csv')
#feb <- read.csv('feb.csv')
#mar <- read.csv('mar.csv')
#oct <- read.csv('oct.csv')
#nov <- read.csv('nov.csv')
#december <- read.csv('dec.csv')



# Goal is aggregate the totals, keep the 
# is add up all the instances of the cmc_clip_promo_id into 1.
# just one aggregate revenue
#  Content_name and artist name

aggregate_revenue_jan <- aggregate(jan$revenue, by=list(jan$cms_clip_promo_id, 
																												jan$content_name, jan$artist, jan$payment.status), FUN=sum)
aggregate_revenue_feb <- aggregate(feb$revenue, by=list(feb$cms_clip_promo_id, 
																												feb$content_name, feb$artist, feb$payment.status), FUN=sum)
aggregate_revenue_mar <- aggregate(mar$revenue, by=list(mar$cms_clip_promo_id, 
																												mar$content_name, mar$artist, mar$payment.status), FUN=sum)

aggregate_revenue_oct <- aggregate(oct$revenue, by=list(oct$cms_clip_promo_id, 
																												oct$content_name, oct$artist, oct$payment.status), FUN=sum)
aggregate_revenue_nov <- aggregate(nov$revenue, by=list(nov$cms_clip_promo_id, 
																												nov$content_name, nov$artist, nov$payment.status), FUN=sum)
aggregate_revenue_dec <- aggregate(december$revenue, by=list(december$cms_clip_promo_id, 
																														 december$content_name, december$artist, december$payment.status), FUN=sum)

aggregate_revenue_apr <- aggregate(apr$revenue, by=list(apr$cms_clip_promo_id, 
																												apr$content_name, apr$artist, apr$payment.status), FUN=sum)

aggregate_revenue_may <- aggregate(may$revenue, by=list(may$cms_clip_promo_id, 
																												may$content_name, may$artist), FUN=sum)

aggregate_revenue_jun <- aggregate(jun$revenue, by=list(jun$cms_clip_promo_id, 
																												jun$content_name, jun$artist), FUN=sum)
aggregate_revenue_jul <- aggregate(jul$revenue, by=list(jul$cms_clip_promo_id, 
																												jul$content_name, jul$artist), FUN=sum)
aggregate_revenue_aug <- aggregate(aug$revenue, by=list(aug$cms_clip_promo_id, 
																												aug$content_name, aug$artist), FUN=sum)




# Set back, column names.
names(aggregate_revenue_jan) <- c('cms_clip', 'content_name', 'artist', 'pay_status', 'sum_revenue')
names(aggregate_revenue_feb) <- c('cms_clip', 'content_name', 'artist', 'pay_status', 'sum_revenue')
names(aggregate_revenue_mar) <- c('cms_clip', 'content_name', 'artist', 'pay_status', 'sum_revenue')

names(aggregate_revenue_oct) <- c('cms_clip', 'content_name', 'artist', 'pay_status', 'sum_revenue')
names(aggregate_revenue_nov) <- c('cms_clip', 'content_name', 'artist', 'pay_status', 'sum_revenue')
names(aggregate_revenue_dec) <- c('cms_clip', 'content_name', 'artist', 'pay_status', 'sum_revenue')

names(aggregate_revenue_apr) <- c('cms_clip', 'content_name', 'artist',  'sum_revenue')
names(aggregate_revenue_may) <- c('cms_clip', 'content_name', 'artist',  'sum_revenue')
names(aggregate_revenue_jun) <- c('cms_clip', 'content_name', 'artist',  'sum_revenue')
names(aggregate_revenue_jul) <- c('cms_clip', 'content_name', 'artist',  'sum_revenue')
names(aggregate_revenue_aug) <- c('cms_clip', 'content_name', 'artist',  'sum_revenue')


setwd('/home/ngamita/refunite/dump/')
write.table(aggregate_revenue_jan,file="jan_revenue.csv",sep=",",row.names=F)
write.table(aggregate_revenue_feb,file="feb_revenue.csv",sep=",",row.names=F)
write.table(aggregate_revenue_mar,file="mar_revenue.csv",sep=",",row.names=F)

write.table(aggregate_revenue_oct,file="oct_revenue.csv",sep=",",row.names=F)
write.table(aggregate_revenue_nov,file="nov_revenue.csv",sep=",",row.names=F)
write.table(aggregate_revenue_dec,file="dec_revenue.csv",sep=",",row.names=F)


write.table(aggregate_revenue_apr,file="apr_revenue.csv",sep=",",row.names=F)
write.table(aggregate_revenue_may,file="may_revenue.csv",sep=",",row.names=F)
write.table(aggregate_revenue_jun,file="jun_revenue.csv",sep=",",row.names=F)
write.table(aggregate_revenue_jul,file="jul_revenue.csv",sep=",",row.names=F)
write.table(aggregate_revenue_aug,file="aug_revenue.csv",sep=",",row.names=F)
