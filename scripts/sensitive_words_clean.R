# Process list of sensitive terms

library(readr)
terms <- read_csv("https://raw.githubusercontent.com/jasonqng/chinese-keywords/master/csv/all.csv")

sensitive_chinese_words <- terms[terms$list_blockedweibo == 1, 1]
sensitive_chinese_words$chinese_char <- NA
for(i in 1:nrow(sensitive_chinese_words)){
sensitive_chinese_words$chinese_char[i] <- gsub("[^\\p{Han}]", "", sensitive_chinese_words$keyword[i], perl = T)
}
sensitive_chinese_words <- sensitive_chinese_words[sensitive_chinese_words$keyword == sensitive_chinese_words$chinese_char, ]
sensitive_chinese_words <- unique(sensitive_chinese_words)
sensitive_chinese_words <- setdiff(sensitive_chinese_words, "")

sensitive_chinese_words <- sensitive_chinese_words$keyword

chinese_chars <- unlist(strsplit(gsub("[^\\p{Han}]", "", sensitive_chinese_words, perl = T), ""))

dic <- read_csv('scripts/chinese_dic.csv')
skip <- c(setdiff(chinese_chars, dic$word))

for(i in skip){
  sensitive_chinese_words <- sensitive_chinese_words[!grepl(i, sensitive_chinese_words)] 
}

write_csv(data.frame(sensitive_chinese_words), 'scripts/sensitive_terms_prc.csv')
