`rhino` app pseudo-package
================

# `rap`

This is a **[Rhino](https://appsilon.github.io/rhino/)-based R Shiny
application** called `rap` (Appsilon’s opinionated Shiny app framework).

- **App structure**
  - `rhino.yml`: Rhino config.
  - `dependencies.R`: R dependencies.\
  - `app/`:
    - `main.R` — app entry point
    - `logic/` — business logic (data processing, plotting)
    - `view/` — UI modules (inputs, display, clicks, messages)
    - `styles/` — SCSS styling
    - `static/` — compiled CSS/JS assets
    - `js/` — custom JavaScript
- **Config**: `config.yml` for environment-based configuration,
  `renv.lock` for package management
- **Testing**:
  - `testthat` unit tests for logic and view modules
  - `shinytest2` snapshot tests for the full app
  - `cypress` end-to-end tests
- **CI**: GitHub Actions workflow (`.github/workflows/rhino-test.yml`)

## Run

You can run the application with the following:

``` r
rhino::app()
```
