# Recall how to roll 2d6
roll2d6 <- sum(sample(1:6, size = 2, replace = TRUE))

# What do we do with that roll?
# If it's less than or equal to 3, the coral dies
# If it's greater than or equal to 6, the coral grows
# Otherwise, it just survives
if (roll2d6 <= 3) {
  coral_fate <- "death"
} else if (roll2d6 >= 6) {
  coral_fate <- "growth :)"
} else {
  coral_fate <- "survival"
}

# You don't have to use if, else if, and else all together
# Let's look at a coral that grows on the edge

# From this morning
reef <- matrix(0, nrow = 5, ncol = 5)
coral_row <- 1
coral_col <- 1
reef[coral_row, coral_col] <- 1

growth_row_offset <- c(-1, -1, -1, 0, 1, 1, 1, 0)
growth_col_offset <- c(-1, 0, 1, 1, 1, 0, -1, -1)

growth_roll <- 1

growth_row <- coral_row + growth_row_offset[growth_roll]
growth_col <- coral_col + growth_col_offset[growth_roll]

# What we'd like to do
reef[growth_row, growth_col] <- 1

# Let's check if we're in bounds
in_bounds <- growth_row >= 1 &&
  growth_row <= 5 &&
  growth_col >= 1 &&
  growth_col <= 5

# Use an if statement to update the reef ONLY IF we're in bounds
if (in_bounds) {
  reef[growth_row, growth_col] <- 1
}

# Now let's grow properly
coral_row <- 3
coral_col <- 3
reef[coral_row, coral_col] <- 1
growth_row <- coral_row + growth_row_offset[growth_roll]
growth_col <- coral_col + growth_col_offset[growth_roll]

# Let's check if we're in bounds
in_bounds <- growth_row >= 1 &&
  growth_row <= 5 &&
  growth_col >= 1 &&
  growth_col <= 5

# Use an if statement to update the reef ONLY IF we're in bounds
if (in_bounds) {
  reef[growth_row, growth_col] <- 1
}
