#####################################################################
##    Title:  AASA Project Teachers Database 
##
##    Author: Jacob Kopanye
##
##    Date Created: 
##
##    Description:  blah blab blah!
##
######################################################################

# Start running script from here:

# ==============
# Load packages
# ==============

rm(list=ls())
library(tidyverse)
library(lubridate)
library(openxlsx)
library(magrittr)
library(dplyr)
library("readxl")
library(googledrive)
library(stringr)
library(ggplot2)

install.packages(c("tidyverse", "lubridate", "openxlsx", "magrittr", "dplyr","googledrive","stringr","ggplot2"))

# ============================
# Step 1: combining the 3 tabs
# ============================

# load the dataset from location
sdi <- "C:/Users/jacobl/Downloads/efal_interSen/July_August_EFAL.xlsx"
ds6 <- read_excel("C:/Users/jacobl/Downloads/Teacher_database_work/submitted_reports/phase_2_school.xlsx")

# load a support tab
sup1 <- read_excel(sdi, sheet = "Support")

# rename variables to desired naming convention leaving out space
colnames(sup1) <- tolower(colnames(sup1))
colnames(sup1) <- gsub(" ", "_", colnames(sup1))

# exclude blanks using service provider column
set_data <- subset(sup1, !service_provider %in% c(NA,""))

# subset 29 first variables of interest
up1 <- set_data[, c(1:29)]
up1$tab <- NA
up1$tab[up1$tab %in% c(NA,"")] <- "support"
up1$sace_no <- NA
up1 <- up1[, c(1:12,31,13:30)]

# standardise column names for support tab
rnm <- c("service_provider",                                                   
         "name_of_coach_project_manager",                                                   
         "date_of_visit",                                                                   
         "session_type",                                                                    
         "support_method",                                                                 
         "type_of_support",                                                                 
         "school_name",                                                                     
         "emis_number",                                                                     
         "business_unit",                                                                   
         "operational_unit",                                                                
         "participant_name",                                                                
         "unique_id",
         "sace_no",
         "designation",                                                                     
         "grade",                                                                           
         "subject",                                                                         
         "length_of_support",                                                               
         "length_of_support_in_decimal",                                                  
         "main_focus_of_support",                                                           
         "score_content_knowledge",                                                        
         "score_addresses_learner_errors",                                                 
         "score_provides_adequate_individual_practice",                                    
         "score_differentiated_instruction",                                               
         "score_time_mgmt",                                                                
         "score_classroom_routines",                                                       
         "overall_score",                                                                   
         "visit_rating",                                                                    
         "visit_result",                                                                    
         "visit_result_code_failed_visits_only",                                          
         "additional_comments_describe_any_other_selections_or_important_information",
         "tab")
names(up1) <- rnm

# load Workshop and Group Training tab
wsnt <- read_excel(sdi, sheet = "Workshop and Group Training")
# rename variables to desired naming convention leaving out space
colnames(wsnt) <- tolower(colnames(wsnt))
colnames(wsnt) <- gsub(" ", "_", colnames(wsnt))

# exclude blanks using service provider column
set_dat <- subset(wsnt, !service_provider %in% c(NA,""))
up2 <- set_dat[, c(1:20)]
up2$tab <- NA
up2$tab[up2$tab %in% c(NA,"")] <- "workshop and group training"

# insert additional variables that are in support tab but not in workshop and group training tab
up2$type_of_support <- NA 
up2$score_content_knowledge <- NA
up2$score_addresses_learner_errors <- NA
up2$score_provides_adequate_individual_practice <- NA
up2$score_differentiated_instruction <- NA
up2$score_time_mgmt <- NA
up2$score_classroom_routines <- NA
up2$overall_score <- NA
up2$visit_rating <- NA

# align columns to mimic column positioning in support tab
up2a <- up2[, c(1:5,22,6:17,23:30,18:21)]
up2a$sace_no <- NA
up2a <- up2a[, c(1:12,31,13:30)]

# standardise column names to align with support tab naming convention
names(up2a) <- names(up1)

# load unlisted participant tab
unl <- read_excel(sdi, sheet = "UNLISTED PARTICIPANTS")

# rename variables to desired naming convention leaving out space
colnames(unl) <- tolower(colnames(unl))
colnames(unl) <- gsub(" ", "_", colnames(unl))

# subset 29 first variables of interest
nl <- unl[ , c(1:11,17,22:41)]

# concatenate name and surname
nl$participant_name <- paste(nl$participant_first_name, nl$participant_surname, sep = " ")

# exclude blanks using service provider column
set_da <- subset(nl, !service_provider %in% c(NA,""))
set_da$tab <- NA
set_da$tab[set_da$tab %in% c(NA,"")] <- "UNLISTED"

# standardise column names to align with support tab naming convention and order
up3 <- set_da
upa <- up3[, c(1:6,10,9,11,13:34)]
names(upa)[names(upa) == "sace_number"] <- "sace_no"
upaa <- upa[, c(1:6,10:13,30,7:9,14:29,31)]
names(upaa) <- names(up1)

# combine the 3 refined tabs (support,workshops and group training and unlisted participants) into one
comb_dfa <- rbind(data.frame(up1), data.frame(up2a), data.frame(upaa))

# autofill empty id with sace number
comb_dfa$unique_id <- ifelse(comb_dfa$unique_id %in% c(NA,""), comb_dfa$sace_no, comb_dfa$unique_id)
my_data <- subset(comb_dfa, select = -sace_no)

# ==========================================
# Step 2: Data cleaning starts here (REMOVE)
# ==========================================

# -	Entries without a participant name or unique ID
sdt <- subset(comb_dfa, participant_name %in% c(NA,"") | unique_id %in% c(NA,""))

# -	Entries without a participant name and unique ID
sdtt <- subset(comb_dfa, participant_name %in% c(NA,"") & unique_id %in% c(NA,""))

# -	Entries without a date
sdt1 <- subset(comb_dfa, date_of_visit %in% c(NA,""))
sdta <- subset(comb_dfa, !date_of_visit %in% c(NA,"") & !participant_name %in% c(NA,"") | !unique_id %in% c(NA,""))

names(sdta)[names(sdta) == "emis_number"] <- "emis_no"
sdtaa <- left_join(sdta, ds6, by = "emis_no")
sdta1 <- subset(sdtaa , centre_name1 %in% c(NA,""))

# -	Entries that seem to take place in schools that are not AASA schools
sdtaa$school_name <- toupper(sdtaa$school_name)
sdtaa$centre_name1 <- toupper(sdtaa$centre_name1)
sdta2 <- subset(sdtaa , !centre_name1 %in% school_name)

# sp <- data.frame(Name = NA)
# names(sp) <- names(sdt)

# Combine the data frames with an empty row in between
# res <- rbind(data.frame(sdt),data.frame(sdta),data.frame(sdtt))

# ===========================================
# Step 3: Data cleaning starts here (Queries)
# ===========================================

# check the following:
blnk_scls <- subset(comb_dfa , school_name %in% c(NA,""))
blnk_grds <- subset(comb_dfa , grade %in% c(NA,""))
blnk_sbjts <- subset(comb_dfa , subject %in% c(NA,""))
grds_not_cope_sp <- subset(comb_dfa , !grade %in% c("Grade 3","Grade 4", "multigrade"))
lgc <- subset(comb_dfa , length_of_support %in% c(NA,"") & visit_result == "Successful")
q1 <-  subset(comb_dfa , length_of_support > 8)
mfs <- subset(comb_dfa , main_focus_of_support %in% c(NA,""))

# print out result in desired tabs, point to desired folder
print_report <- paste0("C:/Users/jacobl/Downloads/efal_interSen/july-aguWorkshop and Group Training_",Sys.Date(),".xlsx")
write.xlsx(wsnt,print_report,rowNames = FALSE)

wb <- createWorkbook()

sheet <- "original"
addWorksheet(wb, sheet)
writeData(wb, sheet, sdi, rowNames=F)

sheet <- "clean"
addWorksheet(wb, sheet)
writeData(wb, sheet, comb_dfa, rowNames = F)

sheet <- "quiery1"
addWorksheet(wb, sheet)
writeData(wb, sheet, sdt, rowNames = F)

sheet <- "quiery2"
addWorksheet(wb, sheet)
writeData(wb, sheet, sdtt, rowNames = F)

sheet <- "quiery3"
addWorksheet(wb, sheet)
writeData(wb, sheet, sdta1, rowNames = F)

sheet <- "quiery4"
addWorksheet(wb, sheet)
writeData(wb, sheet, sdta2, rowNames = F)

sheet <- "changes"
addWorksheet(wb, sheet)
writeData(wb, sheet, upaa, rowNames = F)

saveWorkbook(wb, print_report, overwrite = TRUE)


