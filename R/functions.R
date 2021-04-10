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
                    tags$img(src = "art_brush_loading.png", alt = "loading art", height = "75px"),
                    "Art Loading. . .",
                    tags$a(href = link)),
    tags$script('twttr.widgets.load(document.getElementById("tweet"));')
  )
}

create_artist_card = function(username_handle, 
                              num_art, 
                              link_to_profile,
                              profile_image_url){
  
  artist_options = c("creative coder", "generative artist", 
                     "digital artist", "algorithmic artist", 
                     "computational artist")
  
  tags$div(
    class = "col-sm-4",
    tags$div(
      class = "well artist-gallery-card",
      #style = "background-image: url('art_bckgrnd_example.jpeg')",
      tags$div(
        tags$p(style = "text-align: center; margin: 0px 0px 5px;", 
               tags$a(class = "artist-link", 
                      style = "font-size: 20px",
                      href = link_to_profile, username_handle)),
        tags$p(style = "text-align: center; font-size: 16px; margin: 0px 0px;", sample(artist_options, 1)),
        tags$p(style = "text-align: center; font-size: 14px;", 
               "Collection: ", num_art, 
               ifelse(num_art == 1, " piece", "pieces"))
        
        )
      )
  )
}


