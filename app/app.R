library(shiny)
library(shinythemes)
library(shinyWidgets)

# Only run examples in interactive R sessions
if (interactive()) {

  Sys.setlocale(category = "LC_ALL", locale = "chs") 
  options(encoding = "UTF-8")
  
  ui <- fluidPage(
    options(encoding = "UTF-8"),
    theme = shinytheme("darkly"),
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
                   "",
      textAreaInput("text", icon('pen'), "今年是中国立宪百年，《世界人权宣言》公布60周年，“民主墙”诞生30周年，中国政府签署《公民权利和政治权利国际公约》10周年。在经历了长期的人权灾难和艰难曲折的抗争历程之后，觉醒的中国公民日渐清楚地认识到，自由、平等、人权是人类共同的普世价值；民主、共和、宪政是现代政治的基本制度架构。抽离了这些普世价值和基本政制架构的“现代化”，是剥夺人的权利、腐蚀人性、摧毁人的尊严的灾难过程。21世纪的中国将走向何方，是继续这种威权统治下的“现代化”，还是认同普世价值、融入主流文明、建立民主政体？这是一个不容回避的抉择。", width = '100%', heigh = "150px"),
      icon('envelope'),
    textOutput("value")),
    fluidRow(
      column(width = 12,
             div(style = "border-bottom: 1px solid gray; margin-top: 20px; margin-bottom: 20px;")
      )
    ),
   textInputIcon("sensitive_words", "", icon = icon("ban"), value = "新疆再教育營, 中国治贪史"),
   checkboxInput("github_checkbox", label = HTML(paste0('+<a href="https://github.com/jasonqng/chinese-keywords/"><i class="fa fa-github"></i>(684 blocked on weibo)</a>')), value = T)),
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
                   "{open source code}"))
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
