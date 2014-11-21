# This flag determines whether images are saved as png files

saveAsPng = TRUE

# You can use the '=' sign for assignment but please get used to the
# R convention '<-'. Some tools depend on consistent use '<-' to parse
# the R code you write

saveAsPng <- TRUE

# A quick google on 'Everglades data csv' and you can find the dataset
# of High Accuracy Elevation Data (HEAD) for the Everglades: 

# http://sofia.usgs.gov/exchange/desmond/desmondelev.html

# We will pick the bigger of the CSV files and read it in as a 'dataframe'. 

# ---------------------- READING IN DATA FROM A URL -------------------------

cat("Reading in large Everglades file...")
con <- url('http://sofia.usgs.gov/exchanget/gdesmond/haed/HAED_v01.csv')
everglades_df <- read.csv(con)

# ------------------ QUICK LOOK AT A DATAFRAME -----------------------

dim(everglades_df)

# Nice! 57,395 records with 8 variables each. 
# Now let's get an overview of the structure of this dataframe. 

str(everglades_df)

# We have some 'factoes' (aka 'categorical variables'):
# SUR_METHOD, SUR_FILE, SUR_INFO, VEG_FS, Quad_Name
# 

# And we have some 'numerics': 
# ELEV_M, X_UTM, Y_UTM

# Let's pull out and rename the variables that are likely to be interesting. 

#------------------DEFINING VARIABLES ----------------------------------------

surveyMethod <- everglades_df$SUR_METHOD
elevation <- everglades_df$ELEV_M
habitat <- everglades_df$VEG_FS # VEG_FS ?= "VEGetation Field Survey"
x <- everglades_df$X_UTM
y <- everglades_df$Y_UTM
quad <- everglades_df$Quad_Name

# Now let's check oit each of the factors

# ------------------------QUICK SUMMARY OF VARIABLES -----------------------

# factors

summary(surveyMethod)
summary(habitat)
summary(quad)
summary(elevation)

# OK, but we can learn so much more if we inspect things visually. 


# ------------------------- FIRST DATA VISUALIZATION: HISTOGRAM & BOXPLOT ------------

# First we'll save the default graphical parameters so we can get back to them
old_par <- par()

# We probably want to work interactively at first but eventually we will want
# to write out the image files. Having this behavior controlled by a flag allows
# us to work in both worlds as we tweak graphical parameters tp get things 
# "just right". Here we send graphics output to a .png if the flag is set. 

if (saveAsPng) {png(file="Everglades_elevation.png", width=500, height=500)}

# We'll plot a histogram of elevation values. 
# Then we will add a boxplot that crudely summarizes the histogram. 
# We start by creating a layout for the two plots with 70% of vertical space
# going to the upper plot and 30% to the lower. 


layout(matrix(seq(2)), heights=c(0.7,0.3))

# Note that the exact settings of various graphical parameters is determined
# by a lof of trial and error. Part of why it's nice to have things scripted. 

# Here are the rest of plotting commands. 
par(mar=c(0,4.1,4.1,2.1))		# reduce size of lower margin
hist(elevation, breaks=100, axes=FALSE, # plot a histogram with 100 bins
	main= "Everglades Elevations",  # use this title
	xlab="", ylab="" ) 		# no axis labels

par(mar=c(5.1, 4.1, 0, 2.1), mgp=c(3,0.5,0.0)) # adjust margins and axis location
boxplot(elevation, horizontal=TRUE, axes=FALSE) # add a boxplot underneath 
axis(1)						# add the x-axis
mtext("elevation (m)", side=1, side=1, line=2.5, font=2) # add the x-axis label
par(old_par)					# restore the original parameters

if (saveAsPng) {dev.off()}			# end plotting, write file

# This boxplot is basically a 1-dimensional representation of histogram

# -----------------BOXPLOTS BY CATEGORY ---------------------------------

# Now that we know what boxplots are, let's break up the data by factor. 
# Several functions understand the notation "data ~ factor" and do something smart. 

if (saveAsPng) {png(file="Everglades_elevationByHabitat.png", width=500, height=500)}


par(mar=c(3.1, 12.1, 4.1, 2.1), las=1)  	# big left margin, horizontal labels
boxplot(elevation ~ habitat, horizontal=TRUE)	# add a multi-category boxplot
title("Distribution of Elevation by Habitat Type")
par(old_par)

if (saveAsPng) {dev.off()}			# end plotting, write file


# This boxplot is basically a 1-dimensional representation of histogram

# -----------------BOXPLOTS BY CATEGORY ---------------------------------

# Now that we know what boxplots are, let's break up the data by factor. 
# Several functions understand the notation "data ~ factor" and do something smart. 

if (saveAsPng) {png(file="Everglades_elevationByHabitat.png", width=500, height=500)}


par(mar=c(3.1, 12.1, 4.1, 2.1), las=1)		# big left margin, horizontal labels
boxplot(elevation ~ habitat, horizontal=TRUE)	# add a multi-category boxplot
title("Distribution of Elevation by Habitat Type")
par(old_par)

if (saveAsPng) {dev.off()}			# end plotting, write file
