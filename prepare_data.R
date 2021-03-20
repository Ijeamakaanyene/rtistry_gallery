library(dplyr)
library(stringr)

tweets = rio::import(here::here("data", "tweet_data.xlsx")) %>%
  mutate(username = str_extract_all(link, "https://twitter.com/\\w+"),
         username = str_remove_all(username, "https://twitter.com/"))


readr::write_rds(tweets, here::here("data", "tweet_data.rds"))

  
