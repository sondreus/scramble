library(shiny)

# Only run examples in interactive R sessions
if (interactive()) {

  
  sensitive_words <- c('frog', 'bread')

  ui <- fluidPage(
    textAreaInput("text", "", "My name is frog and I am the best bread"),
    textInput("sensitive_words", "Censored words", paste(sensitive_words, collapse = ', ')),
    textInput("dictionary", "Dictionary", "Dictionary"),
    verbatimTextOutput("value")
  )
  
  server <- function(input, output) {
    
    source('scramble.R')
    
    dictionary <- data.frame(sound = c("A", "A", "A", "B", "B", "A"),
                      word = c("frog", "submarine", 
                               "bird", "cake", "bread", "synonym"))
    
    from_csv_to_vector <- function(x){gsub(' ', '', unlist(strsplit(x, ',')))}

    output$value <- renderText({scramble(input$text,
                                         dictionary,
                                         sensitive = from_csv_to_vector(input$sensitive_words))})
  }
  shinyApp(ui, server)
}
