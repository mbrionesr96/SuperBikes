#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(ggplot2)
  library(tidyr)
})

pokemon <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-04-01/pokemon_df.csv')

pokemon_clean <- pokemon %>%
  filter(
    !if_any(
      c(hp, attack, defense, special_attack, special_defense, speed, generation_id, weight, base_experience),
      is.na
    )
  ) %>%
  mutate(total_stats = hp + attack + defense + special_attack + special_defense + speed)

# 1) dplyr insight: Dual-type vs single-type
cat("\n=== Insight 1: Dual-type vs single-type total stats ===\n")
type_complexity_summary <- pokemon_clean %>%
  mutate(type_complexity = if_else(is.na(type_2), "single_type", "dual_type")) %>%
  group_by(type_complexity) %>%
  summarise(
    n = n(),
    avg_total_stats = mean(total_stats),
    median_total_stats = median(total_stats),
    .groups = "drop"
  )
print(type_complexity_summary)

# 2) dplyr insight: generation-level strength
cat("\n=== Insight 2: Average total stats by generation ===\n")
generation_summary <- pokemon_clean %>%
  group_by(generation_id) %>%
  summarise(
    n = n(),
    avg_total_stats = mean(total_stats),
    avg_base_experience = mean(base_experience),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_total_stats))
print(generation_summary)

# 3) ggplot2 insight: weight vs combat metrics
pokemon_long <- pokemon_clean %>%
  select(pokemon, weight, attack, defense, speed, total_stats) %>%
  pivot_longer(
    cols = c(attack, defense, speed, total_stats),
    names_to = "metric",
    values_to = "value"
  )

plot_weight_metrics <- ggplot(pokemon_long, aes(x = weight, y = value)) +
  geom_point(alpha = 0.3, color = "#2c7fb8") +
  geom_smooth(method = "lm", se = FALSE, color = "#d95f0e", linewidth = 1) +
  facet_wrap(~ metric, scales = "free_y") +
  labs(
    title = "How Pokemon weight relates to combat metrics",
    x = "Weight (kg)",
    y = "Metric value"
  ) +
  theme_minimal(base_size = 12)

ggsave("insight_weight_vs_metrics.png", plot_weight_metrics, width = 10, height = 7, dpi = 150)
cat("\nSaved: insight_weight_vs_metrics.png\n")

# 4) ggplot2 insight: speed by type
speed_by_type <- pokemon_clean %>%
  group_by(type_1) %>%
  summarise(
    n = n(),
    avg_speed = mean(speed),
    .groups = "drop"
  ) %>%
  filter(n >= 20) %>%
  arrange(desc(avg_speed))

plot_speed_by_type <- ggplot(speed_by_type, aes(x = reorder(type_1, avg_speed), y = avg_speed, fill = avg_speed)) +
  geom_col() +
  coord_flip() +
  scale_fill_viridis_c(option = "C", end = 0.9) +
  labs(
    title = "Average speed by primary type (types with n >= 20)",
    x = "Primary type",
    y = "Average speed"
  ) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "none")

ggsave("insight_speed_by_type.png", plot_speed_by_type, width = 9, height = 6, dpi = 150)
cat("Saved: insight_speed_by_type.png\n")

cat("\nAnalysis complete.\n")
