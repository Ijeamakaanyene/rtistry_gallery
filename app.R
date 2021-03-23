library(shiny)
library(shinycssloaders)
library(dplyr)
library(reactable)
library(shinyPagerUI)

source(here::here("R", "functions.R"))

tweet_data = readr::read_rds(here::here("data", "tweet_data.rds"))
username_info = readr::read_rds(here::here("data", "username_art.rds"))

### Pulling in logo - shoutout to Sharla for the code
logo = a(href = "", img(src = "logo-animated.gif", alt = "rtistry art gallery", height = "75px"))

ui = tagList(
  
  ### Pulling in CSS stylesheet
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
               ),
  
  navbarPage(
    title = logo,
    windowTitle = "rtistry art gallery",
  
  ### About Panel
  tabPanel(
    "about the gallery",
    h2("ABOUT THE GALLERY"),
    hr(),
    p("rtistry art gallery is a shiny app celebrating and showcasing art in all its forms created by the #rstats community. This gallery features tweets posted using the #rtistry hashtag from January 1st, 2021 to March 20th, 2021."),
    br(),
    br(),
    h2("FEATURED ARTISTS"),
    hr(),
    # UI output featuring artists cards
    uiOutput("artist_card")),
  
  ### Twitter Collections
  tabPanel(
    "collections",
    id = "collections",
    column(
      width = 12,
      tags$head(tags$script(async = NA, src = "https://platform.twitter.com/widgets.js"))
      ),
    column(
      width = 5,
      tags$div(
        class = "well artist-card",
        h3("SELECTED WORK"),
        p("Filter to specific aRtists of interests, or leave as all."),
        selectInput("filter", 
                    label = NULL,
                  choices = c("All", pull_artists(tweet_data)),
                  selected = "All"),
        p("Click through to view all #rtistry pieces."),
        pageruiInput('pager', 1, nrow(tweet_data))
      )
    ),
    column(
      width = 7,
      tags$div(
        class = "well picture-frame",
          uiOutput("tweet")
        )
        )
        
      ),
  tabPanel(
    "learn more",
    h2("ABOUT THIS APP"),
    hr(),
    column(
      width = 12,
      tags$div(
        class = "well artist-card",
        p("rtistry art gallery was made by Ijeamaka Anyene, ", 
          a(href = "https://twitter.com/ijeamaka_a", class = "artist-link", "@ijeamaka_a")), 
        p("The source code can be found on ", 
          a(href = "https://github.com/Ijeamakaanyene/rtistry_gallery", class = "artist-link", "Github.")),
        p("The design for this app was inspired by ",
          a(href = "https://spoke-art.com/", class = "artist-link", "Spoke-Art gallery.")), 
        p("The art gallery logo was created by Allison Horst, ",
          a(href = "https://twitter.com/allison_horst", class = "artist-link", "@allison_horst."))
      )
    )
    
  )
    )

)



server = function(input, output, session) {
  
  #### Collections
  # Filter the data
  filtered_tweet_data = reactive({
    if(input$filter == "All"){
      
      tweet_data 
      
    } else {
      
      tweet_data %>%
        filter(username == input$filter)
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
      c(input$collections, input$filter)
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
      select(-username) %>%
      purrr::pmap(create_artist_card)
  })
  
  
}

shinyApp(ui, server)