library(rmarkdown)
library(pander)
library(ggplot2)
library(glmnet)
library(pls)
library(fields)

# Write the session info to output file
sink("session_info.txt")
sessionInfo()
sink()