library(tidyverse)
library(dplyr)
library(ggplot2)

jv_data <- read_csv("data/pitcher_verlander.csv")


jv_data_vis4 <- jv_data %>% select(game_date,game_pk, at_bat_number, release_speed, pitch_number, balls, strikes, inning, outs_when_up, pitch_name, description)

jv_data_vis4a <- jv_data_vis4 %>% filter(game_date =="2025-09-06")%>% group_by(game_pk) %>% mutate(pitch_order = row_number()) %>% ungroup()
  
ggplot(jv_data_vis4a, aes(x = pitch_order,y = release_speed, color = pitch_name, group = pitch_name, shape = as.factor(inning))) + geom_line() + geom_point()
