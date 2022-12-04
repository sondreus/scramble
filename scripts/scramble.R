# This program replaces characters with other characters, based on a common sound (pinyin).

# Set locale to Chinese
Sys.setlocale(category = "LC_ALL", locale = "chs") 

# Import dictionary (source: https://www.mdbg.net/chinese/dictionary?page=cedict)
dic <- read.csv('source-data/cedict_ts.u8')


# Generate dummy dictionary
dic <- data.frame(pinyin = c("A", "A", "A", "B", "B"),
                  word = c("frog", "submarine", 
                           "bird", "cake", "bread"))

# Generate dummy text
text <- "I am a frog, and I like blogs. Frog is not the answer. However, I wish it could be, at some point, fRogs, that is. Or birds for that matter. BTW, what about bread"

scramble <- function(text, dic, 
                     sensitive = c('frog', 'bread')){
  
  # Build possible replacements (can potentially build in probability vector here if needed)
  replacements <- list()
    for(i in 1:length(sensitive)){
    replacements[[i]] <- setdiff(dic$word[dic$pinyin == dic$pinyin[dic$word == sensitive[i]]], sensitive[i])
    if(length(replacements[[i]]) == 0){
      stop(paste0('Stopping: ', sensitive[i], ' has not eligible homonyms.'))
    }
  }
  
  ind <- 0
  for(i in sensitive){
    ind <- ind + 1
    old_text <- ""
    while(old_text != text){
      old_text <- text
      text <- sub(i, 
                  sample(replacements[[ind]], 1),
                  text, ignore.case = T)
    }
  }
  return(text)
}

scramble(text, dic)

