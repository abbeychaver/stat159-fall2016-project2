load("../../data/Ridge.Rdata")
load("../../data/lasso.Rdata")
load("../../data/pcr.Rdata")
load("../../data/plsr.Rdata")
scaled_data <- read.csv("data/datasets/scaled-credit.csv")[, -1]

library(ggplot2)

ols = lm(Balance~Income+Limit+Rating+Cards+Age+Education+GenderFemale+StudentYes+MarriedYes+EthnicityAsian+EthnicityCaucasian, data=scaled_data)
ols_coeff = ols$coefficients[-1]
ols_mse = mean(ols$residuals^2)

ridge_mse = mse
pcr_mse = test_mses[12]

lasso_mse
pls_mse

ridge_coeff = coef(fcv)[2:12,]
pcr_coeff = best_coefs

options("scipen" = 100, "digits" = 1)
vars = names(pls_coeff)
coeff_mat = t(matrix(c(unname(ols_coeff), unname(ridge_coeff), unname(lasso_coeff), unname(pcr_coeff), unname(pls_coeff)), ncol=11))
rownames(coeff_mat) = vars
colnames(coeff_mat) = c("OLS", "Ridge", "Lasso", "PCR", "PLSR")
coeff_table = as.table(coeff_mat)


ggplot(as.data.frame(coeff_mat), aes(x=gender, y = Freq, fill=fraud)) + geom_bar(stat="identity")


coeff_plot = ggplot(as.data.frame(coeff_mat)) + geom_bar()
ggplot(unname(ridge_coeff), aes(x=)) + geom_bar()

a = as.data.frame(ridge_coeff)
b = factor(as.data.frame(coeff_mat)$OLS, labels=vars)
c = as.data.frame(coeff_mat)$OLS
plot(c ~ factor(vars))

coeff_df = data.frame(rep(vars, 5), c(unname(ols_coeff), unname(ridge_coeff), unname(lasso_coeff), unname(pcr_coeff), unname(pls_coeff)), c(rep("OLS", 11), rep("Ridge", 11), rep("Lasso", 11), rep("PCR", 11), rep("PLSR", 11)))
colnames(coeff_df) = c("vars", "coeff", "model")

# keep factors ordered
coeff_df$vars = factor(coeff_df$vars, levels=coeff_df$vars)
coeff_df$model = factor(coeff_df$model, levels=coeff_df$model)

ggplot(coeff_df, aes(vars, coeff)) + geom_bar(stat="identity") + facet_grid( ~ model)

melt(coeff_df)
