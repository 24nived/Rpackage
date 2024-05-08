# Load necessary libraries
library(shiny)
library(readxl)
library(ggplot2)

# Define UI for application
ui <- fluidPage(
  titlePanel("Team Goals Bar Chart"),
  
  # Sidebar layout
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Choose XLS file"),
      tags$hr(),
      helpText("Please upload an Excel file with two columns: 'Team' and 'Goals'.")
    ),
    
    # Display the bar chart
    mainPanel(
      plotOutput("bar_chart")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Read the uploaded file
  data <- reactive({
    req(input$file)
    inFile <- input$file
    if (is.null(inFile))
      return(NULL)
    df <- read_excel(inFile$datapath)
    return(df)
  })
  
  # Create the bar chart
  output$bar_chart <- renderPlot({
    req(data())
    ggplot(data(), aes(x = Team, y = Goals)) +
      geom_bar(stat = "identity", fill = "skyblue") +
      labs(title = "Team Goals", x = "Team", y = "Goals") +
      theme_minimal()
  })
}

# Run the application
shinyApp(ui = ui, server = server)
