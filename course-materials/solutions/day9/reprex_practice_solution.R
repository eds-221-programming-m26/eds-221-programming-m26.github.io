# Day 9 AM: Reprex practice -- solutions
# Run pieces of this script individually rather than sourcing it as a
# whole -- the reprex() calls open an interactive addin / copy to the
# clipboard, which isn't meaningful when run non-interactively.

library(tidyverse)
library(reprex)

mack_creek_vertebrates <- read_csv("data/AS00601.csv")

# -----------------------------------------------------------------------
# Example 1
# -----------------------------------------------------------------------
# The bug: .by = species refers to a lowercase `species` column, but
# the real column name in this data is uppercase SPECIES. R can't find a
# column called `species`.

# Fixed, run against the real data:
mack_creek_lengths <- mack_creek_vertebrates |>
  select(YEAR:SAMPLEDATE) |>
  filter(SECTION == "CC", !is.na(SPECIES)) |>
  summarize(
    mean_length_cm = mean(LENGTH1, na.rm = TRUE),
    sd_length_cm = sd(LENGTH1, na.rm = TRUE),
    .by = SPECIES
  )

# A minimal, self-contained reprex of the same bug:
reprex({
  library(tidyverse)

  mack_creek_vertebrates <- read_csv("data/AS00601.csv")

  mack_creek_vertebrates |>
    summarize(mean_length_cm = mean(LENGTH1), .by = species)
})

# -----------------------------------------------------------------------
# Example 2
# -----------------------------------------------------------------------
# The bug: we're adding the output of filter() to ggplot(), instead of
# piping it.

# Fixed, run against the real data:

mack_creek_vertebrates |>
  filter(SPECIES == "ONCL") |>
  ggplot(mapping = aes(x = LENGTH1, y = WEIGHT)) +
  geom_point() +
  scale_x_continuous("Cutthroat trout length (cm)") +
  scale_y_continuous("Weight (g)") +
  theme_minimal()

# A minimal, self-contained reprex of the same bug:
reprex({
  library(tidyverse)

  mack_creek_vertebrates <- read_csv("data/AS00601.csv")

  mack_creek_vertebrates +
    ggplot(mapping = aes(x = LENGTH1, y = WEIGHT)) +
    geom_point()
})
