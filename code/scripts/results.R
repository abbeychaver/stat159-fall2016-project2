load("../../data/Ridge.Rdata")
load("../../data/lasso.Rdata")
load("../../data/pcr.Rdata")
load("../../data/plsr.Rdata")

ridge_mse = mse
pcr_mse = test_mses[12]

lasso_mse
pls_mse

ridge_coeff = coef(fcv)[2:12,]
pcr_coeff = best_coefs

pls_coeff

vars = names(pls_coeff)
coeff_mat = matrix(c(unname(ridge_coeff), unname(lasso_coeff), unname(pcr_coeff), unname(pls_coeff)), ncol=11)
colnames(coeff_mat) = vars
rownames(coeff_mat) = c("Ridge", "Lasso", "PCR", "PLSR")
coeff_table = as.table(coeff_mat)

