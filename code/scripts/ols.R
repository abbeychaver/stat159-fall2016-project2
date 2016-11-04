library(pander)
scaled_data <- read.csv("data/datasets/scaled_credit.csv")[, -1]
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

# ordinary least squares regression
ols = lm(Balance~Income+Limit+Rating+Cards+Age+Education+GenderFemale+StudentYes+MarriedYes+EthnicityAsian+EthnicityCaucasian, data=training)
ols_coeff = ols$coefficients[-1]

preds <- predict(ols, test)
ols_mse = mean((preds - testY)^2)

#fit on full data set
ols_final = lm(Balance~Income+Limit+Rating+Cards+Age+Education+GenderFemale+StudentYes+MarriedYes+EthnicityAsian+EthnicityCaucasian, data=scaled_data)
ols_coeff = ols_final$coefficients[-1]

# Save coefficients and mse to txt file
sink("data/ols.txt")
pander(ols_coeff)
writeLines("\nTest MSE:\n")
ols_mse
sink()

# Save objects to rdata file
save(ols_coeff, ols_mse, file="data/ols.RData")
