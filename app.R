library(shiny)

# For download of csv files to work for shinylive
# https://stackoverflow.com/questions/78344439/shinylive-wont-allow-downloading-data-tables-as-csv-files
downloadButton <- function(...) {
  tag <- shiny::downloadButton(...)
  tag$attribs$download <- NULL
  tag
}

ui <- fluidPage(

  titlePanel("Hi there!"),

  sidebarLayout(

    sidebarPanel(

      shiny::numericInput(inputId = "uid",
                          label = "Enter your University ID without any u prefix (e.g. 30000000)",
                          value = 30000000)

    ),

    mainPanel(
      downloadButton("download", "Download the data below."),
      br(), br(),
      dataTableOutput("data")
    )
  )
)

server <- function(input, output) {
  simdata <- reactive({
    set.seed(input$uid)
    n <- 1000
    x <- runif(n, -1, 1)
    y <- x + rnorm(n)
    data.frame(y, x)
  })
  output$data <- renderDataTable(simdata())
  output$download <- downloadHandler(
    filename = function() {
      paste0("data-", input$uid, ".csv")
    },
    content = function(file) {
      write.csv(simdata(), file)
    }
  )

}

shinyApp(ui = ui, server = server)
