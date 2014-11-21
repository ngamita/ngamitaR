## R emails. 

sendmail_options(smtpServer="ASPMX.L.GOOGLE.COM")
# gmail requires the angle bracket syntax for from/to (i.e. <myemail@myaddress.com>)
from <- "<ngamita@gmail.com>"
to <- "<ring@refunite.org>"
subject <- "Welcome!"
msg <- "To The Rock"
sendmail(from, to, subject, msg)

library(ggplot2)

data <- data.frame(day=seq(as.Date("2013-01-01"), as.Date("2013-11-01"), 1))
data$value <- cumsum(sample(c(-1, 1), nrow(data), replace=T))
p <- ggplot(aes(x=day, y=value), data=data) +
	geom_line() + 
	stat_smooth(se=F) +
	ggtitle("Random Walk") +
	xlab("Time") +
	ylab("Y")

body <- list(
	mime_part(p, "GregsReport")
)
subject <- "An Important Report"
sendmail(from, to, subject, body)