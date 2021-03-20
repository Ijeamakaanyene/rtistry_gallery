library(shiny)
library(dplyr)

source(here::here("R", "functions.R"))

tweet_data = readr::read_rds(here::here("data", "tweet_data.rds"))
logo = a(href = "", img(src = "logo.png", alt = "rtistry art gallery", height = "75px"))

ui = tagList(
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
               ),
  
  navbarPage(
    title = logo,
    windowTitle = "rtistry art gallery",
  
  # About Us Panel
  tabPanel(
    "about us",
    h1("ABOUT US"),
    hr(),
    p("rtistry art gallery is a shiny app celebrating all things aRt. The hashtag started in 2021 has become a space for various aRtists to showcase their work."),
    br(),
    p("Unfortunately, the curator does not have a Twitter Developer account. Therefore this art gallery only features art posted up to March 20th, 2021.")
           ),
  
  # Twitter Collections
  tabPanel(
    "collections",
    column(
      width = 9,
      h1("FEATURED COLLECTIONS"),
      #hr(),
      tags$head(
        tags$script(async = NA, src = "https://platform.twitter.com/widgets.js")
      )
    ),
    column(
      width = 3,
      selectInput("filter", 
                  label = h1("Filter by aRtist |"), 
                  choices = c("None", pull_artists(tweet_data)),
                  selected = "None"
                  )
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
    if(input$filter == "None"){
      
      tweet_data %>%
        purrr::pmap(create_tweet_card)
      
    } else {
      
      tweet_data %>%
        filter(username == input$filter) %>%
        purrr::pmap(create_tweet_card)
    }
    
  })
}

shinyApp(ui, server)