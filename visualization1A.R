library(tidyverse)
library(dplyr)
library(ggplot2)

jv_data <- read_csv("data/pitcher_verlander.csv")

jv_data_vis1 <- jv_data %>% select(outs_when_up, pitch_name)

jv_data_vis1 <- jv_data %>% filter(!is.na(pitch_name), !is.na(outs_when_up))

#adapting code from class

outs_totals <- jv_data_vis1 %>% count(outs_when_up, name = "total")

probs <- jv_data_vis1 %>% inner_join(outs_totals, by = "outs_when_up") %>% group_by(pitch_name, outs_when_up, total) %>%
  summarize(p = n() / total[1], .groups = "drop_last") %>% arrange(outs_when_up, desc(p)) %>%
  group_by(outs_when_up) %>% mutate(rank = row_number()) %>%
  ungroup()

rank_pitch_outs <- probs %>% select(-p, -total)

#come back later to add in na value if necessary, i dont know

pitch_order <- rank_pitch_outs %>% group_by(pitch_name) %>% summarize(mr = mean(rank), .groups = "drop") %>%
  arrange(mr) %>% `[[`("pitch_name")



rank_pitch_outs$pitch_name <- factor(rank_pitch_outs$pitch_name, levels = pitch_order)

rank_pitch_outs$outs_when_up <- factor(rank_pitch_outs$outs_when_up, levels = c("0", "1", "2"))

outs_to_x <- function(r) {
  x <- c("0" = 0, "1" = 1, "2" = 2)
  x[as.character(r)]
}

outs_0 <- rank_pitch_outs %>% filter(outs_when_up == "0")
outs_1 <- rank_pitch_outs %>% filter(outs_when_up =="1")
outs_2 <- rank_pitch_outs %>% filter(outs_when_up =="2")

line_data_0_1 <- outs_0 %>% left_join(outs_1, by = "pitch_name") %>% select(-outs_when_up.x, -outs_when_up.y)
line_data_1_2 <- outs_1 %>% left_join(outs_2, by = "pitch_name") %>% select(-outs_when_up.x, -outs_when_up.y)


plot <- (ggplot(rank_pitch_outs) +
           geom_rect(aes(xmin = outs_to_x(outs_when_up) - 0.35, xmax = outs_to_x(outs_when_up) + 0.35, ymin = rank - 0.45, ymax = rank + 0.45, fill = pitch_name), show.legend = FALSE) +
           geom_text(aes(x = outs_to_x(outs_when_up), y = rank, label = pitch_name)) +
           geom_segment(data = line_data_0_1, aes(x = 0.35, xend = 0.65, y = rank.x, yend = rank.y, color = pitch_name), show.legend = FALSE) +
           geom_segment(data = line_data_1_2, aes(x = 1.35, xend = 1.65, y = rank.x, yend = rank.y, color = pitch_name), show.legend = FALSE) +
           scale_y_reverse(limits = c(7, 0), breaks = 1:6) +
           scale_x_continuous(breaks = 0:2, labels = c("0", "1", "2")) +
           labs(x = "outs", y = "rank", title = "pitch name rankings by outs for JV "))

plot


#order by average speed?