library(pls)
scaled_data <- read.csv("data/datasets/scaled-credit.csv")[, -1]
training_data <- read.csv("data/datasets/training-credit.csv")[, -1]
test_data <- read.csv("data/datasets/test-credit.csv")[, -1]

set.seed(1234)
test_x = model.matrix(Balance ~ ., test_data)[,-1]
test_y = test_data$Balance

# Perform ten-fold cross validation on the training data
pls_fit = plsr(Balance ~ ., data=training_data,scale=TRUE, validation="CV")

# Find the number of components that yields the lowest MSEP
pls_comp = which.min(pls_fit$validation$PRESS)

# Save validation plot to png file
png(filename="images/plsr_validationplot.png")
validationplot(pls_fit, val.type="MSEP")
dev.off()

# Find the test mse
pls_pred = predict(pls_fit, test_x, ncomp=pls_comp)
pls_mse = mean((pls_pred-test_y)^2)

# Find the coefficients for the best value of the number of components
pls_out = plsr(Balance ~ ., data=scaled_data ,scale=TRUE,ncomp=pls_comp)
pls_coeff = pls_out$coefficients[, , pls_comp]

# Save output objects to RData file
save(pls_fit, pls_comp, pls_mse, pls_coeff, file="data/plsr.RData")

# Write coefficients, best number of components, and mse to a text file
sink("data/plsr.txt")
pander(coeff)
writeLines("\nTest MSE:\n")
mse
writeLines("\nBest Number of Components:\n")
comp
sink()
