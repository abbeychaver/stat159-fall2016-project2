library(glmnet)

scaled_data <- read.csv("data/scaled-credit.csv")[, -1]
training_data <- read.csv("data/training-credit.csv")[, -1]
test_data <- read.csv("data/test-credit.csv")[, -1]

set.seed(1234)
pls_fit = plsr(Balance ~ ., data=training_credit ,subset=train,scale=TRUE, validation="CV")