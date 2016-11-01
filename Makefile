
# Variables 
rmds = $(wildcard report/sections/*.Rmd)
imgs = $(wildcard images/Coefficients_*.png)
res_data = data/results.Rdata
outrmd = report/report.Rmd
eda = code/scripts/eda.R
credit = data/datasets/Credit.csv
funcs = code/functions/data_functions.R
session = code/scripts/session_info.R

# Datasets
scaled = data/datasets/scaled_credit.csv
train = data/datasets/training_credit.csv
test = data/datasets/test_credit.csv

# Regression Models
ols = code/scripts/ols.R
ridge = code/scripts/ridge.R
lasso = code/scripts/lasso.R
pcr = code/scripts/pcr.R
plsr = code/scripts/plsr.R

all: eda regressions report

data:
	curl -o $(credit) http://www-bcf.usc.edu/~gareth/ISL/Credit.csv

eda: $(credit) $(funcs)
	Rscript $(eda)

ols: $(scaled)
	Rscript $(ols) 

ridge: $(scaled) $(train) $(test)
	Rscript $(ridge)

lasso: $(scaled) $(train) $(test)
	Rscript $(lasso)

pcr: $(scaled) $(train) $(test)
	Rscript $(pcr)

plsr: $(scaled) $(train) $(test)
	Rscript $(plsr)

regressions: $(scaled) $(train) $(test)
	make ols && make ridge && make lasso && make pcr && make plsr

report: $(rmds) $(imgs) $(res_data)
	cat $(rmds) > $(outrmd) && Rscript -e "library(rmarkdown); render('report/report.Rmd', 'pdf_document')"

session:
	Rscript $(session)

clean:
	rm -f report/report.pdf


#tests:
	#Rscript code/test-that.R

#report: report/report.Rmd regression
	#Rscript -e "rmarkdown::render('report/report.Rmd')"

#regression: code/scripts/regression-script.R data/Advertising.csv
	#Rscript code/scripts/regression-script.R

#eda: code/scripts/eda-script.R data/Advertising.csv
	#Rscript code/scripts/session-info-script.R
	#Rscript code/scripts/eda-script.R