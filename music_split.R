# Function to read through dataframe
# Spit out csv's per column level (Musician, name)

# To run the code
# 1. Make sure you have the raw data file (x) in the currentl directory
# 2. run the function above, followed by the code below (choose 1 or 2 depending on which)\
# data sheet of you want to user (1 = Gospel and 2= Secular)

# __Author__ "ngamita@gmail.com"
# install the Excel reading packages. 
install.packages("xlsx", type = "source")
library(xlsx)


dump_df <- function(x, t){  
  # read in the file
  df_x <<- read.xlsx(x, t, header = TRUE)
  # re-alocate the columns, in case we move with tab 2. 
  if(t != 1){
    df_x$GOSPEL. <- df_x$ARTISTES.NAME
  }
  # head(df)
  # clean up the df_x$GOSPEL. column (lots of giberrish characters)
  df_x$GOSPEL. <<- gsub( "\\.|/|\\-|\"|\\s" , "" , df_x$GOSPEL.)
  # get all the gospel names (column == 'GOSPEL.')
  # Note the as.factor, to attain the levels. 
  df_levels <- levels(as.factor(df_x$GOSPEL.))
  # print(df_levels)
  # Levels gets all the unique Artist names. 
  # Let's loop through them, while we dump the csv's 
  #print(as.vector(df_levels))
  for (i in 1:length(df_levels)){
    # print(i)
    # print(df_levels[i])
    # TODO: (not done!!!) Check for similar names e.g "chameleone" vs "chameleone ft. trikka"
    # gsub(" ","", " xx yy 11 22 33 " , fixed=TRUE)
    # print(df_x[df_x$GOSPEL. %in% df_levelds[i], ])
    filename <- paste(df_levels[i], ".csv", sep="") 
    # write.csv((df_x[df_x$GOSPEL. %in% df_levels[i], ]), file=filename)
    v_value <- df_x[df_x$GOSPEL. %in% df_levels[i], ]
    write.csv(v_value, file=filename)
  }
    
}


dump_df("Songs for safaricom-01.xlsx", 2)