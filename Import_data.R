library(tidyverse)
library(dplyr)
library(ggplot2)


d <- read_csv("sep2025_statcast.csv")
d <- d %>% mutate(count = paste0(balls, "-", strikes))
head(d)
colnames(d)


#testing for fun

d %>% group_by(player_name) %>% tally() %>% arrange(n) %>% tail()
d %>% group_by(player_name) %>% tally() %>% arrange(player_name)
d %>% group_by(pitcher) %>% tally() %>% arrange(pitcher)


ggplot(d, aes(pitch_type)) + geom_bar()

ggplot(d, aes(bb_type)) + geom_bar()

ggplot(d, aes(effective_speed)) + geom_bar()

ggplot(d, aes(release_speed)) + geom_bar() + facet_wrap(~inning)

ggplot(d, aes(pitch_number)) + geom_bar() + facet_wrap(~inning)

pitcher_434378 <- d %>% filter(pitcher == 434378) %>% arrange(game_date, game_pk, at_bat_number, pitch_number) 

pitcher_434378 %>% select(game_date, pitch_order, at_bat_number, pitch_number, balls, strikes, inning, outs_when_up, pitch_name, description)

pitcher_434378 %>% select(game_date, pitch_order, at_bat_number, pitch_number, balls, strikes, inning, outs_when_up, pitch_name, description)

pitcher_434378_09_06 <- pitcher_434378 %>% filter(game_date =="2025-09-06")%>% group_by(game_pk) %>% mutate(pitch_order = row_number()) %>% ungroup()

#counts
ggplot(pitcher_434378, aes(x = pitch_type)) + geom_bar() + facet_wrap(~count) 
ggplot(pitcher_434378, aes(x = pitch_name)) + geom_bar() + facet_wrap(~count)
ggplot(pitcher_434378, aes(x = count)) + geom_bar()


#9-6 data
ggplot(pitcher_434378_09_06, aes(x = pitch_order,y = release_speed, color = pitch_name, group = pitch_name)) + geom_line() + geom_point()
ggplot(pitcher_434378_09_06, aes(x = pitch_order,y = effective_speed, color = pitch_name, group = pitch_name)) + geom_line() + geom_point()
ggplot(pitcher_434378_09_06, aes(x = pitch_order,y = release_extension, color = pitch_name, group = pitch_name)) + geom_line() + geom_point()
ggplot(pitcher_434378_09_06, aes(x = pitch_order,y = release_spin_rate, color = pitch_name, group = pitch_name, shape = as.factor(inning))) + geom_line() + geom_point()

ggplot(pitcher_434378_09_06, aes(x = pitch_type)) + geom_bar() + facet_wrap(~count) 
ggplot(pitcher_434378_09_06, aes(x = pitch_name)) + geom_bar() + facet_wrap(~count)
ggplot(pitcher_434378_09_06, aes(x = count)) + geom_bar()
ggplot(pitcher_434378_09_06, aes(x = count, fill = pitch_name)) + geom_bar()

pitcher_434378_09_27 <- pitcher_434378 %>% filter(game_date =="2025-09-27") %>% group_by(game_pk) %>% mutate(pitch_order = row_number()) %>% ungroup()

ggplot(pitcher_434378_09_27, aes(x = pitch_order,y = release_speed, color = pitch_type, group = pitch_name)) + geom_line() + geom_point()


ggplot(pitcher_434378_09_27, aes(x = pitch_type)) + geom_bar() + facet_wrap(~count) 
ggplot(pitcher_434378_09_27, aes(x = pitch_name)) + geom_bar() + facet_wrap(~count)
ggplot(pitcher_434378_09_27, aes(x = count)) + geom_bar()
ggplot(pitcher_434378_09_27, aes(x = count, fill = pitch_name)) + geom_bar()
       

#I'm seeing that this pitcher doesn't throw offspeed pitches initially

#total pitches by game
pitch_tot_434378 <- pitcher_434378 %>% count(game_date, pitch_name) %>% arrange(game_date)
ggplot(pitch_tot_434378, aes(x = game_date, y = n, fill = pitch_name)) + geom_col() 
pitch_tot_434378 <- pitcher_434378 %>% count(game_date) %>% arrange(game_date)
ggplot(pitch_tot_434378, aes(x = game_date, y = n)) + geom_line() + geom_point()



ggplot(pitch_tot_434378, aes(x = game_date, y = n)) + geom_line() + geom_point() + theme_minimal()

pitch_prop_434378 <- pitcher_434378 %>% group_by(game_date, pitch_name) %>% summarise(n = n(), .groups = "drop") %>% group_by(game_date) %>% mutate(pitch_proportion = n/sum(n))
ggplot(pitch_prop_434378,aes(x = game_date, y = pitch_proportion, color = pitch_name)) + geom_line() + geom_point() + scale_y_continuous(labels = scales::percent)


pitch_prop_434378 <- pitcher_434378 %>% group_by(game_date, count, pitch_name) %>% summarise(n = n(), .groups = "drop") %>% group_by(game_date, count) %>% mutate(pitch_proportion = n/sum(n))
ggplot(pitch_prop_434378,aes(x = game_date, y = pitch_proportion, color = pitch_name, group = pitch_name)) + geom_line() + geom_point() + facet_wrap(~ count) + scale_y_continuous(labels = scales::percent)

