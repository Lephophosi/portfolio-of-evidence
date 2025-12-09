The assignment investigates school results in relation to multiple types of teacher support data (individual sessions, group support, and workshops), and to include teacher-level demographics such as age groups, this model thus the following:
1.	Combines teacher-level predictors (support exposure, age, subject taught, grade)
2.	Explains variation in school or learner performance outcomes
3.	Accounts for clustering of teachers within schools

Statistical Model uses Multilevel (Hierarchical) Regression Model
Justification: Because teachers are nested within schools — and performance outcomes are often measured at cohort or learner level — a multilevel model is best suited:
School Performance = f(Teacher Support + Teacher Demographics + School-Level Factors)
where teachers (Level 2) are nested within schools (Level 3).

Combine all data - individual support session records, group support session records and workshops training for all grades (grade R, Grade 4-7 both Mathematics and English as First Additional Language (EFAL))
The script pulls names of teachers who are supported by AASA Education programme. These teacher names are pulled from individual support session records, group support session records and workshops training
Code identifies teacher ID from the combined dataset and removes portential duplicates of teachers by ID
Generates age groups from the ID number and plots teacher age distribution from age group and number of teachers
