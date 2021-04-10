library(shiny)
library(dplyr)
library(shinyPagerUI)

source(here::here("R", "functions.R"))

tweet_data = readr::read_rds(here::here("data", "tweet_data.rds"))
username_info = readr::read_rds(here::here("data", "username_art.rds"))

### Pulling in logo - shoutout to Sharla for the code
logo = a(href = "", img(src = "logo-animated.gif", alt = "rtistry art gallery", height = "75px"))

ui = tagList(
  
  ### Pulling in CSS stylesheet
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
    ),
  
  navbarPage(
    title = logo,
    windowTitle = "rtistry art gallery",
  
  ### About Panel
  tabPanel(
    "ABOUT THE GALLERY",
    h2("About the gallery"),
    hr(),
    p("rtistry art gallery is a shiny app celebrating and showcasing art in all its forms created by the #rstats community. This gallery features tweets posted using the #rtistry hashtag from January 1st, 2021 to March 31st, 2021."),
    br(),
    br(),
    h2("Featured artists"),
    selectInput("artist_filter", label = NULL, 
                choices = c("Artist (A-Z)" = "username", 
                            "Pieces in Collections" = "num_art")),
    hr(),
    # UI output featuring artists cards
    uiOutput("artist_card")
    ),
  
  ### Twitter Collections
  tabPanel(
    "COLLECTIONS",
    id = "collections",
    column(
      width = 12,
      tags$head(tags$script(async = NA, src = "https://platform.twitter.com/widgets.js"))
      ),
    column(
      width = 5,
      wellPanel(
        class = "artist-card",
        h3("Selected works"),
        p("Filter to specific aRtists of interest or leave as all."),
        selectInput("collections_filter", 
                    label = NULL,
                    choices = c("All", pull_artists(tweet_data)),
                    selected = "All"),
        p("Click through to view all #rtistry pieces."),
        pageruiInput('pager', 1, nrow(tweet_data))
      )
    ),
    column(
      width = 7,
      wellPanel(
        class = "picture-frame",
        uiOutput("tweet")
        )
      )
    ),
  
  tabPanel(
    "LEARN MORE",
    h2("About this app"),
    hr(),
    column(
      width = 12,
      wellPanel(
        class = "artist-card",
        style = "text-align: center",
        p("rtistry art gallery was made by ", 
          a(href = "https://ijeamaka-anyene.netlify.app/", 
            class = "artist-link", 
            style = "font-size: 16px",
            "Ijeamaka Anyene")), 
        p("The source code can be found on ", 
          a(href = "https://github.com/Ijeamakaanyene/rtistry_gallery", 
            class = "artist-link", 
            style = "font-size: 16px",
            "Github")),
        p("The design for this app was inspired by ",
          a(href = "https://spoke-art.com/", 
            class = "artist-link", 
            style = "font-size: 16px",
            "Spoke-Art gallery")), 
        p("The art gallery logo was created by ",
          a(href = "https://twitter.com/allison_horst", 
            class = "artist-link", 
            style = "font-size: 16px",
            "Allison Horst")),
        p("Art brush loading icon is by Nociconist from the Noun Project")
      )
    )
    )
  )
)



server = function(input, output, session) {
  
  #### Collections
  # Filter the data
  filtered_tweet_data = reactive({
    if(input$collections_filter == "All"){
      
      tweet_data 
      
    } else {
      
      tweet_data %>%
        filter(username == input$collections_filter)
    }
  })
  
  # Reduce dataset to page selected
  output_tweet_data = reactive({
    
    filtered_tweet_data() %>%
        slice(input$pager$page_current) 
    
  })
  
  # Triggers when clicks tabpanel collections and when filtered
  # Also this section is 100% from wleepang/shiny-pager-ui example
  observeEvent(
    eventExpr = {
      c(input$collections, input$collections_filter)
    },
    
    handlerExpr = {
      # Updates pages total to filtered data
      pages_total = nrow(filtered_tweet_data())
      page_current = input$pager$page_current
      if (input$pager$page_current > pages_total) {
        page_current = pages_total
      }
      
      updatePageruiInput(
        session, 'pager',
        page_current = page_current,
        pages_total = pages_total
      )
    }
  )

  # Creates the output of the tweet
  output$tweet = renderUI({
    
      output_tweet_data() %>%
        purrr::pmap(create_tweet_card)
    
  })
  
  ### FEATURED ARTISTS
  # creates the output of the artist card
  output$artist_card = renderUI({
    
      username_info %>%
        arrange(!!rlang::sym(input$artist_filter)) %>%
        select(-username) %>%
        purrr::pmap(create_artist_card)
    
  })
  
  
}

shinyApp(ui, server)