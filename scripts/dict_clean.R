# This script facilitates the use of this word list of the 9933 characters as a dictionary:
# Source: https://lingua.mtsu.edu/chinese-computing/statistics/char/list.php?Which=MO

library(readr)
dic <- read_delim('source-data/mtsu_dic.txt', delim = '\t', col_names = F)
dic <- dic[, c(2, 5)]
colnames(dic) <- c('word', 'sound')
for(i in 1:nrow(dic)){
  dic$sound[i] <- strsplit(dic$sound[i], '/')[[1]][1]
}
write_csv(dic, 'scripts/chinese_dic.csv')
