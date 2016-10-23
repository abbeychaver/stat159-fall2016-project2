library(pls)
training <- read.csv("data/datasets/training-credit.csv")
trainX <- training[, 2:12]
trainX <- as.matrix(trainX)
trainY <- training[, 13]
trainY <- as.vector(trainY)
trainY <- as.numeric(unlist(trainY))
test <- read.csv("data/test-credit.csv")
testX <- test[, 2:12]
testX <- as.matrix(testX)
testY <- test[, 13]
testY <- as.vector(testY)

set.seed(1234)
pcr_model <- pcr(Balance ~ ., data=training, validation = "CV")

png("images/pcr_validationplot.png")
validationplot(pcr_model, val.type = "MSEP")
dev.off()

test_mses <- c(rep(0, 12))
for (i in 1:12) {
  pcr_pred <- predict(pcr_model, test, ncomp = i)
  test_mses[i] = mean((pcr_pred - testY)^2)
}
which.min(test_mses)

# Best Model is the model with all 12 components (on both training and test)
best_coefs <- pcr_model$coefficients[133:144]


data <- read.csv("data/scaled-credit.csv")
full_pcr_model <- pcr(Balance ~ ., data=data)
best_coefs <- full_pcr_model$coefficients[133:144]

sink("data/pcr.txt")
best_coefs
"testMSE:"
test_mses[12]


save.image(file = "data/pcr.Rdata")
