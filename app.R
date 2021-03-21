library(shiny)
library(dplyr)

source(here::here("R", "functions.R"))

tweet_data = readr::read_rds(here::here("data", "tweet_data.rds"))
username_info = readr::read_rds(here::here("data", "username_art.rds"))

### Pulling in logo - shoutout to Sharla for the code
logo = a(href = "", img(src = "logo.png", alt = "rtistry art gallery", height = "75px"))

ui = tagList(
  
  ### Pulling in CSS stylesheet
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
               ),
  
  navbarPage(
    title = logo,
    windowTitle = "rtistry art gallery",
  
  ### About Us Panel
  tabPanel(
    "about us",
    h1("ABOUT US"),
    hr(),
    p("rtistry art gallery is a shiny app celebrating and showcasing the aRt community. This gallery features tweets posted using the #rtistry hashtag from January 1st, 2021 to March 20th, 2021."),
    br(),
    br(),
    h1("FEATURED ARTISTS"),
    hr(),
    # UI output that creates artist cards
    uiOutput("artist_card")
           ),
  
  # Twitter Collections
  tabPanel(
    "collections",
    column(
      width = 8,
      h1("FEATURED COLLECTIONS"),
      tags$head(
        tags$script(async = NA, src = "https://platform.twitter.com/widgets.js")
      )
    ),
    column(
      width = 4,
      selectInput("filter", 
                  label = h1("Filter by aRtist |"), 
                  choices = c("All", pull_artists(tweet_data)),
                  selected = "All"
                  )
    ),
    column(
      width = 12,
      hr()
    ),
    column(
      width = 12,
      wellPanel(
        uiOutput("tweet")
      )
    )
  )
  )
)


server = function(input, output, session) {
  
  output$tweet = renderUI({
    if(input$filter == "All"){
      
      tweet_data %>%
        purrr::pmap(create_tweet_card)
      
    } else {
      
      tweet_data %>%
        filter(username == input$filter) %>%
        purrr::pmap(create_tweet_card)
    }
    
  })
  
  output$artist_card = renderUI({
    username_info %>%
      select(-username) %>%
      purrr::pmap(create_artist_card)
  })
  
  
}

shinyApp(ui, server)