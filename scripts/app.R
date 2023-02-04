library(shiny)

# Only run examples in interactive R sessions
if (interactive()) {

  Sys.setlocale(category = "LC_ALL", locale = "chs") 
  
  sensitive_words <- c('frog', 'bread')

  ui <- fluidPage(
    textAreaInput("text", "", "My name is frog and I am the best bread"),
    textInput("sensitive_words", "Censored words", paste(sensitive_words, collapse = ', ')),
    textInput("dictionary", "Dictionary", "Dictionary"),
    verbatimTextOutput("value")
  )
  
  server <- function(input, output) {
    
    source('scramble.R', encoding="utf-8")
    
    library(readr)
    dictionary <- read_csv('chinese_dic.csv')
    
    from_csv_to_vector <- function(x){gsub(' ', '', unlist(strsplit(x, ',')))}
    
    output$value <- renderText({scramble(input$text,
                                         dic = dictionary,
                                         sensitive = from_csv_to_vector(input$sensitive_words))})
  }
  shinyApp(ui, server)
}
