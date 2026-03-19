# NEWS

1.  `tests/testthat/test-main.R` — Rewritten Problem: The test called `testServer()` on `app/main[server]` and checked `output$message$html` for a URL that only exists in a JavaScript `alert()`. In the test context, Shiny namespaced the nested module output as `proxy1-message`, not `message`, so the test errored immediately.
    -   **Fix**: Replaced the test entirely to target `app/view/message` directly — matching the pattern of every other module test in the project. Two BDD-style scenarios now cover the module's actual behavior:
    -   **Before click**: `req(input$show_message)` raises a silent validation error; verified with `expect_error(output$message_text)`
    -   **After click**: `session$setInputs(show_message = 1)` triggers the render; verified with `expect_equal(output$message_text, "This is a message")`
2.  `tests/testthat/_snaps/rap-feature-01/` — Snapshots accepted
    -   **Problem**: The stored snapshots for Scenario B were recorded before the clicks and message modules were wired into the card body in `main.R`. The new snapshots correctly showed the `"Click me!"` and `"Show message"` buttons above the plot, new inputs/outputs for both modules, and a coordmap resolution change from 2× (1582×956) to 1× (791×360) — consistent with a `shinytest2` version update. Plot data and axes were identical.
    -   **Fix**: Accepted via `testthat::snapshot_accept("rap-feature-01/")`.
3.  `tests/testthat/_snaps/shinytest2/` — Snapshots accepted
    -   **Problem**: Same root cause as above — the `shinytest2` recording snapshot was also stale for the same reasons (missing clicks/message UI, 2× coordmap).
    -   **Fix**: Accepted via `testthat::snapshot_accept("shinytest2/")`.
4.  `tests/testthat/test-plot.R` — Deprecation warning fixed
    -   **Problem**: `ggplot2::is.ggplot()` was deprecated in `ggplot2` 3.5.2.
    -   **Fix**: Updated both the `box::use()` import and the call site from `is.ggplot` → `is_ggplot`.
    -   **Net result**
        -   `testthat`: 2 failures, 1 warning 11/11 pass, 0 warnings
        -   Cypress: Couldn't find specs (wrong working dir) 3/3 pass (run from `tests/`)
            -   The Cypress discovery issue wasn't a code fix — the spec files are in `tests/cypress/e2e/` and `cypress.config.js` resolves paths relative to its own location, so `npx cypress run` needs to be run from the `tests/` directory.
5.  `rhino::test_e2e()` — Cypress binary missing from cache
    -   **Problem**: `rhino::test_e2e()` failed with `Error in node_run(): System command 'npm' exited with status 1`. The error was opaque because rhino swallows npm's actual output. Running npm directly from `.rhino/` revealed the real cause: the Cypress 13.6.2 binary was missing from `~/Library/Caches/Cypress/13.6.2/` (likely cleared by a cache cleanup or OS update).
    -   **Fix**: Reinstalled the Cypress binary by running `./node_modules/.bin/cypress install` from the `.rhino/` directory.
    -   **Note**: If this recurs, re-run the same command from `.rhino/` to restore the binary without touching `node_modules`.
6.  GitHub Actions: I initially used [Codex](https://chatgpt.com/s/cd_69bc75957670819193b71967b5d4419e) to try and debug the failed GitHub Actions run, but after asking Posit Assistant, I was able to do this in the IDE.
    -   **Root cause**: The `packages` array in the workflow was empty, so `libcurl4-openssl-dev` was never installed. This caused `setup-renv` to fail when compiling the `curl` R package, which meant `rhino` was never installed, which caused every subsequent step to fail with "there is no package called 'rhino'". With none of the rhino steps running, `.rhino/` was never initialized, so `cypress-io/github-action@v6` also failed with "missing package manager lockfile."

        **Fixes made:**

        -   **`rhino-test.yml`** — Added `libcurl4-openssl-dev`, `libssl-dev`, and `libxml2-dev` to the `packages` array (needed by `curl`, `openssl`, and `xml2` respectively)

        -   **`rhino-test.yml`** — Updated `actions/setup-node` from `@v3` to `@v4` to address the Node.js 20 deprecation warning (forced cutover is June 2026)

        -   **`renv.lock`** — Synced the `globals` package version mismatch
