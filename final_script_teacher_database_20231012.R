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

rm(list=ls())
library(tidyverse)
library(lubridate)
library(openxlsx)
library(magrittr)
library(dplyr)
library("readxl")
library(googledrive)
library(stringr)

install.packages(c("tidyverse", "lubridate", "openxlsx", 
                   "magrittr", "dplyr","googledrive","stringr",
                   "readxl","googledrive", "stringr"))

# # drive_auth()
# # d <- drive_find("https://drive.google.com/drive/u/0/folders/1-4MAU6E6UZFoftgQjVJKLPbArFVIFQjG")
# file_link <- "https://docs.google.com/spreadsheets/d/1tO3SZhqlj2oIxbxXdyusbg8fzI7lfdrZ/edit?usp=drive_link&ouid=103398402698180463396&rtpof=true&sd=true"
# 
# # Download the file
# data1 <- drive_download(as_id(file_link))
# shtz <- read_excel(data1, sheet = "Workshop and Group Training")





tdi_a <- "C:/Users/jacobl/Downloads/August_Maths Centre.xlsx"

rnm <- c("business_unit","operation","centre_name","emis_no","subject","name","id_no")
sup1 <- read_excel(tdi_a, sheet = "Support")
up1 <- sup1[, c(9,10,7,8,15,11,12)]
names(up1) <- rnm
up1$level <- NA
up1$level[up1$level %in% c(NA,"")] <- "foundation_phase_maths_aug_sup"


wsnt <- read_excel(tdi_a, sheet = "Workshop and Group Training")

wgt <- wsnt[ ,c(8,9,6,7,14,10,11)]
names(wgt) <- rnm
wgt$level <- NA
wgt$level[wgt$level %in% c(NA,"")] <- "foundation_phase_maths_aug_work_shp"


unl <- read_excel(tdi_a, sheet = "UNLISTED PARTICIPANTS")

nl <- unl[ , c(24,25,22,23,27,7,8,10)]
names(nl)[names(nl) == "Participant SURNAME"] <- "Participant_SURNAME"
names(nl)[names(nl) == "Participant FIRST NAME"] <- "Participant_FIRST_NAME"
nl$Participant_Name <- paste(nl$Participant_FIRST_NAME, nl$Participant_SURNAME, sep = " ")
nl <- nl[ , c(1,2,3,4,5,9,8)]
names(nl) <- rnm
nl$level <- NA
nl$level[nl$level %in% c(NA,"")] <- "foundation_phase_maths_aug_UNLISTED"


tdi_s <- "C:/Users/jacobl/Downloads/September_Maths Centre.xlsx"

ssup1 <- read_excel(tdi_s, sheet = "Support")
p1 <- ssup1[, c(9,10,7,8,15,11,12)]
names(p1) <- rnm
p1$level <- NA
p1$level[p1$level %in% c(NA,"")] <- "foundation_phase_maths_sept_sup"

swsnt <- read_excel(tdi_s, sheet = "Workshop and Group Training")

wgt1 <- swsnt[ ,c(8,9,6,7,14,10,11)]
names(wgt1) <- rnm
wgt1$level <- NA
wgt1$level[wgt1$level %in% c(NA,"")] <- "foundation_phase_maths_sept_work_shp"

sunl <- read_excel(tdi_s, sheet = "UNLISTED PARTICIPANTS")

nl1 <- sunl[ , c(24,25,22,23,27,7,8,10)]
names(nl1)[names(nl1) == "Participant SURNAME"] <- "Participant_SURNAME"
names(nl1)[names(nl1) == "Participant FIRST NAME"] <- "Participant_FIRST_NAME"
nl1$Participant_Name <- paste(nl1$Participant_FIRST_NAME, nl1$Participant_SURNAME, sep = " ")
nl1 <- nl1[ , c(1,2,3,4,5,9,8)]
names(nl1) <- rnm
nl1$level <- NA
nl1$level[nl1$level %in% c(NA,"")] <- "foundation_phase_maths_sept_UNLISTED"

tdi_e <- "C:/Users/jacobl/Downloads/July_September_Foundation Phase.xlsx"

esup1 <- read_excel(tdi_e, sheet = "Support")
esp1 <- esup1[, c(9,10,7,8,15,11,12)]
names(esp1) <- rnm
esp1$level <- NA
esp1$level[esp1$level %in% c(NA,"")] <- "foundation_phase_maths_jul_sept_sup"

ewsnt <- read_excel(tdi_e, sheet = "Workshop and Group Training")

wgt2 <- ewsnt[ ,c(8,9,6,7,14,10,11)]
names(wgt2) <- rnm
wgt2$level <- NA
wgt2$level[wgt2$level %in% c(NA,"")] <- "foundation_phase_maths_jul_sept_work_shp"

eunl <- read_excel(tdi_e, sheet = "UNLISTED PARTICIPANTS")

nl2 <- eunl[ , c(24,25,22,23,27,7,8,10)]
names(nl2)[names(nl2) == "Participant SURNAME"] <- "Participant_SURNAME"
names(nl2)[names(nl2) == "Participant FIRST NAME"] <- "Participant_FIRST_NAME"
nl2$Participant_Name <- paste(nl2$Participant_FIRST_NAME, nl2$Participant_SURNAME, sep = " ")
nl2 <- nl2[ , c(1,2,3,4,5,9,8)]
names(nl2) <- rnm
nl2$level <- NA
nl2$level[nl2$level %in% c(NA,"")] <- "foundation_phase_maths_jul_sept_UNLISTED"

df1 <- data.frame(up1)
df2 <- data.frame(wgt)
df3 <- data.frame(nl)

df4 <- data.frame(p1)
df5 <- data.frame(wgt1)
df6 <- data.frame(nl1)

df7 <- data.frame(esp1)
df8 <- data.frame(wgt2)
df9 <- data.frame(nl2)

combo_a <- rbind(df1, df2, df3, df4, df5, df6, df7, df8, df9) %>% arrange(id_no,level,centre_name)

subset_data <- subset(combo_a, business_unit %in% c(NA,"") & !id_no %in% c(NA,""))
subset_datb <- subset(combo_a, !business_unit %in% c(NA,"") & id_no %in% c(NA,""))
subset_datc <- subset(combo_a, !business_unit %in% c(NA,"") & id_no %in% c(NA,"") & name %in% c(NA,""))
subset_datd <- subset(combo_a, !business_unit %in% c(NA,"") & id_no %in% c(NA,"") & !name %in% c(NA,""))
subset_dath <- subset(combo_a, !business_unit %in% c(NA,"") & !id_no %in% c(NA,"") & !name %in% c(NA,""))

combo_df <- subset_dath[duplicated(subset_dath[,c("id_no")]),] %>% arrange(id_no,level,centre_name)
combo_df1 <- subset_dath[!duplicated(subset_dath[,c("id_no")]),] %>% arrange(id_no,level,centre_name)
combo_df11 <- subset_dath[!duplicated(subset_dath[,c("name","id_no")]),] %>% arrange(id_no,level,centre_name)
combo_df11 <- subset_dath[duplicated(subset_dath[,c("name")]),] %>% arrange(id_no,level,centre_name)

combo_dff <- combo_df %>%
  group_by(id_no) %>%
  summarize(count = n())

pattern <- "\\b[1-9]\\d{12}\\b"
sb <- subset_dath %>% mutate(ID = str_extract(subset_dath$id_no, pattern))
sb1 <- subset(sb, !business_unit %in% c(NA,"") & !ID %in% c(NA,"") & !name %in% c(NA,""))
com <- sb1[!duplicated(sb1[,c("ID")]),] %>% arrange(ID,level,centre_name)
com1 <- com %>% mutate(ddob = substr(com$ID, 1, 6))
com1$dob <- NA
com1$dob = as.Date(paste0("19", substr(com1$ddob, 1, 2), "-", substr(com1$ddob, 3, 4), "-", substr(com1$ddob, 5, 6)))                       
com11 <- subset(com1, !business_unit %in% c(NA,"") & !ID %in% c(NA,"") & !dob %in% c(NA,""))%>% arrange(dob)

com11$current_dat <- NA
com11$current_dat <- Sys.Date()
com11$cal_age <- NA
com11$cal_age <- as.numeric(com11$cal_age)
com11$cal_age <- as.numeric(difftime(com11$current_dat, com11$dob, units = "weeks")/52.143)
com11$cal_age<- round(com11$cal_age, 0)
com11 <- com11 %>% arrange(cal_age,level,centre_name)

com11 <- com11 %>% 
  mutate(age_grp = case_when(
    cal_age >= 0 & cal_age <= 19 ~ "0-19",
    cal_age > 19 & cal_age <= 29 ~ "20-29",
    cal_age > 29 & cal_age <= 39 ~ "30-39",
    cal_age > 39 & cal_age <= 49 ~ "40-49",
    cal_age > 49 & cal_age <= 55 ~ "50-55",
    cal_age >= 56 ~ "56+",
    TRUE ~ NA_character_
  ))

td <- "C:/Users/jacobl/Downloads/Teacher_database_work/24082023_AASA_Teacher_profile_data.xlsx"

sht0 <- read_excel(td, sheet = "Sheet1")  
fd_efl <- read_excel(td, sheet = "foundation_phase_EFAL")
fd_mths <- read_excel(td, sheet = "foundation_phase_maths")
im_efl <- read_excel(td, sheet = "Intermediate_phase_EFAL")  
im_mths <- read_excel(td, sheet = "Intermediate_phase_maths")  
sf_efl <- read_excel(td, sheet = "senior_phase_EFAL") 
sf_mths <- read_excel(td, sheet = "senior_phase_maths")
sf_ns <- read_excel(td, sheet = "senior_phase_natural_science")


bu <- "C:/Users/jacobl/Downloads/Word_school_performance_report/Data/wd/report_2023-10-04_wd.xlsx"
sht1 <- read_excel(bu, sheet = "N_original")
slt <- sht1[ , c(1,3,4,5,6,8)]
slt1 <- slt[ , c(4,6)]

# rename EMIS_Number to emis_no for selected datasets
names(sf_efl)[names(sf_efl) == "EMIS_Number"] <- "emis_no"
names(sf_mths)[names(sf_mths) == "EMIS_Number"] <- "emis_no"
names(sf_ns)[names(sf_ns) == "EMIS_Number"] <- "emis_no"

# add bu to ds without bu
nsf_elf <- left_join(sf_efl,slt1, by = "emis_no")
nsf_mths <- left_join(sf_mths,slt1, by = "emis_no")
nsf_ns <- left_join(sf_ns,slt1, by = "emis_no")

# rename datasets with common column headings for alignment
n_c_n <- c("business unit","operation","centre_name","emis_no","grades_taught","subject_taught",
           "first_name","sur_name","gender","age","id_no","sace_no","level")

# Select specific columns from each data frame
s_fd_efl <- fd_efl[ , c(8,9,5,6,20,21,13,14,18,19,4,16)]
s_fd_efl$level <- NA
s_fd_efl$level[s_fd_efl$level %in% c(NA,"")] <- "foundation_phase_efal"
names(s_fd_efl) <- n_c_n

s_fd_mths <- fd_mths[ , c(8,9,5,6,21,23,13,14,19,20,16,17)]
s_fd_mths$level <- NA
s_fd_mths$level[s_fd_mths$level %in% c(NA,"")] <- "foundation_phase_maths"
names(s_fd_mths) <- n_c_n

s_im_efl <- im_efl[ , c(8,9,5,6,21,22,14,15,19,20,10,17)]
s_im_efl$level <- NA
s_im_efl$level[s_im_efl$level %in% c(NA,"")] <- "intermediate_phase_efal"
names(s_im_efl) <- n_c_n

s_im_mths <- im_mths[ , c(8,9,5,6,22,23,13,14,19,20,16,17)]
s_im_mths$level <- NA
s_im_mths$level[s_im_mths$level %in% c(NA,"")] <- "intermediate_phase_maths"
names(s_im_mths) <- n_c_n

s_sf_efl <- nsf_elf[ , c(23,4,15,16,17,18,8,9,13,14,10,11)]
s_sf_efl$level <- NA
s_sf_efl$level[s_sf_efl$level %in% c(NA,"")] <- "senior_phase_efal"
names(s_sf_efl) <- n_c_n

s_sf_mths <- nsf_mths[ , c(23,4,15,16,17,18,8,9,13,14,10,11)]
s_sf_mths$level <- NA
s_sf_mths$level[s_sf_mths$level %in% c(NA,"")] <- "senior_phase_maths"
names(s_sf_mths) <- n_c_n

s_sf_ns <- nsf_ns[ , c(23,4,15,16,17,18,8,9,13,14,10,11)]
s_sf_ns$level <- NA
s_sf_ns$level[s_sf_ns$level %in% c(NA,"")] <- "senior_phase_natural_sci"
names(s_sf_ns) <- n_c_n

df1 <- data.frame(s_fd_efl)
df2 <- data.frame(s_fd_mths)
df3 <- data.frame(s_im_efl)
df4 <- data.frame(s_im_mths)
df5 <- data.frame(s_sf_efl)
df6 <- data.frame(s_sf_mths)
df7 <- data.frame(s_sf_ns)

comb_dfa <- rbind(df1, df2, df3, df4, df5, df6, df7) %>% arrange(level,centre_name)
comb_dfaa <- comb_dfa[ ,c(3,4,7,8,11)]
comb_df <- rbind(df1, df2, df3, df4, df5, df6, df7) %>% arrange(level,centre_name)
comb_df <- data.frame(comb_df) %>% filter(!is.na(comb_df$id_no))
comb_df3 <- comb_df[duplicated(comb_df[,c("id_no")]),] %>% arrange(level,centre_name,id_no)
comb_df <- comb_df %>% mutate(dddob = substr(comb_df$id_no, 1, 6))
patn <- "\\b[1-9]\\d{12}\\b"
comb_dfff  <- comb_df %>% mutate(IID = str_extract(comb_df$id_no, patn))
comb_dfff4 <- subset(comb_dfff, !IID %in% c(NA,""))
comb_dfff5 <- subset(comb_dfff, IID %in% c(NA,""))
names(comb_dfff4 )[names(comb_dfff4 ) == "dddob"] <- "id_no"


# Load clean dataset removed id's that are wrong and missing id's
# cds <- read_excel("C:/Users/jacobl/Downloads/Teacher_database_work/clean_cds2023-10-08.xlsx")
# comb_dfo <- cds
comb_dfff4 <- data.frame(comb_dfff4) %>% filter(!is.na(comb_dfff4$id_no))
comb_df <- comb_dfff4
# comb_dfid_no <- comb_df[comb_df$id_no %>% grepl("^\\d+$"), ]
comb_df$id_no <- as.Date(paste0("19", substr(comb_df$id_no, 1, 2), "-", substr(comb_df$id_no, 3, 4), "-", substr(comb_df$id_no, 5, 6)))
comb_df <- comb_df %>% filter(!is.na(id_no))
comb_df$current_date <- NA
comb_df$current_date <- Sys.Date()
comb_df$cal_ages <- NA
comb_df$cal_ages <- as.numeric(comb_df$cal_ages)
comb_df$cal_ages <- as.numeric(difftime(comb_df$current_date, comb_df$id_no, units = "weeks")/52.143)
comb_df$cal_ages<- round(comb_df$cal_ages, 0)
comb_df <- comb_df %>% arrange(cal_ages,level,centre_name)

comb_df <- comb_df %>% 
  mutate(age_group = case_when(
    cal_ages >= 0 & cal_ages <= 19 ~ "0-19",
    cal_ages > 19 & cal_ages <= 29 ~ "20-29",
    cal_ages > 29 & cal_ages <= 39 ~ "30-39",
    cal_ages > 39 & cal_ages <= 49 ~ "40-49",
    cal_ages > 49 & cal_ages <= 55 ~ "50-55",
    cal_ages >= 56 ~ "56+",
    TRUE ~ NA_character_
  ))

names(comb_df)[names(comb_df) == "id_no"] <- "dob"

fds <- left_join(comb_df,comb_dfaa, by = c("first_name","sur_name","emis_no"))
comb_df0 <- fds[duplicated(fds[,c("dob")]),]
comb_df1 <- fds[!duplicated(fds[,c("dob")]),]
comb_df11 <- comb_df[duplicated(comb_df[,c("dob")]),]
comb_df1 <- comb_df1[, c(1,2,3,17,4,5,6,7,8,9,11,18,10,16,14,15,12,13)]
comb_d2 <- comb_df1[, c(1,2,3,5,6,7,8,9,10,11,12,14,16,17,18)]


num <- c("business_unit","operation","centre_name","name","id","cal_age", "age_group")
comb_d4 <- comb_d2[ , c(1,2,3,7,11,13,12)]
names(comb_d4) <- num
com11b <- com11[, c(1,2,3,6,9,13,14)]
names(com11b) <- num

df11 <- data.frame(comb_d4)
df22 <- data.frame(com11b)
co <- rbind(df11, df22)%>% arrange(cal_age,name,id,centre_name)
co1 <- co[duplicated(co[,c("id")]),]%>% arrange(cal_age,id,name,centre_name)
co2 <- co[!duplicated(co[,c("id")]),]%>% arrange(cal_age,id,name,centre_name)

co_dff <- co2 %>%
  group_by(age_group) %>%
  summarize(count = n())

ggplot(co_dff, aes(x = age_group, y = count)) +
   geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Teacher Age Distribution.", x = "age_group", y = "number of teachers") +  
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(title = "Teacher Age Distribution.", x = "age_group", y = "number of teachers") +
  geom_text(aes(label = count), vjust = -0.5) +
  theme(text = element_text(face = "bold"),
        axis.text.x = element_text(face = "bold"),  # Make x-axis values bold
        axis.text.y = element_text(face = "bold")) +
  theme_minimal() +  # Use a minimal theme
  theme(
    plot.background = element_rect(fill = "white"),
    panel.grid.major = element_line(color = "white"),  # Remove major grid lines
    panel.grid.minor = element_line(color = "white")   # Remove minor grid lines
  ) +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(face = "bold"),  # Make x-axis values bold
        axis.text.y = element_text(face = "bold"))

  # theme(axis.text.x = element_text(face = "bold"),  # Make x-axis values bold
  #       axis.text.y = element_text(face = "bold")) +
  # ggtitle("Teacher Age distribution") +
  # geom_text(aes(label = count), vjust = -0.5) +
  # theme_minimal() +  # Use a minimal theme
  # theme(
  #   plot.background = element_rect(fill = "white"),  # Set the background to white
  #   panel.grid.major = element_blank(),  # Remove major grid lines
  #   panel.grid.minor = element_blank()   # Remove minor grid lines
  # )
# # Add values to the bars
# p + geom_text(aes(label = Value), vjust = -0.5) +
#   scale_y_continuous(limits = c(0, 40), breaks = seq(0, 40, by = 5))
# library(grid)


#   theme(axis.title.x = element_text(hjust = 0.5) +
#   geom_text(aes(label = business.unit), vjust = -0.5))


# empty_comb <- comb_df %>% filter(business.unit %in% c(NA,""))
# comb_df1 <- comb_df[!duplicated(comb_df[,c("id_no")]),]
# comb_df3 <- comb_df[duplicated(comb_df[,c("id_no")]),] %>% arrange(level,centre_name,id_no)
# comb_df$id_no <- as.numeric(comb_df$id_no)
# comb_df$sace_no <- as.numeric(comb_df$sace_no)
# table(duplicated(comb_df$id_no))
# 
# # # Assuming you have a vector with dates represented as 2-digit year, month, and day
# dat0 <- comb_df[ , c(11)] 
# dat1 <- comb_df[ , c(11)]
#  date_objects <- as.Date(paste0("19", substr(dat1, 1, 2), "-", substr(dat1, 3, 4), "-", substr(dat1, 5, 6)))

# 
# # Convert the dates to Date objects, assuming the format is YYMMDD
# date_objects <- as.Date(paste0("19", substr(dates, 1, 2), "-", substr(dates, 3, 4), "-", substr(dates, 5, 6)))
# dates_as_date <- as.Date(paste0("20", substr(dates, 1, 2), "-", substr(dates, 3, 4), "-", substr(dates, 5, 6))) 
# # Calculate the current age
# current_date <- Sys.Date()
# cal_ages <- as.numeric(difftime(current_date, date_objects, units = "years"))
# 
# # Print the ages
# print(ages)
# Create a bar chart
# ggplot(data, aes(x = Category, y = Value)) +
#   geom_bar(stat = "identity", fill = "skyblue") +
#   labs(title = "Simple Bar Chart", x = "Categories", y = "Values")


print_out <- paste0("C:/Users/jacobl/Downloads/Teacher_database_work/better_td1_",Sys.Date(),".xlsx")
write.xlsx(co2,print_out,rowNames = FALSE)


