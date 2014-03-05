# With default parameters, it's ugly as sin. 

# ------- PRETTIER PIE CHART: DONUT CHART ----------------------------------------------------


# After a little trial and error we can clean it up with the following: 
# 1) omit any habitats representing < 50 sample sites
# 2) sort from low to high

mainGatorHabitat <- sort(gatorHabitat_table[gatorHabitat_table > 50])


habitat_cols <- c("burlywood1","forestgreen","burlywood3","darkolivegreen3",
                  "cadetblue4","sienna3","cadetblue3","darkkhaki")

if (saveAsPng) {png(file="Everglades_gatorHabitat2.png", width=500, height=500)}

pie(mainGatorHabitat, col=habitat_cols, border="white", cex=1.2)

# Now let's trun into a 'donut plot' with a legend in the middle. 

par(new=TRUE)				# add new plot on top of the old one

# NOTE: This has to be the most counterintuitive setting ever!! 
# NOTE: Use "new = TRUE" to keep workigoong on the old plot. 
# NOTE: Use "new = FALSE" to start a new one. 

pie(c(1), labels=NA, border='white', radius=0.4)		# a blank white circle
text(0,0,labels="Gator\nHabitat", cex=2, font=2)		# text in the middle
par(old_par)

if (saveAsPng) {dev.off()}					# end plotting, write file

