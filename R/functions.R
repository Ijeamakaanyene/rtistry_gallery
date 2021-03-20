pull_artists = function(tweets_data){
  artists = 
    tweets_data %>%
    select(username) %>%
    arrange(username) %>%
    pull()
  
  return(artists)
}

create_tweet_card = function(username, link){
  tagList(
    tags$blockquote(class = "twitter-tweet",
                    tags$a(href = link)),
    tags$script('twttr.widgets.load(document.getElementById("tweet"));')
  )
}
