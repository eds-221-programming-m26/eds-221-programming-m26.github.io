# Looping _iterates_ through a sequence
corals <- c("Porites", "Pocillopora", "Acropora")
for (c in corals) {
    # print() explicitly sends output to the console inside loops
    print(c)
}

# It's also common to iterate through the _indices_ of the sequence
for (i in 1:length(corals)) {
    print(corals[i])
}

# Let's do the fibonacci loop
fibonacci <- integer(20)
fibonacci[1:2] <- 1L
for (i in 3:length(fibonacci)) {
    fibonacci[i] <- fibonacci[i - 1] + fibonacci[i - 2]
}
fibonacci

# Nested loops iterate over multiple sequences
small_reef <- matrix(1:9, nrow = 3, ncol = 3)
small_reef
for (r in 1:3) {
  for (c in 1:3) {
    print(paste(r, c, sep = ", "))
    print(small_reef[r, c])
  }
}

# Change the next two lines only such that the output is 1-9
# rather than 1,4,7,2,5,8,3,6,9
for (c in 1:3) {
  print("what's going on here?")
  for (r in 1:3) {
    print(paste(r, c, sep = ", "))
    print(small_reef[r, c])
  }
}

# Loop through randomly sampled initial starting locations
reef <- matrix(0, nrow = 5, ncol = 5)
set.seed(123)
random_coral <- sample(1:25, size = 8)
for (rc in random_coral) {
  rc_row <- (rc - 1) %/% 5 + 1
  rc_col <- (rc - 1) %% 5 + 1
  reef[rc_row, rc_col] <- 1
}
reef

# Combining loops and conditional statements
for (r in 1:5) {
  for (c in 1:5) {
    if (reef[r, c] == 1) {
      print(paste(r, c, sep = ","))
    }
  }
}

