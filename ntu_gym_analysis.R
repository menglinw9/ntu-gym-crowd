library(tidyverse)
library(lubridate)

# 1. 資料處理：區分平日/週末並計算每小時統計值
df_summary <- read.csv("C:/Users/mengl/Downloads/ntu_gym_flow.csv") %>%
  mutate(
    ts_site = as.POSIXct(ts_site, format="%Y-%m-%dT%H:%M:%S"),
    hour = hour(round_date(ts_site, "hour")),
    day_type = if_else(wday(ts_site) %in% c(1, 7), "週末", "平日") # 1為週日, 7為週六
  ) %>%
  group_by(day_type, hour) %>%
  summarise(
    avg = mean(people_now, na.rm = TRUE),
    sd = sd(people_now, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  replace_na(list(sd = 0))

# 2. 繪圖：分組顯示折線與標準差陰影
ggplot(df_summary, aes(x = hour, y = avg, color = day_type, fill = day_type)) +
  geom_ribbon(aes(ymin = avg - sd, ymax = avg + sd), alpha = 0.2, color = NA) +
  geom_line(size = 1) +
  geom_point() +
  scale_x_continuous(breaks = 0:23) +
  labs(
    title = "體育館人流分析：平日 vs 週末",
    subtitle = "陰影區域表示該時段的人數波動 (Mean ± SD)",
    x = "小時 (24H)", 
    y = "平均人數",
    color = "類別", fill = "類別"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")