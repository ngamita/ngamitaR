# It's almost readable

# -------------------- MASKS AND INDICES -----------------------------

# You can subset variable by using VAR[...].
# If ... contains a vector of integers, VAR[...] will interpret ... as indicesand 
# will return the values of VAR found at those indices. 
# If ... contains a vector of logicals of the same length as VAR, VAR[...] will
# be used to 'mask' VAR, returning the values of VAR where ... is TRUE. 

# Create some 'masks' to help us subset the data. 

# Survey methods: 

airboat_mask <- surveyMethod == "airboat"

# Habitats of interest: 
missingHabitat_mask <- habitat == ""
alligatorHole_mask <- habitat == "Alligator Hole"

# Lets look at those quads again and list the ones with animal names. 

quadNames <- levels(quad)			#extract the 'factor' levels

# We can use grep() to find the indices where quadnames matches a string
# and then print out the quadnames at these indices. 
# Note that these indices are for the short vector of unique Quadnames
# we just created, not the much longer quad variable. 

shark_in_quad_name_indices <- grep('shark', quadNames, ignore.case=TRUE)
quadNames[shark_in_quad_name_indices]

flamingoQuad_mask <- quad == "Flamingo"
gatorHookSwamoQuad_mask <- quad == 'Gator Hook Swamp'
sharkPointQuad_mask <- quad == 'Shark Point'

# What else can we do? We want to interrogate this dataset. 

# ---------------- SUBSETTING DATA WITH MASKS ------------------------------

# Let's look at habitat around gator holes. 
# In one line we will find all the quads that contain "Alligator Holes". 
# Working from the innermost part of the expression toward the outside: 
# 1) mask (aka filter) quads for those with habitat == "Aligator Holes"
# 2) convert the resulting quads from the class 'factor' to class 'character'
# 3) return only the unique values

quads_with_gator_holes <- unique(as.character(quad[alligatorHole_mask]))
quads_with_gator_holes


# ---------------- PIE CHART SHOWING CATEGORY ABUNDANCE ------------------------

# Now we create a table of gator habitat values: 
# 1) create another mask that checks against any of these quad names. 
# 2) subset the habitat variable with this mask
# 3) create a table of habitats found in those quads
# 4) display the habitats as a pie chart

gatorHoleQuad_mask <- quad %in% quads_with_gator_holes
gatorHabitat <- habitat[gatorHoleQuad_mask]
gatorHabitat_table <- table(gatorHabitat)

if (saveAsPng) { png(file="Everglades_gatorHabitat1.png", width=500, height=500)}

pie(gatorHabitat_table)
title("Habitat types in quadrangles with alligator holes")
par(old_par)

if (saveAsPng) {dev.off()}
