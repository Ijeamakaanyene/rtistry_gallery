library(shiny)


ui = navbarPage(
  title = "rtistry art gallery",
  
  # About Us Panel
  tabPanel(
    "about us",
    h1("ABOUT US"),
    p("rtistry art gallery is a shiny app celebrating all things aRt. The hashtag started in 2021 has become a space for various aRtists to showcase their work.
    Unfortunately, the curator does not have a Twitter Developer account. Therefore this art gallery only features art posted up to March 20th, 2021.")
           ),
  
  # Twitter Collections
  tabPanel(
    "collections",
    column(
      width = 9,
      p("FEATURED COLLECTIONS"),
      tags$head(
        tags$script(async = NA, src = "https://platform.twitter.com/widgets.js")
      )
    ),
    column(
      width = 3,
      selectInput("sort", label = "Sort by aRtist |", choices = c("Placeholder1", "Placeholder2"))
    ),
    
    column(
      width = 12,
      wellPanel(
        uiOutput("tweet")
      )
    )
    
  )
)


server = function(input, output, session) {
  output$tweet = renderUI({
    tagList(
      tags$blockquote(class = "twitter-tweet",
                      tags$a(href = "https://twitter.com/geokaramanis/status/1373266862792925185")),
      tags$script('twttr.widgets.load(document.getElementById("tweet"));')
    )
  })
}

shinyApp(ui, server)