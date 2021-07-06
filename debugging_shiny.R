# Debugging in Shiny examples
library(shiny)
library(plotly)
library(dplyr)

# Our dummy dataset
dummy_data <- data.frame(age = floor(runif(1000,0,100)), 
                         area = c("A", "B", "C", "D"),
                         sex = c("F", "M"))



###############################################.

# Just an static table with the first few rows of the dataset
ui <- fluidPage("Shiny app",
                selectInput("area", "Select area", choices = c("A", "B", "C", "D")),
                selectInput("sex", "Select sex", choices = c("F", "M")),
                plotlyOutput("chart")
) 


server <- function(input, output, session) {
  
  filtered_data <- reactive({
    dummy_data %>% 
      filter(area == input$area &
               sex == input$area)
  })
  
  output$chart <- renderPlotly({ 
    chart_data <- filterred_data() %>% group_by(age) %>%
      count() %>% ungroup()
    
    plot_ly(data=chart_data, x=~age,  y = ~n) %>% 
      add_bars()
  })
  
} 

shinyApp(ui = ui, server = server) # Running the app 

# This is the most classical mistake, a name typo. If it tells you it doesn't exist,
# it really doesn't, check your names

###############################################.

ui <- fluidPage("Shiny app",
                selectInput("area", "Select area", choices = c("A", "B", "C", "D")),
                selectInput("sex", "Select sex", choices = c("F", "M")),
                plotlyOutput("chart")
) 


server <- function(input, output, session) {
  
  filtered_data <- reactive({
    dummy_data %>% 
      filter(area == input$area &
               sex == input$area)
  })
  
  output$chart <- renderPlotly({ 
    chart_data <- filtered_data() %>% group_by(age) %>%
      count() %>% ungroup()
    
    plot_ly(data=chart_data, x=~age,  y = ~n) %>% 
      add_bars()
  })
  
} 

shinyApp(ui = ui, server = server) # Running the app 

# But hold on, this still doesn't work. The filter is failing.

###############################################.
# Adding print results

ui <- fluidPage("Shiny app",
                selectInput("area", "Select area", choices = c("A", "B", "C", "D")),
                selectInput("sex", "Select sex", choices = c("F", "M")),
                plotlyOutput("chart"),
                tableOutput("table")
) 


server <- function(input, output, session) {
  
  filtered_data <- reactive({
    dummy_data %>% 
      filter(area == input$area &
               sex == input$area)
  })
  
  output$chart <- renderPlotly({ 
    chart_data <- filtered_data() %>% group_by(age) %>%
      count() %>% ungroup()
    
    # Adding checks of the data and inputs
    print(input$area)
    print(input$sex)
    print(head(filtered_data()))
    
    
    plot_ly(data=chart_data, x=~age,  y = ~n) %>% 
      add_bars()
    
  })
  
  # Adding table to check
  output$table <- renderTable({ 
    filtered_data()
  })
} 

shinyApp(ui = ui, server = server) # Running the app 


###############################################.
# Adding browser

ui <- fluidPage("Shiny app",
                selectInput("area", "Select area", choices = c("A", "B", "C", "D")),
                selectInput("sex", "Select sex", choices = c("F", "M")),
                actionButton("browser", "Browser"), #adding browser effect
                plotlyOutput("chart")
) 


server <- function(input, output, session) {
  
  observeEvent(input$browser, browser()) #adding browser effect
  
  filtered_data <- reactive({
    dummy_data %>% 
      filter(area == input$area &
               sex == input$area)
  })
  
  output$chart <- renderPlotly({ 
    chart_data <- filtered_data() %>% group_by(age) %>%
      count() %>% ungroup()
    
    plot_ly(data=chart_data, x=~age,  y = ~n) %>% 
      add_bars()
  })
  
} 

shinyApp(ui = ui, server = server) # Running the app 

###############################################.
# Building staticly
input_sex <- "M"
input_age <- 30

chart_data <- dummy_data %>% 
  filter(sex == input_sex &
           age > input_age) %>% 
  group_by(area) %>%
  count() %>% ungroup()

plot_ly(data=chart_data, x=~area,  y = ~n) %>% 
  add_bars()



