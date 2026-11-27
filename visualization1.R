library(tidyverse)
library(dplyr)
library(ggplot2)

jv_data <- read_csv("data/pitcher_verlander.csv")

jv_data_vis1 <- jv_data %>% select(count, pitch_name)

jv_data_vis1 <- jv_data %>% filter(pitch_name != "NA")

#adapting code from class

count_totals <- jv_data_vis1 %>% count(count, name = "total")

probs <- jv_data_vis1 %>% inner_join(count_totals, by = "count") %>% group_by(pitch_name, count, total) %>%
  summarize(p = n() / total[1], .groups = "drop_last") %>% arrange(count, desc(p)) %>%
  group_by(count) %>% mutate(rank = row_number()) %>%
  ungroup()

rank_pitch_counts <- probs %>% select(-p, -total)

#come back later to add in na value if necessary, i dont know

pitch_order <- rank_pitch_counts %>% group_by(pitch_name) %>% summarize(mr = mean(rank), .groups = "drop") %>%
  arrange(mr) %>% `[[`("pitch_name")



rank_pitch_counts$pitch_name <- factor(rank_pitch_counts$pitch_name, levels = pitch_order)

rank_pitch_counts$count <- factor(rank_pitch_counts$count, levels = c("0-0", "0-1", "0-2", "1-0", "2-0", "3-0","1-1", "1-2", "2-1", "2-2", "3-2"))


count_to_x <- function(r) {
  x <- c( "0-0" = 0,"0-1"= 1,"0-2" = 2,"1-0"= 3,"2-0" = 4,"3-0"= 5,"1-1" = 6,"1-2"= 7, "2-1"= 8,"2-2" = 9,"3-2" = 10)
  x[as.character(r)]
}

count_00 <- rank_pitch_counts %>% filter(count== "0-0")
count_01 <- rank_pitch_counts %>% filter(count =="0-1")
count_02 <- rank_pitch_counts %>% filter(count == "0-2")

count_10 <- rank_pitch_counts %>% filter(count == "1-0")
count_20 <- rank_pitch_counts %>% filter(count == "2-0")
count_30 <- rank_pitch_counts %>% filter(count == "3-0")

count_11 <- rank_pitch_counts %>% filter(count =="1-1")
count_12 <- rank_pitch_counts %>% filter(count =="1-2")
count_21 <- rank_pitch_counts %>% filter(count == "2-1")
count_22 <- rank_pitch_counts %>% filter(count == "2-2")
count_32 <- rank_pitch_counts %>% filter(count =="3-2")


line_data_00_01 <- count_00 %>% left_join(count_01, by ="pitch_name") %>% select(-count.x, -count.y)
line_data_01_02 <- count_01 %>% left_join(count_02, by ="pitch_name") %>% select(-count.x,-count.y)
line_data_02_10 <- count_02 %>% left_join(count_10, by ="pitch_name") %>% select(-count.x, -count.y)

line_data_10_20 <- count_10 %>% left_join(count_20, by ="pitch_name") %>% select(-count.x,-count.y)
line_data_20_30 <- count_20 %>% left_join(count_30, by ="pitch_name") %>% select(-count.x,-count.y)
line_data_30_11 <- count_30 %>% left_join(count_11, by = "pitch_name") %>% select(-count.x, -count.y)

line_data_11_12 <- count_11 %>% left_join(count_12, by ="pitch_name") %>% select(-count.x, -count.y)
line_data_12_21 <- count_12 %>% left_join(count_21, by ="pitch_name") %>% select(-count.x, -count.y)
line_data_21_22 <- count_21 %>% left_join(count_22, by ="pitch_name") %>% select(-count.x, -count.y)
line_data_22_32 <- count_22 %>% left_join(count_32, by ="pitch_name") %>% select(-count.x, -count.y)


line_data <- rbind(
  line_data_00_01 %>% mutate(x = count_to_x("0-0"), xend = count_to_x("0-1")),
  line_data_01_02 %>% mutate(x = count_to_x("0-1"), xend = count_to_x("0-2")),
  line_data_02_10 %>% mutate(x = count_to_x("0-2"), xend = count_to_x("1-0")),
  line_data_10_20 %>% mutate(x = count_to_x("1-0"), xend = count_to_x("2-0")),
  line_data_20_30 %>% mutate(x = count_to_x("2-0"), xend = count_to_x("3-0")),
  line_data_30_11 %>% mutate(x = count_to_x("3-0"), xend = count_to_x("1-1")),
  line_data_11_12 %>% mutate(x = count_to_x("1-1"), xend = count_to_x("1-2")),
  line_data_12_21 %>% mutate(x = count_to_x("1-2"), xend = count_to_x("2-1")),
  line_data_21_22 %>% mutate(x = count_to_x("2-1"), xend = count_to_x("2-2")),
  line_data_22_32 %>% mutate(x = count_to_x("2-2"), xend = count_to_x("3-2"))
) 




plot <- (ggplot(rank_pitch_counts) +
           geom_rect(aes(xmin=count_to_x(count)-0.35, xmax=count_to_x(count)+0.35, ymin=rank-0.45, ymax=rank+0.45, fill=pitch_name), show.legend = FALSE) +
           geom_text(aes(x=count_to_x(count), y=rank, label=pitch_name)) +
           geom_segment(data = line_data_00_01, aes(x=0.35, xend=0.65, y = rank.x, yend = rank.y, color= pitch_name), show.legend = FALSE) +
           geom_segment(data = line_data_01_02, aes(x = 1.35, xend =1.65, y = rank.x, yend = rank.y, color = pitch_name), show.legend = FALSE) +
           geom_segment(data = line_data_02_10, aes(x = 2.35, xend = 2.65, y = rank.x, yend = rank.y, color = pitch_name), show.legend = FALSE) +
           geom_segment(data = line_data_10_20, aes(x =3.35, xend = 3.65, y = rank.x, yend = rank.y, color = pitch_name), show.legend = FALSE) +
           geom_segment(data = line_data_20_30, aes(x = 4.35, xend =4.65, y = rank.x, yend = rank.y, color = pitch_name), show.legend = FALSE) +
           geom_segment(data = line_data_30_11, aes(x=5.35, xend = 5.65, y = rank.x, yend = rank.y, color = pitch_name), show.legend = FALSE) +
           geom_segment(data = line_data_11_12, aes(x =6.35, xend= 6.65, y = rank.x, yend = rank.y, color = pitch_name), show.legend = FALSE) +
           geom_segment(data = line_data_12_21, aes(x =7.35, xend = 7.65, y = rank.x, yend = rank.y, color = pitch_name), show.legend = FALSE) +
           geom_segment(data = line_data_21_22, aes(x =8.35, xend =8.65, y = rank.x, yend = rank.y, color = pitch_name), show.legend = FALSE) +
           geom_segment(data = line_data_22_32, aes(x=9.35, xend =9.65, y = rank.x, yend = rank.y, color = pitch_name), show.legend = FALSE) +
           ylim(0,7) +
           scale_y_reverse(breaks = 1:6) +
           scale_x_continuous(breaks=0:10, labels=c("0-0","0-1","0-2","1-0","2-0","3-0","1-1","1-2","2-1","2-2","3-2")) +
           labs(x="count", y="rank", title="pitch name rankings by count for JV "))


plot
#order by average speed?