#step2 hgnc_family_type
#输入文件：hgnc的全表格
#输出文件：hgnc中基因与family和type的对应关系，两个表格Rdata
# ftp://ftp.ebi.ac.uk/pub/databases/genenames/new/tsv/hgnc_complete_set.txt
rm(list = ls())
if(!require(tidyverse))install.packages('tidyverse')
library(tidyverse)
hgnc <- read.csv("hgnc_complete_set.txt",sep = "\t")
dumd <- function(x){
  colname <- vector("character")
  count <- vector("integer")
  for(i in 1:ncol(x)){
    colname[i] = colnames(x)[[i]]
    count[i]=nrow(x[!duplicated(x[,i]),])
  }
  df <- tibble(colname,count) %>%
    arrange(desc(count))
  df
}
sum_hgnc <- dumd(hgnc) #大表格数据统计
hgnc_family <- hgnc[,c(13,20)]
hgnc_type <- hgnc[,c(4,20)]
dup2 <- function(x,m,n){
  x <- x[!duplicated(x[,c(m,n)]),]
}
empty.omit <- function(x){
  x[x==""] <- NA
  na.omit(x)
}
hgnc_family <- hgnc_family %>%
  unique.data.frame() %>%
  empty.omit()
hgnc_type <- hgnc_type %>%
  unique.data.frame() %>%
  empty.omit()

save(hgnc,hgnc_family,hgnc_type,file = "hgnc_family_type.Rdata")
