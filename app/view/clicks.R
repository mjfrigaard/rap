# from https://appsilon.github.io/rhino/articles/tutorial/write-end-to-end-tests-with-cypress.html

box::use(
  shiny[NS, actionButton, div, moduleServer, renderText, textOutput],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  div(
    class = "clicks",
    actionButton(
      ns("click"),
      "Click me!"
    ),
    textOutput(ns("counter"))
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$counter <- renderText(input$click)
  })
}
