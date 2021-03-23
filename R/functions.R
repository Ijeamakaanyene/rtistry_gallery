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
      tags$div(
        tags$img(class = "img-responsive img-circle", style = "float:right", src = profile_image_url),
        tags$p("Artist: ", style = "text-align: left", 
               tags$a(class = "artist-link", href = link_to_profile, username_handle)),
        tags$p(style = "text-align: left", "Collection: ", num_art, " pieces")
        )
      )
  )
}

