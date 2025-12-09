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
library(DT)
library(htmltools)

install.packages(c("tidyverse", "lubridate", "openxlsx", "magrittr", "dplyr", "googledrive", "stringr", "ggplot2", "janitor", "DT", "htmltools"))

df0 <- read_excel("2024_2023_improv.xlsx")
names(df0)[names(df0) == "Diff_2024_2023"] <- "rounded_perc_achieved"

df0 <- df0 %>% 
  mutate(pass_rate_perc = case_when(
    rounded_perc_achieved >= 21.6 ~ "Top 10%",
    rounded_perc_achieved >= 12.2 & rounded_perc_achieved <= 21.5 ~ "Top 20%",
    rounded_perc_achieved >= 9.9 & rounded_perc_achieved <= 12.1 ~ "Top 30%",
    rounded_perc_achieved >= 6.7 & rounded_perc_achieved <= 9.8 ~ "Top 40%",
    rounded_perc_achieved >= 6.6 & rounded_perc_achieved <= 6.6 ~ "Median",
    rounded_perc_achieved >= 4.3 & rounded_perc_achieved <= 6.5 ~ "Bottom 40%",
    rounded_perc_achieved >= -1.2 & rounded_perc_achieved <= 4.2 ~ "Bottom 30%",
    rounded_perc_achieved >= -3.4 & rounded_perc_achieved <= -1.3 ~ "Bottom 20%",
    rounded_perc_achieved <= -3.5 ~ "Bottom 10%",
    TRUE ~ NA_character_
  ))

# Second part of the indicator
dat <- df0[, c(1:14)]

wb <- createWorkbook()

# Add worksheet and write data
addWorksheet(wb, "2024_2023_improv_")
writeData(wb, "2024_2023_improv_", dat)

# Define styles for each condition
style_top10 <- createStyle(fgFill = "darkgreen", fontColour = "white")    # Red for Top 10%
style_top20 <- createStyle(fgFill = "limegreen", fontColour = "white")    # Orange for Top 20%
style_top30 <- createStyle(fgFill = "olivedrab", fontColour = "white")    # Yellow for Top 30%
style_top40 <- createStyle(fgFill = "darkolivegreen4", fontColour = "black")    # Light Green for Top 40%
style_median <- createStyle(fgFill = "snow", fontColour = "black")   # Light Blue for Median
style_bottom40 <- createStyle(fgFill = "lightyellow", fontColour = "black") # Green for Bottom 40%
style_bottom30 <- createStyle(fgFill = "mistyrose", fontColour = "black") # Purple for Bottom 30%
style_bottom20 <- createStyle(fgFill = "tomato", fontColour = "white") # Pink for Bottom 20%
style_bottom10 <- createStyle(fgFill = "darkred", fontColour = "white") # Black for Bottom 10%

# Apply conditional formatting
for (i in 1:nrow(dat)) {
  category <- dat$Position[i]
  row <- i + 1
  
  if (category == "Top 10%") {
    addStyle(wb, "2024_2023_improv_", style_top10, rows = row, cols = 14, gridExpand = TRUE)
  } else if (category == "Top 20%") {
    addStyle(wb, "2024_2023_improv_", style_top20, rows = row, cols = 14, gridExpand = TRUE)
  } else if (category == "Top 30%") {
    addStyle(wb, "2024_2023_improv_", style_top30, rows = row, cols = 14, gridExpand = TRUE)
  } else if (category == "Top 40%") {
    addStyle(wb, "2024_2023_improv_", style_top40, rows = row, cols = 14, gridExpand = TRUE)
  } else if (category == "Median") {
    addStyle(wb, "2024_2023_improv_", style_median, rows = row, cols = 14, gridExpand = TRUE)
  } else if (category == "Bottom 40%") {
    addStyle(wb, "2024_2023_improv_", style_bottom40, rows = row, cols = 14, gridExpand = TRUE)
  } else if (category == "Bottom 30%") {
    addStyle(wb, "2024_2023_improv_", style_bottom30, rows = row, cols = 14, gridExpand = TRUE)
  } else if (category == "Bottom 20%") {
    addStyle(wb, "2024_2023_improv_", style_bottom20, rows = row, cols = 14, gridExpand = TRUE)
  } else if (category == "Bottom 10%") {
    addStyle(wb, "2024_2023_improv_", style_bottom10, rows = row, cols = 14, gridExpand = TRUE)
  }
}

# Save the workbook
saveWorkbook(wb, "2024_Matric_Results_2024_2023_improv_positioning.xlsx", overwrite = TRUE)
cat("Excel file saved as '2024_Matric_Results_2024_2023_improv_positioning.xlsx'\n")