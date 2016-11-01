
#all: eda report regression
rmds = $(wildcard report/sections/*.Rmd)
imgs = $(wildcard images/Coefficients_*.png)
res_data = data/results.Rdata
outrmd = report/report.Rmd

data:
	curl -o data/Credit.csv http://www-bcf.usc.edu/~gareth/ISL/Credit.csv

clean:
	rm -f report/report.pdf
tests:
	Rscript code/test-that.R

report: $(rmds) $(imgs) $(res_data)
	cat $(rmds) > $(outrmd) && Rscript -e "library(rmarkdown); render('report/report.Rmd', 'pdf_document')"





#report: report/report.Rmd regression
	#Rscript -e "rmarkdown::render('report/report.Rmd')"

#regression: code/scripts/regression-script.R data/Advertising.csv
	#Rscript code/scripts/regression-script.R

#eda: code/scripts/eda-script.R data/Advertising.csv
	#Rscript code/scripts/session-info-script.R
	#Rscript code/scripts/eda-script.R