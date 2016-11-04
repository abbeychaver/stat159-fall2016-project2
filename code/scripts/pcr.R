library(pls)
library(pander)
training <- read.csv("data/datasets/training_credit.csv")
trainX <- training[, 2:12]
trainX <- as.matrix(trainX)
trainY <- training[, 13]
trainY <- as.vector(trainY)
trainY <- as.numeric(unlist(trainY))
test <- read.csv("data/datasets/test_credit.csv")
testX <- test[, 2:12]
testX <- as.matrix(testX)
testY <- test[, 13]
testY <- as.vector(testY)

set.seed(1234)
pcr_model <- pcr(Balance ~ ., data=training, validation = "CV")

png("images/pcr_validationplot.png")
validationplot(pcr_model, val.type = "MSEP")
dev.off()

pcr_comp = which.min(pcr_model$validation$PRESS)

# Best Model is the model with all 12 components (on both training and test)
pcr_pred = predict(pcr_model, test, ncomp=pcr_comp)
pcr_mse = mean((pcr_pred-testY)^2)


data <- read.csv("data/datasets/scaled_credit.csv")
full_pcr_model <- pcr(Balance ~ ., data=data)
best_coefs <- full_pcr_model$coefficients[, , 12][-1]

sink("data/pcr.txt")
pander(best_coefs)
writeLines("\nTest MSE:\n")
pcr_mse
sink()


save.image(file = "data/pcr.Rdata")
