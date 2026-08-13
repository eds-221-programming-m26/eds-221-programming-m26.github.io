set.seed(221)

# Initialize your reef
reef <- matrix(0, nrow = 5, ncol = 5)
random_coral <- sample(1:25, size = 8)
for (rc in random_coral) {
  rc_row <- (rc - 1) %/% 5 + 1
  rc_col <- (rc - 1) %% 5 + 1
  reef[rc_row, rc_col] <- 1
}

# Create vectors for the years and the percent cover
years <- seq(2004, 2024, by = 2)
coral_cover_pct <- double(length(years))

# Calculate coral cover in the first year
# Hint: reef is all 1's and 0's, so the mean of the reef equals the percent cover.
coral_cover_pct[1] <- mean(reef)

for (t in 2:length(years)) {
  # Copy reef to a new variable, prev_reef
  prev_reef <- reef
  # Wipe the reef clean
  reef <- matrix(0, nrow = 5, ncol = 5)
  for (r in 1:5) {
    for (c in 1:5) {
      if (prev_reef[r, c] == 1) {
        print(paste("Coral found at", r, c))
        coral_outcome <- sum(sample(1:6, size = 2, replace = TRUE))
        if (coral_outcome <= 3) {
          # Mortality
          print("Coral died")
          reef[r, c] <- 0
        } else {
          # Survival
          print("Coral survived")
          reef[r, c] <- 1
        }
      }
    }
  }
  print(paste("year:", years[t]))
  print(reef)
  coral_cover_pct[t] <- mean(reef)
}
coral_cover_pct
