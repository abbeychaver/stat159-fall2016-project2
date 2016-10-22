data <- read.csv("data/Credit.csv", header=TRUE, row.names = 1)
library(pander)
library(ggplot2)

# Quantitative Variables

descr_stats <- function(col, name) {
  names <- c("Minimum", "Maximum", "Range", "Median", "First Quartile","Third Quartile",
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
  vals <- c(minimum, maximum, range, median, first_q, third_q,
            IQR, mean, sd)
  sink(paste("data/Summary_", name, ".txt", sep=""))
  pander(data.frame(names, vals))
  sink()
  path = paste("images/Histogram_", name, ".png", sep="")
  png(filename = path)
  hist(col, main = paste("Histogram for ", name))
  dev.off()
  path = paste("images/Boxplot_", name, ".png", sep="")
  png(filename=path)
  boxplot(col, main = paste("Boxplot for ", name))
  dev.off()
}

for (i in 1:6) {
  col <- data[, i]
  name <- colnames(data)[i]
  descr_stats(col, name)
}


# Qualitative Variables

qual_descr <- function(col, name) {
  sink(paste("data/Summary_", name, ".txt", sep=""))
  pander(table(col))
  pander(table(col)/nrow(data))
  sink()
  path = paste("images/Barplot_", name, ".png", sep="")
  png(filename=path)
  barplot(table(col), col="light blue", border = "white", main = paste("Frequency for", name))
}

for (i in 7:10) {
  col <- data[, i]
  name <- colnames(data)[i]
  qual_descr(col, name)
}

# Scatterplot matrix
quant_data <- data[, c(1:6, 11)]
png(filename = "images/correlation_scatterplot.png")
plot(quant_data)
dev.off()
sink("data/correlations.txt")
pander(cor(quant_data))
sink()

data$Gender <- factor(data$Gender)
data$Student <- factor(data$Student)
data$Married <- factor(data$Married)
data$Ethnicity <- factor(data$Ethnicity)

# ANOVA between balance and qualitative statistics
sink("data/anova.txt")
fit <- aov(data$Balance ~ data$Gender+data$Student+data$Married+data$Ethnicity)
fit
summary(fit)
sink()

#conditional boxplots between Balance and the qualitative variables, that is, 
#boxplots of Balance conditioned to each of Gender, Ethnicity, Student, and Married.
library(fields)
png
bplot.xy(data$Gender, data$Balance)


new_data <- model.matrix(Balance ~ ., data=data)
new_data <- cbind(new_data[ ,-1], Balance = data$Balance)
scaled_data <- scale(new_data, center = TRUE, scale = TRUE)
write.csv(scaled_data, file = "data/scaled-credit.csv")

set.seed(1234)
floor = 300
scaled_data <- scaled_data[sample(400),]
training_data <- scaled_data[1:300, ]
write.csv(training_data, file = "data/training-credit.csv")
test_data <- scaled_data[301:400, ]
write.csv(test_data, file = "data/test-credit.csv")


