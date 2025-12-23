library(rvest); library(stringr); library(readr); library(lubridate)

url <- "https://rent.pe.ntu.edu.tw/"

txt <- read_html(url) |>
  html_text2() |>
  str_replace_all("\u00A0", " ") |>
  str_squish()

now_vec <- str_match_all(txt, "(\\d{1,4})\\s*現在人數")[[1]][,2]
opt_vec <- str_match_all(txt, "(\\d{1,4})\\s*最適人數")[[1]][,2]
max_vec <- str_match_all(txt, "(\\d{1,4})\\s*最大乘載人數")[[1]][,2]

ts_reported <- str_match(txt, "最後更新時間\\s*([0-9]{4}-[0-9]{2}-[0-9]{2}\\s*[0-9]{2}:[0-9]{2})")[,2]

row <- data.frame(
  ts_site = format(now(tzone = "Asia/Taipei"), "%Y-%m-%dT%H:%M:%S"),
  people_now  = as.integer(now_vec[1]),
  optimal     = as.integer(opt_vec[1]),
  max_capacity= as.integer(max_vec[1]),
  ts_reported = ts_reported,
  source_url  = url
)

#write_csv(row, "ntu_gym_flow.csv", append = file.exists("ntu_gym_flow.csv"))
print(row)
