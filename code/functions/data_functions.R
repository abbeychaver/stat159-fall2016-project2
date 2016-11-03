library(pander)
library(fields)

# Quantitative Variables

descr_stats <- function(col, name) {
  Statistic <- c("Minimum", "Maximum", "Range", "Median", "First Quartile","Third Quartile",
             "Interquartile Range", "Mean", "Standard Deviation")
  minimum = min(col)
  maximum = max(col)
  range = maximum- minimum
  median = median(col)
  first_q = quantile(col, 0.25)
  third_q = quantile(col, 0.75)
  IQR <- IQR(col)
  mean <- mean(col)
  sd <- sd(col)
  Value <- c(minimum, maximum, range, median, first_q, third_q,
            IQR, mean, sd)
  summary <- data.frame(Statistic, Value)
  write.csv(summary, file = paste("data/summaries/Summary_", name, ".csv", sep=""))
  path = paste("images/Histogram_", name, ".png", sep="")
  png(filename = path)
  hist(col, main = paste("Histogram for ", name), col="light blue", border = "white",  xlab = name)
  dev.off()
  path = paste("images/Boxplot_", name, ".png", sep="")
  png(filename=path)
  boxplot(col, main = paste("Boxplot for ", name), col="light blue",  xlab = name)
  dev.off()
}

# Qualitative Variables

qual_descr <- function(col, name) {
  freq <- table(col)
  write.csv(freq, file = paste("data/summaries/Summary_", name, ".csv", sep=""))
  write.csv(freq/nrow(data), file = paste("data/summaries/Freq_Summary_", name, ".csv", sep=""))
  sink(paste("data/summaries/Summary_", name, ".txt", sep=""))
  pander(table(col))
  pander(table(col)/nrow(data))
  sink()
  path = paste("images/Barplot_", name, ".png", sep="")
  png(filename=path)
  barplot(table(col), col="light blue", border = "white", main = paste("Frequency for", name))
  dev.off()
  path = paste("images/Conditional_Boxplot_Balance_", name, ".png", sep="")
  png(filename=path)
  boxplot(data$Balance ~ col, col="lightblue", main=paste("Boxplot of Balance and", name))
  dev.off()
}