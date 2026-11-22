library(tidyverse)
library(dplyr)
library(ggplot2)

d <- read_csv("data/sep2025_statcast.csv")
d <- d %>% mutate(count = paste0(balls, "-", strikes))

pitcher_verlander <- d %>% filter(pitcher == 434378) %>% arrange(game_date, game_pk, at_bat_number, pitch_number) 

pitcher_verlander <- pitcher_verlander %>% select(game_date, at_bat_number, pitch_number, balls, strikes, inning, outs_when_up, pitch_name, description)

write.csv(pitcher_verlander, "data/pitcher_verlander.csv", row.names = FALSE)
