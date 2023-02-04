# This program replaces words with other words, based on a common sound.

scramble <- function(text, dic, 
                     sensitive = c('frog', 'bread')){
  
  # Build possible replacements (can potentially build in probability vector here if needed)
  replacements <- list()
  
  if(sum(!sensitive %in% dic$word) != 0){
    stop('Stopping: ', sensitive[!sensitive %in% dic$word], ' not in dictionary.')
  }
  
  # Ensure banned words cannot be used as replacements
  dic$can_replace <- ifelse(!dic$word %in% sensitive, T, F)
  
  # Generate replacement words
  for(i in 1:length(sensitive)){
    replacements[[i]] <- setdiff(dic$word[dic$sound == dic$sound[dic$word == sensitive[i]] & dic$can_replace], sensitive[i])
    if(length(replacements[[i]]) == 0){
      stop(paste0('Stopping: ', sensitive[i], ' has no eligible homonyms.'))
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

if(F){
  
  # Set locale to Chinese
  Sys.setlocale(category = "LC_ALL", locale = "chs") 
  
  # Import dictionary (source: https://www.mdbg.net/chinese/dictionary?page=cedict)
  dic <- read.csv('source-data/cedict_ts.u8')
  
  
  
  # Generate dummy dictionary
  dic <- data.frame(sound = c("A", "A", "A", "B", "B"),
                    word = c("frog", "submarine", 
                             "bird", "cake", "bread"))
  sensitive_words <- c('frog', 'bread')
  
  # Generate dummy text
  text <- "I am a frog, and I like blogs. Frog is not the answer. However, I wish it could be, at some point, fRogs, that is. Or birds for that matter. BTW, what about bread"
  
  
scramble(text, dic)
}
