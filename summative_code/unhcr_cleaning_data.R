
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

## obtaining expanded df with all possible combinations
all_combinations <- expand.grid (orig = unique (refugees$orig),
                                 dest = unique (refugees$dest),
                                 year = unique (refugees$year)) %>%
  
  # adding dyad and triad identifiers
  unite ("orig_dest_year", c(orig, dest, year), sep = "_", remove = F, na.rm = F) %>%
  unite ("orig_dest", c(orig, dest), sep = "_", remove = F, na.rm = F)

## merging the original dataframe with the expanded combinations
refugees_exp <- all_combinations %>% left_join (refugees, by = c("orig", "dest", "year", "orig_dest_year", "orig_dest"))

## replacing missing values with 0 for the refugee flows
#refugees_exp[is.na(refugees_exp)] <- 0

## filtering to only min 10 flows
refugees_exp_filt = refugees_exp %>%
  
  # grouping
  dplyr::group_by (orig_dest) %>%
  
  # filtering for min 10 flows
  filter (sum (!is.na(forced_mig)) >= 15) %>% ungroup () %>%
  
  # filtering out PSE due to duplicate issues in the data
  filter (!orig == "PSE") %>%
  filter (!dest == "PSE")

## exporting -------------------------------------------------------------------

write.csv (refugees_exp_filt, "unhcr_unimputed.csv", row.names = F)







