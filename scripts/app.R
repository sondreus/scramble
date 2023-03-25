library(shiny)
library(shinythemes)
library(shinyWidgets)

# Only run examples in interactive R sessions
if (interactive()) {

  Sys.setlocale(category = "LC_ALL", locale = "chs") 
  
  # sensitive_words <- c('习', '近', '平', '乔', '拜', '登')

  ui <- fluidPage(
    theme = shinytheme("darkly"),
   #  tags$head(tags$style(HTML('
   # textArea {
   #   background-color: transparent !important;
   #   border: none;
   # }'))),
   tags$head(
     tags$style(
       "body {
        margin: 20px;
      }"
     )
   ),
    tags$head(
      tags$style(
        "#themeToggle, 
            .visually-hidden {
                position: absolute;
                width: 1px;
                height: 1px;
                clip: rect(0 0 0 0);
                clip: rect(0, 0, 0, 0);
                overflow: hidden;
            }",
        "#themeToggle + span .fa-sun {
                font-size: 16pt;
            }"
      )
    ),
   fluidRow(column(width = 12, 
      "Avoid",
      checkboxInput("github_checkbox", label = HTML(paste0('<a href="https://github.com/username/repo"><i class="fa fa-github"></i>++</a>')), value = T),
      textAreaInput("sensitive_words", "and also:", "习近平"),
      "Input",
      textAreaInput("text", "", "My name is frog and I am the best bread"),
      "Output",
    textOutput("value"))),
   fluidRow(
     column(width = 12,
            div(style = "border-bottom: 1px solid gray; margin-top: 20px; margin-bottom: 20px;")
     )
   ),
   fluidRow(
     column(width = 12,
                   div(style = "text-align:left; display: inline-block;",
    checkboxInput(
      inputId = "themeToggle",
      label = icon("sun")
    ),tags$script(
      "
        // define css theme filepaths
        const themes = {
            dark: 'shinythemes/css/darkly.min.css',
            light: 'shinythemes/css/flatly.min.css'
        }

        // function that creates a new link element
        function newLink(theme) {
            let el = document.createElement('link');
            el.setAttribute('rel', 'stylesheet');
            el.setAttribute('text', 'text/css');
            el.setAttribute('href', theme);
            return el;
        }

        // function that remove <link> of current theme by href
        function removeLink(theme) {
            let el = document.querySelector(`link[href='${theme}']`)
            return el.parentNode.removeChild(el);
        }

        // define vars
        const darkTheme = newLink(themes.dark);
        const lightTheme = newLink(themes.light);
        const head = document.getElementsByTagName('head')[0];
        const toggle = document.getElementById('themeToggle');

        // define extra css and add as default
        const extraDarkThemeCSS = '.dataTables_length label, .dataTables_filter label, .dataTables_info {       color: white!important;} .paginate_button { background: white!important;} thead { color: white;}'
        const extraDarkThemeElement = document.createElement('style');
        extraDarkThemeElement.appendChild(document.createTextNode(extraDarkThemeCSS));
        head.appendChild(extraDarkThemeElement);


        // define event - checked === 'light'
        toggle.addEventListener('input', function(event) {
            // if checked, switch to light theme
            if (toggle.checked) {
                removeLink(themes.dark);
                head.removeChild(extraDarkThemeElement);
                head.appendChild(lightTheme);
            }  else {
                // else add darktheme
                removeLink(themes.light);
                head.appendChild(extraDarkThemeElement)
                head.appendChild(darkTheme);
            }
        })
        "), tags$a(href = "https://github.com/sondreus/scramble",
                   icon("github"),
                   " "))
    ))
  )
  
  server <- function(input, output) {
    
    # Load scrambler
    source('scramble.R', encoding="utf-8")
    
    # Load dictionary
    library(readr)
    dictionary <- read_csv('chinese_dic.csv')
    
    from_csv_to_vector <- function(x){gsub(' ', '', unlist(strsplit(x, ',')))}
    
    add_known <- function(x, checkmark = input$github_checkbox){
      if(checkmark){
        c(known_sensitive, from_csv_to_vector(input$sensitive_words))
      } else {
        from_csv_to_vector(input$sensitive_words)
      }
    }
    
    known_sensitive <- unique(na.omit(as.character(unlist(read_csv('sensitive_terms_prc.csv')))))

    # output$value <- renderText({scramble(input$text,
    #                                      dic = dictionary,
    #                                      sensitive = ifelse(input$github_checkbox, c(known_sensitive, from_csv_to_vector(input$sensitive_words)), from_csv_to_vector(input$sensitive_words)))})
    # 
    output$value <- renderText({scramble(input$text,
                                         dic = dictionary,
                                         sensitive = add_known(input$sensitive_words))})
  }
  shinyApp(ui, server)
}
