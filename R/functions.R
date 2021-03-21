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

create_artist_card = function(username_handle, 
                              num_art, 
                              link_to_profile,
                              profile_image_url){
  tags$div(
    class = "col-sm-3",
    tags$div(
      class = "well",
      tags$img(class = "inline img-responsive img-circle", src = profile_image_url),
      tags$a(class = "inline", href = link_to_profile, h1(username_handle)),
      tags$p(class = "inline", "aRt pieces: ", num_art)
    )
  )
}