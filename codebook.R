# install.packages("shiny")
# install.packages("shinydashboard")
# install.packages("dplyr")
# install.packages("ggplot2")
# install.packages("ggExtra")
# install.packages("tidyverse")
# install.packages("lubridate")

library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(ggExtra)
library(tidyverse)
library(lubridate)

source("dashboard_functions.R")
source("functions_process_control.R")

ui <- dashboardPage(
  dashboardHeader(title = "Patient Wait Times"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Enter Patient Metrics", tabName = "patient-metrics", icon = icon("user-plus")),
      menuItem("Patient Log", tabName = "log", icon = icon("table")),
      menuItem("Process Capability", tabName = "capability", icon = icon("chart-line"))
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "patient-metrics",
              fluidRow(
                fileInput("file1", "Choose CSV File",
                          accept = c("text/csv",
                                     "text/comma-separated-values",
                                     ".csv")),
                textInput(inputId = "patient_id",
                          label = "Patient ID"),
                selectInput(inputId = "status", 
                            label = "Status", 
                            choices = c("Admitted", "Discharged"), 
                            selected = "Admitted"),
                conditionalPanel(
                  condition = "input.status == 'Admitted'",
                  selectInput(inputId = "dept", 
                              label = "Department", 
                              choices = c("Cardiology", "Emergency", "General Surgery", "Intensive Care", "Neurology", "Oncology", "Orthopedics"), 
                              selected = "Cardiology"),
                  selectInput(inputId = "severity", 
                              label = "Patient Acuity", 
                              choices = c("Critical", "Moderate", "Stable"), 
                              selected = "Mild"),
                  selectInput(inputId = "treatment", 
                              label = "Treatment", 
                              choices = c("Imaging", "Labs", "Physicians / Specialized Consultancy", "Procedures", "Rehabilitation"), 
                              selected = "Imaging")
                ),
                actionButton(inputId = "enter_button",
                             label = "Enter")
              )
      ),
      
      tabItem(tabName = "log",
              fluidRow(
                box(title = "Data Table", width = 20,
                    tableOutput("table1"))
              )
      ),
      tabItem(tabName = "capability",
              fluidRow(
                selectInput(inputId = "graph_by", 
                            label = "Graph By", 
                            choices = c("Department", "Patient_Acuity", "Treatment", "Shift_Section"), 
                            selected = "Department"),
                box(title = "Average Graph", width = 20,
                    plotOutput("graph1"))
              )
      )
    )
  )
)

server <- function(input, output, session) {
  # Reactive data frame that persists during the session
  user_data <- reactiveVal(data.frame(
    Patient_ID = character(),
    Status = character(),
    Department = character(),
    Patient_Acuity = character(),
    Treatment = character(),
    Expected_Checkin = as.POSIXct(character(), format = "%H:%M:%S"),
    Time_Stamp = as.POSIXct(character(), format = "%H:%M:%S"),
    Percent_Deviation = numeric(),
    Shift = character(),
    Shift_Section= character(),
    Weekend = logical(),
    Next_Checkin = as.POSIXct(character(), format = "%H:%M:%S")
  )
  )
  uploaded_data <- reactive({
    req(input$file1) # Ensure a file has been uploaded
    
    df <- read.csv(input$file1$datapath)
    
    # Optional: Perform any initial data processing here
    # Example: df$timestamp <- as.POSIXct(df$timestamp)
    
    return(df)
  })
  output$graph1 <- renderPlot({
    format_plots(fake_data(), input$graph_by)
  })
  observeEvent(input$file1, {
    output$table1 <- renderTable({
      uploaded_data()
    })
    output$graph1 <- renderPlot({
      process_csv(uploaded_data(), input$graph_by)
  })})
  observeEvent(input$enter_button, {
    # This code will only run when the "Submit" button is clicked.
    # For example, print the text input to the console
    # print(paste("The user submitted:", input$patient_id))
    # showNotification("Patient ID is", input$patient_id, type = "message")
    new_row <- get_info(user_data(), Sys.time(), input$patient_id, input$status, input$dept, input$severity, input$treatment)
    
    updated_data <- rbind(user_data(), new_row)
    user_data(updated_data)
    
    output$table1 <- renderTable({
      user_data()
    })
    
    print(format_plots(fake_data(), "Treatment"))
    print(user_data)
    
  })
}

shinyApp(ui, server)