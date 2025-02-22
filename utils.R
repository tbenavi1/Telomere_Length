#!/usr/bin/env Rscript

# define R functions

# load libraries, if don't have - install
if(!require(tidyverse)){
  install.packages("tidyverse")
  library(tidyverse)
}

#### define function ####
chrs = c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10", "chr11", "chr12", "chr13", "chr14", "chr15", "chr16", "chr17", "chr18", "chr19", "chr20", "chr21", "chr22", "chrX", "chrY") #added May 25 2023
get_lengths <- function(coverage) {
  df1 <- data.frame(matrix(ncol = 3, nrow = 0))
  x <- c("length", "telomere", "genotype")
  colnames(df1) <- x
  incorrect<-vector()
i<-0
  for (chr in chrs){ #edited May 25 2023, use to be c(1:15)
    for (telo in c("L", "R")){
      i<-i+1
    data<-subset(pulse, pulse$chrom == chr)
    boundary<-telo_starts[telo_starts$TEL== paste0(chr, telo),]$telo_start
    
    if (telo=="L"){
    data$left<-boundary - data$start
    df<-subset(data, data$left > 0)
    df<-subset(df, df$left < 5000)
    df<-df[,7]
    colnames(df)<-"length"
    df$telomere<-rep(paste(chr, telo, sep=""), nrow(df))
    df$genotype<-rep("GENOTYPE", nrow(df))
    }
    
    if (telo=="R"){
    data$right<-data$end - boundary
    df<-subset(data, data$right > 0)
    df<-subset(df, df$right < 5000)
    df<-df[,7]
    colnames(df)<-"length"
    df$telomere<-rep(paste(chr, telo, sep=""), nrow(df))
    df$genotype<-rep("GENOTYPE", nrow(df))
    }
    df1 <- rbind(df, df1)
    }
  }
df1 <- df1 %>%
  group_by(telomere) %>%
  mutate(cov = n()) %>%
  filter(cov > coverage) %>%
  select(-c(cov))
return(df1)
}

