
## Code for pre-processing UNHCR refugee flow data for the DDNS summative paper

## preliminaries ---------------------------------------------------------------

## empty global env
rm(list = ls())

## installing packages
pacman::p_load (tidyverse, countrycode) 

## data cleaning ---------------------------------------------------------------

## download population.csv from github repo into working directory before running the below code.
## github repo: https://github.com/1080738/data-driven-network-science/tree/main

## getting data
refugees_raw = read_csv ("population.csv")

## cleaning data
refugees = refugees_raw %>%
  
  # removing unnecessary variables
  dplyr::select (-c('Country of origin',
                    'Country of asylum',
                    'IDPs of concern to UNHCR',
                    'Other people in need of international protection',
                    'Stateless persons',
                    'Host Community',
                    'Others of concern')) %>%
  
  # renaming cols
  rename (orig = `Country of origin (ISO)`,
          dest = `Country of asylum (ISO)`,
          year = Year) %>%
  
  # aggregating to obtain forced_mig feature
  mutate (forced_mig = `Refugees under UNHCR's mandate` + `Asylum-seekers`) %>%
  select (-c(`Refugees under UNHCR's mandate`, `Asylum-seekers`)) %>%
  
  # converting to numeric
  mutate (forced_mig = as.numeric(forced_mig)) %>%
  
  # removing NAs
  drop_na (forced_mig) %>%
  
  # adding dyad and triad identifiers
  unite ("orig_dest_year", c(orig, dest, year), sep = "_", remove = F, na.rm = F) %>%
  unite ("orig_dest", c(orig, dest), sep = "_", remove = F, na.rm = F) %>%
  
  # remove rows where orig and dest are the same
  filter (!(orig == dest)) %>%
  
  # filtering out PSE due to duplicate issues in the data
  filter (!orig == "PSE") %>%
  filter (!dest == "PSE")

## exporting -------------------------------------------------------------------

write.csv (refugees, "unhcr_unimputed.csv", row.names = F)







