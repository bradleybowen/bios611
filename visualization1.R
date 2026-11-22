library(tidyverse)
library(dplyr)
library(ggplot2)

jv_data <- read_csv("data/pitcher_verlander.csv")

jv_data_vis1 <- jv_data %>% select(count, pitch_name)

jv_data_vis1 <- jv_data

#adapting code from class
probs <- jv_data_vis1 %>% inner_join(count_totals, by = "count") %>% group_by(pitch_name, count, total) %>%
  summarize(p = n() / total[1], .groups = "drop_last") %>% arrange(count, desc(p)) %>%
  group_by(count) %>% mutate(rank = row_number()) %>%
  ungroup()

rank_pitch_counts <- probs %>% select(-p, -total)

#come back later to add in na value if necessary, i dont know

pitch_order <- rank_pitch_counts %>% group_by(pitch_name) %>% summarize(mr = mean(rank), .groups = "drop") %>%
  arrange(mr) %>% `[[`("pitch_name")



rank_pitch_counts$pitch_name <- factor(rank_pitch_counts$pitch_name, levels = pitch_order)


#order by average speed?