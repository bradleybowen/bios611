
d <- read_csv("sep2025_statcast.csv")
d <- d %>% mutate(count = paste0(balls, "-", strikes))

pitcher_verlander <- d %>% filter(pitcher == 434378) %>% arrange(game_date, game_pk, at_bat_number, pitch_number) 

pitcher_verlander %>% select(game_date, at_bat_number, pitch_number, balls, strikes, inning, outs_when_up, pitch_name, description)

pitcher_verlander_09_06 <- pitcher_verlander %>% filter(game_date =="2025-09-06")%>% group_by(game_pk) %>% mutate(pitch_order = row_number()) %>% ungroup()
