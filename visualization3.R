#install.packages("sportyR")
library(sportyR)

jv_data <- read_csv("data/pitcher_verlander.csv")

jv_data_vis3 <- jv_data %>% select(hc_x, hc_y, stand, events) %>% filter(!is.na(hc_x), !is.na(hc_y)) %>% mutate(
  event_plot = ifelse(events %in% c("double_play", "field_out","fielders_choice", "force_out",  "sac_bunt"), "recorded_out", events))

data_for_field <- jv_data_vis3 %>% mutate(x_ft = 2.5 * (hc_x - 125.42), y_ft = 2.5 * (198.27 - hc_y), event_plot = factor(event_plot, levels = c("single", "double", "triple","home_run","recorded_out", "field_error")))



geom_baseball(league = "MLB") + geom_point(data = data_for_field, aes(x = x_ft, y = y_ft, color = event_plot)) +
  facet_wrap(~ stand)+ theme(legend.position = "bottom")


#citation: https://sportyr.sportsdataverse.org/
#citation: https://baseballwithr.wordpress.com/2021/04/