box::use(
  bslib[bs_theme, card, card_body, card_header, layout_sidebar, page_fillable, sidebar],
  shiny[NS, icon, moduleServer, span, tags],
)

# import modules ----
box::use(
  app / view / aes_inputs,
  app / view / clicks,
  app / view / display,
  app / view / message,
  app / view / var_inputs,
)

#' rap ui
#' @export
ui <- function(id) {
  ns <- NS(id)
  page_fillable(
    theme = bs_theme(
      bg = "#202123",
      fg = "#B8BCC2",
      primary = "#EA80FC",
      secondary = "#48DAC6",
      base_font = c("Proxima Nova", "sans-serif"),
      code_font = c("Hack", "monospace"),
      heading_font = c("Optima", "sans-serif")
    ),
    layout_sidebar(
      sidebar = sidebar(
        var_inputs$ui(ns("vals")),
        aes_inputs$ui(ns("aes"))
      ),
      card(
        full_screen = TRUE,
        card_header(
          tags$button(
            id = "help-button",
            icon("info"),
            onclick = "App.showHelp()"
          )
        ),
        card_body(
          span(
            clicks$ui(ns("clicks")),
            message$ui(ns("message")),
          ),
          display$ui(ns("disp"))
        )
      )
    )
  )
}

#' rap server
#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    # collect variable inputs module server ----
    selected_vars <- var_inputs$server(id = "vals")
    # collect aesthetic inputs module server ----
    selected_aes <- aes_inputs$server(id = "aes")

    # pass to display module server ----
    display$server(
      id = "disp",
      var_inputs = selected_vars,
      aes_inputs = selected_aes
    )
  })

  moduleServer(id, function(input, output, session) {
    clicks$server("clicks")
    message$server("message")
  })
}
