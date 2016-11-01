library(pander)
scaled_data <- read.csv("data/datasets/scaled_credit.csv")[, -1]

# ordinary least squares regression
ols = lm(Balance~Income+Limit+Rating+Cards+Age+Education+GenderFemale+StudentYes+MarriedYes+EthnicityAsian+EthnicityCaucasian, data=scaled_data)
ols_coeff = ols$coefficients[-1]
ols_mse = mean(ols$residuals^2)

# Save coefficients and mse to txt file
sink("data/ols.txt")
pander(ols_coeff)
writeLines("\nTest MSE:\n")
ols_mse
sink()

# Save objects to rdata file
save(ols_coeff, ols_mse, file="data/ols.RData")
