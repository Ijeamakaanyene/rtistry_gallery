library(dplyr)
library(stringr)

# Pull hand collected tweets!
tweets = rio::import(here::here("data", "tweet_data.xlsx")) %>%
  mutate(username = str_extract_all(link, "https://twitter.com/\\w+"),
         username = str_remove_all(username, "https://twitter.com/")) %>%
  unique()

# Create username df
username_info = tweets %>%
  count(username, name = "num_art") %>%
  mutate(username_handle = glue::glue("@{username}"),
         link_to_profile = glue::glue("https://twitter.com/{username}"))

# Pull usernames
usernames = username_info %>%
  select(username) %>%
  arrange(username) %>%
  pull()

# Pull profile images from users
users_df = rtweet::lookup_users(usernames)

user_image_url = users_df %>%
  select(screen_name, profile_image_url)

# Merge info back into username_info
username_info_export = left_join(username_info, user_image_url,
                                 by = c("username" = "screen_name"))

readr::write_rds(tweets, here::here("data", "tweet_data.rds"))
readr::write_rds(username_info_export, here::here("data", "username_art.rds"))
