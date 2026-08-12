set.seed(221)

# STEP 1: Initialize your reef

print(reef)

# Your reef should look like this:
#      [,1] [,2] [,3] [,4] [,5]
# [1,]    0    1    1    1    0
# [2,]    0    1    0    1    0
# [3,]    1    0    0    1    0
# [4,]    0    0    0    0    0
# [5,]    0    0    0    1    0

# STEP 2: Create vectors `years` and `coral_cover_pct`


# Your vectors should look like this
# > years
#  [1] 2004 2006 2008 2010 2012 2014 2016 2018 2020 2022 2024
# > coral_cover_pct
#  [1] 0 0 0 0 0 0 0 0 0 0 0


# STEP 3: Calculate coral cover in the first year
# Hint: reef is all 1's and 0's, so the mean of the reef equals the percent cover.

# Your coral cover percent should be:
# > coral_cover_pct
#  [1] 0.32 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00

# STEP 4: Loop over time. Call your iterator `t`. You've already calculated 
# percent cover for the first year, so start your sequence at 2. Fill in the 
# blank below.
for (_________) {
  # STEP 5: Update current and previous reef
  # Copy reef to a new variable, prev_reef
  prev_reef <- _________
  # Wipe the new reef clean
  reef <- _________

  # STEP 6: Loop over the rows and columns. Call your iterators r and c.
  for (_________) {
    for (_________) {

      # STEP 7: Check for coral
      # Check if this cell had a coral in it in the previous reef
      if (_________) {
        print(paste("Coral found at", r, c))
        
        # STEP 8: Determine coral's fate
        
        # Roll 2d6 for this coral
        coral_outcome <- _________
        # Fill in the conditions below for mortality and survival
        # Update the reef accordingly
        if (_________) {
          # Mortality
          print("Coral died")
          # Update the reef
        } else {
          # Survival
          print("Coral survived")
          # Update the reef
        }
      }
    }
  }
  print(paste("year:", years[t]))
  print(reef)

  # STEP 9: Update coral_cover_pct
  
}
coral_cover_pct
# When correct, your code will produce this result for the coral cover percent:
#  [1] 0.32 0.32 0.32 0.32 0.32 0.32 0.24 0.20 0.16 0.16 0.12
