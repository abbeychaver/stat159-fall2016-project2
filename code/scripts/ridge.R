library(glmnet)
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
grid <- grid <- 10^(seq(10, -2, length = 100))
cv <- cv.glmnet(trainX, trainY, intercept = FALSE, standardize = FALSE, lambda = grid, alpha=0)
lambda = cv$lambda.min
coef(cv, s = "lambda.min")

png("images/Ridge_MSE.png")
plot(cv)
dev.off()

# Calcuate Test MSE
predictedY <- predict(cv, newx = testX, s = "lambda.min")
ssq <- sum((predictedY - testY)^2)
ridge_mse = ssq/nrow(testX)


# Calculate Final Coefficients
data <- read.csv("data/datasets/scaled_credit.csv")
dataX <- data[, 2:12]
dataX <- as.matrix(dataX)
dataY <- data[, 13]
dataY <- as.vector(dataY)
dataY <- as.numeric(unlist(dataY))
fcv <- glmnet(dataX, dataY, intercept = FALSE, standardize = FALSE, lambda = lambda, alpha=0)
ridge_coeff <- coef(fcv)
sink("data/Ridge.txt")
pander(as.matrix(coef(fcv)))
writeLines("\nTest MSE:\n")
ridge_mse
writeLines("\nBest Lambda:\n")
lambda
sink()

save.image(file = "data/Ridge.Rdata")
