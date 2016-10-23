source("code/functions/data_functions.R")
data <- read.csv("data/datasets/Credit.csv", header=TRUE, row.names = 1)
library(pander)
library(fields)

# Quantitative Variables
for (i in c(1:6, 11)) {
  col <- data[, i]
  name <- colnames(data)[i]
  descr_stats(col, name)
}

# Qualitative Variables
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


set.seed(1234)
scaled_data <- scaled_data[sample(400),]
training_data <- scaled_data[1:300, ]
write.csv(training_data, file = "data/training-credit.csv")
test_data <- scaled_data[301:400, ]
write.csv(test_data, file = "data/test-credit.csv")