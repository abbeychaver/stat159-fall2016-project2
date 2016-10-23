library(glmnet)
scaled_data <- read.csv("data/scaled-credit.csv")[, -1]
training_data <- read.csv("data/training-credit.csv")[, -1]
test_data <- read.csv("data/test-credit.csv")[, -1]

set.seed (1234)
scaled_x = model.matrix(Balance ~ ., scaled_data)[,-1]
scaled_y = scaled_data$Balance
test_x = model.matrix(Balance ~ ., test_data)[,-1]
test_y = test_data$Balance
train_x = model.matrix(Balance ~ ., training_data)[,-1]
train_y = training_data$Balance
grid = 10^seq(10,-2,length=100)

lasso_mod = glmnet(train_x, train_y, alpha=1, lambda=grid)
cv_out = cv.glmnet(train_x, train_y, alpha=1, intercept=FALSE, standardize=FALSE, lambda=grid)

# Best lambda value
best_lambda = cv_out$lambda.min

# Save plot for cross-validation errors in terms of the tuning parameter (lambda)
png(filename="images/Lasso_MSE.png", width = 800, height = 600)
plot(cv_out)
dev.off()

# Calculate test values given the best lambda
lasso_pred = predict(lasso_mod, s = best_lambda, newx=test_x)

# Mean squared error for the test values
test_mse = mean((lasso_pred-test_y)^2)

# Refit the lasso model on the whole data set
lasso_out = glmnet(scaled_x, scaled_y, alpha=1, lambda=grid)

# Determine the coefficients given the best value of lambda
lasso_coef = predict(lasso_out,type="coefficients",s=best_lambda)[1:12,]

# Save cross validation output, best lambda, mse, and coefficients to RData file
save(cv_out, best_lambda, test_mse, lasso_coef, file="data/lasso.RData")

# Write coefficients, best lambda, and mse to a text file
sink("data/Lasso.txt")
lasso_coef
"TestMSE:"
test_mse
"Best Lambda:"
best_lambda
sink()

