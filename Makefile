
#all: eda report regression

data:
	curl -o data/Credit.csv http://www-bcf.usc.edu/~gareth/ISL/Credit.csv

clean:
	rm report/report.pdf
tests:
	Rscript code/test-that.R


#report: report/report.Rmd regression
	#Rscript -e "rmarkdown::render('report/report.Rmd')"

#regression: code/scripts/regression-script.R data/Advertising.csv
	#Rscript code/scripts/regression-script.R

#eda: code/scripts/eda-script.R data/Advertising.csv
	#Rscript code/scripts/session-info-script.R
	#Rscript code/scripts/eda-script.R