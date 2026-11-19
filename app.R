library(shiny)
library(bslib)
library(dplyr)
library(DT)
library(ggplot2)

source("R/prepare_data.R")

ui = page_sidebar(
  title = "Clinical Trial Dashboard",
  sidebar = sidebar(
    selectInput(
      inputId = "arm",
      label = "Treatment arm",
      choices = c("All", unique(adsl_trt$TRT01A))
      ),
    selectInput(
      inputId = "lab",
      label = "Lab test",
      choices = sort(unique(adlb_trt$PARAM))
    )
    ),
    
  navset_card_tab(
    nav_panel("Demographics", DTOutput("demog_table")),
    nav_panel("Adverse events", plotOutput("ae_plot")),
    nav_panel("Lab results", plotOutput("lab_plot"))
  )
)

server = function(input, output) {
  
  filtered_adsl = reactive({
    if (input$arm == "All") {
      adsl_trt
    } else {
      adsl_trt |> filter(TRT01A == input$arm)
    }
  })
  
  output$demog_table = renderDT({
    filtered_adsl() |>
      group_by(TRT01A) |>
      summarise(
        n_patients = n(),
        mean_age = round(mean(AGE), 1),
        pct_female = round(mean(SEX == 'F') *100 ,1)
      )
  })
  # Adverse events, filtered by the dropdown
  filtered_adae = reactive({
    if (input$arm == "All") {
      adae_te
    } else {
      adae_te |> filter(TRT01A == input$arm)
    }
  })
  
  output$ae_plot = renderPlot({
    top_aes = filtered_adae() |>
      count(AEDECOD, sort = TRUE) |>
      head(10)
    
    ggplot(top_aes, aes(x = reorder(AEDECOD, n), y = n)) +
      geom_col() +
      coord_flip() +
      labs(
        x = NULL,
        y = "Number of events",
        title = "Top 10 treatment-emergent adverse events"
      )
  })
  
  filtered_adlb = reactive({
    data = adlb_trt |> filter(PARAM == input$lab)
    if (input$arm != "All") {
      data = data |> filter(TRT01A == input$arm)
    }
    data
  })
  
  output$lab_plot = renderPlot({
    lab_summary = filtered_adlb() |>
      group_by(TRT01A, AVISITN) |>
      summarise(mean_value = mean(AVAL), .groups = "drop")
    
    ggplot(lab_summary, aes(x = AVISITN, y = mean_value, colour = TRT01A)) +
      geom_line() +
      geom_point() +
      labs(
        x = "Visit (week)",
        y = "Mean value",
        colour = "Treatment arm",
        title = paste("Mean", input$lab, "over time")
      )
  })
}

shinyApp(ui, server)


