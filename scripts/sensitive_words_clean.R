# Process list of sensitive terms

library(readr)
terms <- read_csv("https://raw.githubusercontent.com/jasonqng/chinese-keywords/master/csv/all.csv")

sensitive_chinese_words <- terms[, 1]
sensitive_chinese_words$chinese_char <- NA
for(i in 1:nrow(sensitive_chinese_words)){
sensitive_chinese_words$chinese_char[i] <- gsub("[^\\p{Han}]", "", sensitive_chinese_words$keyword[i], perl = T)
}
sensitive_chinese_words <- sensitive_chinese_words[sensitive_chinese_words$keyword == sensitive_chinese_words$chinese_char, ]
sensitive_chinese_words <- unique(sensitive_chinese_words)
sensitive_chinese_words <- setdiff(sensitive_chinese_words, "")

write_csv(data.frame(sensitive_chinese_words$keyword), 'sensitive_terms_prc.csv')
