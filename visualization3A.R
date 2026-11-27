library(GeomMLBStadiums)
jv_data <- read_csv("data/pitcher_verlander.csv")

jv_data_vis3 <- jv_data %>% select(hc_x, hc_y, stand, events) %>% filter(!is.na(hc_x), !is.na(hc_y)) %>% mutate(
  event_plot = ifelse(events %in% c("double_play", "field_out","fielders_choice", "force_out",  "sac_bunt"), "recorded_out", events))

data_for_field <- jv_data_vis3 %>% mutate(event_plot = factor(event_plot, levels = c("single", "double", "triple","home_run","recorded_out", "field_error")))


ggplot(data_for_field, aes(x = hc_x, y = hc_y, color = event_plot)) +
  geom_mlb_stadium(stadium_ids = "yankees", stadium_segments = "all") +
  geom_point()+
  facet_wrap(~stand)+
  scale_y_reverse()+
  coord_fixed()+
  theme_minimal()+
  theme(panel.grid = element_blank(), axis.text = element_blank(), axis.ticks = element_blank(), axis.title = element_blank())+
  labs(color = "Batted ball event", title = "Locations of contact events by batter handedness")