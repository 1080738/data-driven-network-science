# data-driven-network-science
Repo containing data and code for the Data-Driven Network Science summative (April 2024)

The repository contains all files and code used for the summative paper. 
- The "summative_code" folder contains two files: 
    - 'unhcr_cleaning_data.R' contains the R code used to clean the raw UNHCR data ('unhcr_unimputed.csv')
    - 'unhcr_imputing_data.ipynb' contains Python code for imputing the output of 'unhcr_cleaning_data.R' ('unhcr_unimputed.csv')
    - '1080738_DDNS_code.ipynb' contains Python code for the whole paper, notably my implementations of the distance metrics. 
- The "summative_data" folder contains 4 files: 
    - 'population.csv': raw refugee data file downloaded from UNHCR website
    - 'unhcr_unimputed.csv': cleaned but unimputed UNHCR data (output from 'unhcr_cleaning_data.R')
    - 'dat_imputed.csv': cleaned + imputed UNHCR data (output from 'unhcr_imputing_data.ipynb')
    - 'TEK-2021.csv': raw data for ethnic kin network, from the TEK website.
