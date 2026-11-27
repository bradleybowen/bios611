library(tidyverse)
library(dplyr)
library(ggplot2)

jv_data <- read_csv("data/pitcher_verlander.csv")

jv_data_vis2 <- jv_data %>% select(pitch_name, pfx_x, pfx_z)
jv_data_vis2 <- jv_data %>% filter(pfx_x != "NA", pfx_z != "NA")


plot2 <- ggplot(jv_data_vis2, aes(x = pfx_x, y = pfx_z, color = pitch_name)) + geom_point() + coord_equal() + geom_hline(yintercept = 0, color = "gray", linetype = "dashed") +
  geom_vline(xintercept = 0, color = "gray",  linetype = "dashed") 
