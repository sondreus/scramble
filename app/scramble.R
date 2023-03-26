# This program replaces words with other words, based on a common sound.

scramble <- function(text, dic, 
                     sensitive,
                     min_replacements = 5){
  
  if(length(sensitive) == 0){
    return(text)
  }

  # Subset sensitive words to those actually in text:
  for(i in 1:length(sensitive)){
  sensitive[i] <- ifelse(any(grepl(sensitive[i], text)), sensitive[i], NA)
  }
  sensitive <- na.omit(sensitive)
  sensitive <- setdiff(sensitive, "")
  if(length(sensitive) == 0){
    return(text)
  }
  
  # Save vector of original terms
  sensitive_terms <- sensitive
  
  # Build possible replacements (can potentially build in probability vector here if needed)
  replacements <- list()
  
  # Remove words without known sound or sounds without known words
  dic <- na.omit(dic)
  
  # Ensure banned words cannot be used as replacements
  dic$can_replace <- ifelse(!dic$word %in% sensitive, T, F)
  
  # Split Chinese character sequences into component characters:
  chinese_chars <- unlist(strsplit(gsub("[^\\p{Han}]", "", sensitive, perl = T), ""))
  
  # And words into component words
  non_chinese_chars <- unlist(strsplit(gsub("[\\p{Han}]", "", sensitive, perl = T), " "))
  sensitive <- unique(c(non_chinese_chars, chinese_chars))
  
  if(sum(!sensitive %in% dic$word) != 0){
    stop('Stopping: "', paste0(sensitive[!sensitive %in% dic$word], collapse ='", "'), '" not in dictionary.')
  }
  
  for(i in 1:length(sensitive)){
    replacements[[i]] <- setdiff(dic$word[dic$sound == dic$sound[dic$word == sensitive[i]] & dic$can_replace], sensitive[i])
    if(length(replacements[[i]]) < min_replacements){
      
      dic$tone <- suppressWarnings(parse_number(dic$sound))
      dic$sound2 <- gsub('[0-9]+', '', dic$sound)
      dic <- dic[order(dic$tone), ]
      
      extra <- c(replacements[[i]], na.omit(setdiff(dic$word[dic$sound2 == dic$sound2[dic$word == gsub('[0-9]+', '', sensitive[i])] & dic$can_replace], sensitive[i])))

      
      replacements[[i]] <- c(extra)[1:min(c(length(extra), min_replacements))]
      if(length(replacements[[i]]) < min_replacements){
        stop(paste0('Stopping: "', sensitive[i], '" has less than ', min_replacements, ' eligible homonyms.'))
      }
    }
  }
  
  # Generate sub-dictionary of sensitive terms and their alternatives
  term_replacements <- data.frame()
  for(i in 1:length(sensitive_terms)){
    term_replacements <- rbind(term_replacements, rep(sensitive_terms[i], min_replacements))
  }
  for(j in 1:min_replacements){
    for(i in 1:length(sensitive)){
      term_replacements[,j] <- gsub(sensitive[i],
                                    sample(replacements[[i]],
                                           1), term_replacements[,j])
    }
  }

  ind <- 0
  for(i in 1:length(sensitive_terms)){
    ind <- ind + 1
    old_text <- ""
    while(old_text != text){
      old_text <- text
      text <- sub(sensitive_terms[i], 
                  sample(term_replacements[i, ], 1),
                  text, ignore.case = T)
    }
  }
  return(text)
}

if(F){
  
  # Set locale to Chinese
  Sys.setlocale(category = "LC_ALL", locale = "chs") 
  
  # Import dictionary (source: https://www.mdbg.net/chinese/dictionary?page=cedict)
  dic <- read_csv('source-data/chinese_dic.csv')
  
  sensitive_words <- c('是', '生', '我')
  
  # Generate dummy text
  text <- "I am a 生, and I like blogs. Frog is not the answer. However, I wish it could be, at some point, fRogs, that is. Or birds for that matter. BTW, what about bread 我"
  
scramble(text, dic, sensitive = sensitive_words)
}
