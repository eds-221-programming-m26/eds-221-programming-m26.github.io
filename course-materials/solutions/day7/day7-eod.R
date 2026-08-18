library(tidyverse)

moorea_coral <- read_csv(
  "course-materials/eod/data/moorea_coral.csv",
  na = c("", "NA", "ND") # This vector tells read_csv() which values to interpret as missing data
)

moorea_fish <- read_csv(
  "course-materials/eod/data/moorea_fish.csv",
  na = c("", "NA", "ND")
)

# Exercise 1: Wrangle the coral data

# 1. Build a vector of the non-coral category labels in
#    Taxonomy_Substrate_or_Functional_Group (Sand, CTB, Macroalgae,
#    Non-coralline Crustose Algae, Unknown or Other), then filter moorea_coral
#    to exclude those rows and keep only Depth < 17
# 2. Use mutate() and str_sub() to pull the four-digit year out of Date into a new column called Year
# 3. Each quadrat (Quad40) can hold several coral genera, so summarize in two
#    steps: first sum Percent_Cover per quadrat, called quadrat_cover, then
#    take the mean of quadrat_cover by year, site, habitat, and depth, called
#    mean_coral_cover
# 4. Arrange the result by year, site, and depth. Store it as coral_summary

non_coral <- c(
  "Sand",
  "CTB",
  "Macroalgae",
  "Non-coralline Crustose Algae",
  "Unknown or Other"
)

coral_summary <- moorea_coral |>
  filter(!Taxonomy_Substrate_or_Functional_Group %in% non_coral, Depth < 17) |>
  mutate(Year = as.numeric(str_sub(Date, 1, 4))) |>
  summarize(
    quadrat_cover = sum(Percent_Cover, na.rm = TRUE),
    .by = c(Year, Site, Habitat, Depth, Quad40)
  ) |>
  summarize(
    mean_coral_cover = mean(quadrat_cover),
    .by = c(Year, Site, Habitat, Depth)
  ) |>
  arrange(Year, Site, Depth)

# Exercise 2: Wrangle the fish data

# 1. Filter moorea_fish to Coarse_Trophic == "Primary Consumer"
# 2. Summarize the total biomass by site, habitat, and year, called total_biomass
# 3. Arrange by year, site, and habitat. Store it as fish_summary

fish_summary <- moorea_fish |>
  filter(Coarse_Trophic == "Primary Consumer") |>
  summarize(
    total_biomass = sum(Biomass, na.rm = TRUE),
    .by = c(Site, Habitat, Year)
  ) |>
  arrange(Year, Site, Habitat)

# Exercise 3: Join the summaries

# 1. inner_join() coral_summary and fish_summary, matching on site, habitat, and year
# 2. Compare row counts - why do they differ?

reef_joined <- coral_summary |>
  inner_join(fish_summary, join_by(Site, Habitat, Year))

# reef_joined has fewer rows than either summary: coral was never surveyed in
# the backreef, so inner_join() drops every backreef fish row (and any other
# site/habitat/year combo missing from one side).

# Exercise 4: Reshape

# 1. select() Site, Habitat, Year, mean_coral_cover from reef_joined
# 2. pivot_wider() Habitat into columns
# 3. Add a column for the difference in coral cover between two habitats

reef_wide <- reef_joined |>
  select(Site, Habitat, Year, mean_coral_cover) |>
  pivot_wider(names_from = Habitat, values_from = mean_coral_cover) |>
  mutate(forereef_minus_fringing = Forereef - Fringing)

# Exercise 5: Visualize

ggplot(
  reef_joined,
  aes(x = mean_coral_cover, y = total_biomass, color = Site)
) +
  geom_point(alpha = 0.7) +
  scale_x_continuous("Mean coral cover (%)") +
  scale_y_continuous("Herbivorous fish biomass") +
  facet_wrap(~Site) +
  theme_bw()
