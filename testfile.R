library(tidyverse)
library(Rtsne)

jv_data <- read_csv("data/pitcher_verlander.csv")

k_abs <- jv_data %>% filter(events %in% c("strikeout", "strikeout_double_play")) %>% distinct(game_date, game_pk, at_bat_number, batter)

k_seqs <- k_abs %>% inner_join(jv_data, by = c("game_date","game_pk","at_bat_number","batter")) %>% filter(!is.na(pitch_name)) %>%
  arrange(game_date, game_pk, at_bat_number, pitch_number) %>%
  group_by(game_date, game_pk, at_bat_number) %>% mutate(pitch_in_ab = row_number() ) %>% ungroup()


k_strings <- k_seqs %>% mutate(pitch_code = case_when(pitch_name == "4-Seam Fastball" ~ "F", pitch_name == "Slider"~ "S", pitch_name == "Sweeper"~ "W",
  pitch_name == "Curveball" ~ "C", pitch_name == "Changeup" ~ "H")) %>% group_by(game_date, game_pk, at_bat_number, batter) %>%
  summarize(sequence = paste(pitch_code, collapse = ""), n_pitches = n(), .groups = "drop")

#code adapted from class notes

distances <- adist(k_strings$sequence)

n <- nrow(distances)
perp <- max(2, min(30, floor((n - 1) / 3)))

set.seed(123)
tsne_out <- Rtsne(as.matrix(distances), is_distance = TRUE, perplexity = perp, check_duplicates = FALSE)

tsne_df <- tibble(x = tsne_out$Y[, 1], y = tsne_out$Y[, 2], sequence = k_strings$sequence, n_pitches = k_strings$n_pitches)

set.seed(123)
km <- kmeans(tsne_out$Y, centers = 3, nstart = 25)
tsne_df$cluster <- factor(km$cluster)
k_strings$cluster <- factor(km$cluster)

ggplot(tsne_df, aes(x = x, y = y, color = cluster)) +
  geom_point(size = 3, alpha = 0.85) +
  theme_classic() +
  labs(
    title = "t-SNE & k-Means Clusters of Verlander Strikeout Sequences",
    x = "t-SNE Dimension 1",
    y = "t-SNE Dimension 2",
    color = "Cluster"
  )

k_strings %>%
  group_by(cluster) %>% summarize(count = n(), avg_pitches = round(mean(n_pitches), 1), top_sequences = paste(head(sequence, 8), collapse = ", "),.groups = "drop" )



