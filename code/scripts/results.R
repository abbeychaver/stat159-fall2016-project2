load("../../data/Ridge.Rdata")
load("../../data/lasso.Rdata")
load("../../data/pcr.Rdata")
load("../../data/plsr.Rdata")
scaled_data <- read.csv("../../data/datasets/scaled-credit.csv")[, -1]

library(ggplot2)

# ordinary least squares regression
ols = lm(Balance~Income+Limit+Rating+Cards+Age+Education+GenderFemale+StudentYes+MarriedYes+EthnicityAsian+EthnicityCaucasian, data=scaled_data)
ols_coeff = ols$coefficients[-1]
ols_mse = mean(ols$residuals^2)

ridge_mse = mse
pcr_mse = test_mses[12]
ridge_coeff = coef(fcv)[2:12,]
pcr_coeff = best_coefs

# turn off scientific notation
options("scipen" = 100, "digits" = 2)

# create coefficient matrix for all the models
vars = names(pls_coeff)
coeff_mat = matrix(c(unname(ols_coeff), unname(ridge_coeff), unname(lasso_coeff), unname(pcr_coeff), unname(pls_coeff)), nrow=11)
rownames(coeff_mat) = vars
colnames(coeff_mat) = c("OLS", "Ridge", "Lasso", "PCR", "PLSR")

# Create table from the matrix
coeff_table = as.table(coeff_mat)

# Create data frame for the coefficients and models for plotting
coeff_df = data.frame(rep(vars, 5), c(unname(ols_coeff), unname(ridge_coeff), unname(lasso_coeff), unname(pcr_coeff), unname(pls_coeff)), c(rep("OLS", 11), rep("Ridge", 11), rep("Lasso", 11), rep("PCR", 11), rep("PLSR", 11)))
colnames(coeff_df) = c("vars", "coeff", "model")

# keep factors ordered
coeff_df$vars = factor(coeff_df$vars, levels=coeff_df$vars)
coeff_df$model = factor(coeff_df$model, levels=coeff_df$model)

# 5 plots separated by model
coeff_plot_separate = ggplot(coeff_df, aes(vars, coeff)) + geom_bar(stat="identity") + facet_wrap( ~ model) + xlab("Predictor") + ylab("Coefficient Value") + ggtitle("Comparison of Coefficient Values for Different Models") + theme(text = element_text(size=10),
                                                                                                                                                                                                                                       axis.text.x = element_text(angle=90, vjust=1)) 

# single multibar plot
coeff_plot = ggplot(coeff_df, aes(vars, coeff)) + geom_bar(aes(fill = model), position = "dodge", stat="identity") + xlab("Predictor") + ylab("Coefficient Value") + ggtitle("Comparison of Coefficient Values for Different Models") + theme(text = element_text(size=10),
                                                                                                                                                                                                                                              axis.text.x = element_text(angle=90, vjust=1)) 

# create matrix of mses for all the models
options("scipen" = 0, "digits" = 7)
mse_mat = t(matrix(c(ols_mse, ridge_mse, lasso_mse, pcr_mse, pls_mse)))
rownames(mse_mat) = c("MSE")
colnames(mse_mat) = c("OLS", "Ridge", "Lasso", "PCR", "PLSR")

# create table from mse matrix
mse_table = as.table(mse_mat)

# Save tables and plots to Rdata file
save(coeff_table, mse_table, file="../../data/results.Rdata")

# Save plots as png images
png(filename="../../images/Coefficients_Plot.png")
coeff_plot
dev.off()

png(filename="../../images/Coefficients_Plot_Separate.png")
coeff_plot_separate
dev.off()


