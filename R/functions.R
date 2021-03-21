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
    class = "col-sm-4",
    tags$div(
      class = "well artist-card",
      tags$img(class = "img-responsive img-circle", style = "float:left", src = profile_image_url),
      tags$a(class = "inline artist-link", style = "text-align: right", href = link_to_profile, h1(username_handle)),
      tags$p(style = "text-align: right", "aRt pieces: ", num_art)
    )
  )
}