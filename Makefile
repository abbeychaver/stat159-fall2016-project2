
# Variables 
rmds = $(wildcard report/sections/*.Rmd)
imgs = $(wildcard images/Coefficients_*.png)
res_data = data/results.Rdata
outrmd = report/report.Rmd
eda = code/scripts/eda.R
funcs = code/functions/data_functions.R
session = code/scripts/session_info.R
info = session_info.txt

# Datasets
credit = data/datasets/Credit.csv
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

# Downloads credit dataset to data/datasets folder
data:
	curl -o $(credit) http://www-bcf.usc.edu/~gareth/ISL/Credit.csv

# Runs code/scripts/eda.R, which creates summaries and plots for the variables in the credit dataset
eda: $(credit) $(funcs)
	Rscript $(eda)

# Fits the ols regression model to the dataset
ols: $(scaled)
	Rscript $(ols) 

# Fits the ridge regression model to the dataset
ridge: $(scaled) $(train) $(test)
	Rscript $(ridge)

# Fits the lasso regression model to the dataset
lasso: $(scaled) $(train) $(test)
	Rscript $(lasso)

# Fits the pcr regression model to the dataset
pcr: $(scaled) $(train) $(test)
	Rscript $(pcr)

# Fits the plsr regression model to the dataset
plsr: $(scaled) $(train) $(test)
	Rscript $(plsr)

# Runs all five of the above regressions
regressions: $(scaled) $(train) $(test)
	make ols && make ridge && make lasso && make pcr && make plsr

# Creates the intermediate report/report.Rmd file
$(outrmd): $(rmds) $(imgs) $(res_data)
	cat $(rmds) > $@

# Creates the final report/report.pdf file
report: $(outrmd)
	make $(outrmd) && Rscript -e "library(rmarkdown); render('report/report.Rmd', 'pdf_document')"

# Creates txt file about the session info
session:
	#Rscript $(session) && git --version >> $(info) && echo \ >> $(info) && latex --version >> $(info) && echo \ >> $(info) && pandoc --version >> $(info)
	bash session.sh

# Generates slides in html format
slides: slides/presentation.Rmd
	Rscript -e "library(rmarkdown); render('slides/presentation.Rmd', 'html_document')"

# Deletes the generated report/report.rmd and report/report.pdf files
clean:
	rm -f report/report.pdf $(outrmd)


#tests:
	#Rscript code/test-that.R
