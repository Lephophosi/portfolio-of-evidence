#####################################################################
##    Title:  AASA Project Closeout Report  
##
##    Author: Jacob Kopanye
##
##    Date Created: 
##
##    Description:  Shell tables for Analysis Matrix
##
######################################################################


rm(list=ls())
library(tidyverse)
library(lubridate)
library(stringr)
library(openxlsx)
library(magrittr)
library(dplyr)
library("readxl")
library(openxlsx)
library(readr)
library(googledrive)
library(ggplot2)
library(janitor)

install.packages(c("tidyverse", "lubridate", "openxlsx", "magrittr", "dplyr","googledrive","stringr","ggplot2","janitor"))

# Set and verify the working directory
setwd("C:/Users/jacobl/Downloads/EFAL&MATHS")
current_directory <- getwd()
print(paste("The working directory is now set to:", current_directory))

# read support 
ful_sup <- read_excel("Maths_FullReport-Support.xlsx")

# read workshop
ful_wt <- read_excel("Maths_FullReport-Workshop.xlsx")

names(ful_sup) <- gsub(" ", "", names(ful_sup))
names(ful_wt) <- gsub(" ", "", names(ful_wt))

# select desired columns from support data and specify the date
msa <- ful_sup %>% select("NameOfCoach","DateOfVisit","SessionType",
                          "SupportMethod","SchoolName",
                          "BusinessUnit","OperationalUnit","Grade",
                          "Subject","TeacherFirstName","TeacherSurname","IDNumber","SACENumber",
                          "MainFocusOfSupport","Support\r\n(InHrs)",
                          "Support\r\n(InDecimal)","ScoreContentKnowledge","ScoreAddressesLearnerErrors","ScoreProvidesAdequateIndividualPractice",
                          "ScoreDifferentiatedInstruction","ScoreTimeManagement","ScoreClassroomRoutines","OverallScore","SupportRating",
                          "VisitResult","Phase","AdditionalComments") %>% 
  arrange(DateOfVisit,SchoolName) %>% 
  filter(DateOfVisit >= "2023-06-01" & DateOfVisit <= "2024-12-31")

# remane desired columns
names(msa)[names(msa) == "Support\r\n(InHrs)"] <- "LengthOfSupportInHours"
names(msa)[names(msa) == "Support\r\n(InDecimal)"] <- "LengthOfSupportInHoursInDecimal"

# add support column to indicate where records are derived
msa$tab <- NA
msa$tab[msa$tab %in% c(NA,"")] <- "support"

# select desired columns from workshop data and specify the date
mwa <- ful_wt %>% select("NameOfCoach","DateOfTraining","SessionType","SupportMethod",
                         "SchoolName","BusinessUnit","OperationalUnit","Grade","Subject",
                         "TeacherFirstName","TeacherSurname","IDNumber","SACENumber",
                         "TrainingTopicTermTheme","Training\r\n(InHrs)",
                         "Training\r\n(InDecimal)","VisitResultCode","VisitResult","Phase") %>% 
  arrange(DateOfTraining,SchoolName) %>% 
  filter(DateOfTraining >= "2023-06-01" & DateOfTraining <= "2024-12-31")

# Select desired columns and add columns
mwa$AdditionalComments <- NA
mwa$AdditionalComments <- as.character(mwa$AdditionalComments)
mwa$tab <- NA
mwa$tab[mwa$tab %in% c(NA,"")] <- "workshop"
names(mwa)[names(mwa) == "DateOfTraining"] <- "DateOfVisit"
names(mwa)[names(mwa) == "Training\r\n(InHrs)"] <- "LengthOfSupportInHours"
names(mwa)[names(mwa) == "Training\r\n(InDecimal)"] <- "LengthOfSupportInHoursInDecimal"
names(mwa)[names(mwa) == "TrainingTopicTermTheme"] <- "MainFocusOfSupport"
names(mwa)[names(mwa) == "VisitResultCode"] <- "SupportRating"

# add columns that are not in the workshop data to match those that are in support
mwa <- mwa %>% 
  mutate("ScoreContentKnowledge" = NA,
         "ScoreAddressesLearnerErrors" = NA,
         "ScoreProvidesAdequateIndividualPractice" = NA, 
         "ScoreDifferentiatedInstruction" = NA,
         "ScoreTimeManagement" = NA,
         "ScoreClassroomRoutines" = NA,
         "OverallScore" = NA)

# change var data type to character
mwa <- mwa %>% 
  mutate(across(c("ScoreContentKnowledge",
                  "ScoreAddressesLearnerErrors",
                  "ScoreProvidesAdequateIndividualPractice",
                  "ScoreDifferentiatedInstruction",
                  "ScoreTimeManagement",
                  "ScoreClassroomRoutines",
                  "OverallScore"), as.character))

# re-arrange columns to match support data format
mwa <- mwa[ ,c(1:16,22:28,17:21)]

# join support and workshop data into one dataset
al_dset <- rbind(data.frame(msa), data.frame(mwa))

# standardise the dataset to proper
clean_records <- function(df) {
  df <- df %>%
    mutate(across(where(is.character), ~str_to_title(str_trim(.))))
  return(df)
}

al_dset <- clean_records(al_dset)

# remove any duplicates
set_da2 <- al_dset[!duplicated(al_dset), ]

# add date year quarter columns
set_da2$Quarter <- NA
set_da2$Year <- NA
set_da2$Quarter <- quarter(set_da2$DateOfVisit, with_year = FALSE, fiscal_start = 1)
set_da2$Quarter <- paste0("Q", quarter(set_da2$DateOfVisit))
set_da2$Year <- year(set_da2$DateOfVisit)

# print out the dataset and give it a name
print_report <- paste0("Maths_Grades_report_01_Jun_2023_31_Dec_2024",Sys.Date(),".xlsx")
write.xlsx(set_da2,print_report,rowNames = FALSE)