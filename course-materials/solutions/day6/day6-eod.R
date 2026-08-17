library(tidyverse)
moorea_coral <- read_csv(
  "course-materials/eod/data/moorea_coral.csv",
  na = c("", "NA", "ND") # This vector tells read_csv() which values to interpret as missing data
)

# Exercise 1

# 1. filter the data to the lter1 site in 2017, keeping only the taxa Acropora and Pocillopora
# 2. Rename Taxonomy_Substrate_or_Functional_Group to somethign shorter and more descriptive
# 3. make a boxplot showing the distribution of the percent cover, by habitat (fringing vs forereef) and species.
# 4. clean up the scale titles

lter1_2017 <- moorea_coral |>
  filter(
    Site == "LTER_1",
    Date == "2017-04",
    Taxonomy_Substrate_or_Functional_Group == "Acropora" |
      Taxonomy_Substrate_or_Functional_Group == "Pocillopora"
  ) |>
  rename(genus = Taxonomy_Substrate_or_Functional_Group)
ggplot(
  lter1_2017,
  aes(
    x = genus,
    y = Percent_Cover,
    fill = Habitat
  )
) +
  geom_boxplot() +
  scale_x_discrete("Genus") +
  scale_y_continuous("Percent cover")

# Exercise 2

# 1. Continue using the filtered and completed data from the previous exercise
# 2. divide the percent cover by 100 so it's expressed as a fraction
# 3. calculate the mean and standard deviation of percent coral cover by habitat, depth, and taxon.
# 4. Sort the output in order of depth and taxon

lter1_2017 |>
  summarize(
    coral_cover_mean = mean(Percent_Cover),
    coral_cover_sd = sd(Percent_Cover),
    .by = c(Habitat, Depth, genus)
  ) |>
  arrange(Depth, genus)

# Exercise 3

# Use markdown in your Quarto document to explain your findings in both of the previous exercises.

# Bonus exercise

# Use the distinct() function to find all unique taxa, then sort by taxa
# What do you notice about Porites?
# Use the ifelse() and str_starts() to combine all the Porites values.e
# Repeat your analysis from Exercise 2, but this time expand your analysis to
# include Porites and Montipora. Hint: use the %in% operator.

distinct(moorea_coral, Taxonomy_Substrate_or_Functional_Group) |>
  arrange(Taxonomy_Substrate_or_Functional_Group) |>
  print(n = Inf)

include_coral <- c("Acropora", "Pocillopora", "Porites", "Montipora")
moorea_coral |>
  rename(genus = Taxonomy_Substrate_or_Functional_Group) |>
  mutate(genus = ifelse(str_starts(genus, "Porites"), "Porites", genus)) |>
  filter(
    Site == "LTER_1",
    Date == "2017-04",
    genus %in% include_coral
  ) |>
  summarize(
    coral_cover_mean = mean(Percent_Cover),
    coral_cover_sd = sd(Percent_Cover),
    .by = c(Habitat, Depth, genus)
  ) |>
  arrange(Depth, genus)

# What coral is most widespread in the Fringing reef, nearest the island? What about further offshore in the Forereef?
