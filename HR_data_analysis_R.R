#           HELPFUL LINKS: 
#______________________________________
# R4DS https://r4ds.had.co.nz/

# Cox Proportional Hazards Model
# http://www.sthda.com/english/wiki/cox-proportional-hazards-model#r-function-to-compute-the-cox-model-coxph

# HR Analytics Live
# https://hranalytics.live/

# If you need to bin some age groups:
# See https://hranalyticslive.netlify.com/13-pay-gap.html   
# or
# https://rstudio-pubs-static.s3.amazonaws.com/222993_e1059369754f419a9360e7b0d431f3e1.html

# Statistical Tools
# http://www.sthda.com/english/

# Caret
# http://topepo.github.io/caret/index.html

library(tidyverse)
library(readr)
library(caret)
library(survival)


HR_data <- read_csv("HR_data.csv")
View(HR_data)


volTerm <- HR_data %>%
  filter(EmploymentStatus == "Voluntarily Terminated")

ggplot(data = volTerm, mapping = aes(x = TermReason, fill = TermReason)) +
  geom_bar() +
  coord_flip()
  
ggplot(data = volTerm, mapping = aes(x = Position, fill = Position)) +
  geom_bar() +
  coord_flip()

# Add Tenure, YOS, Age Bucket, and variables of your choosing depending on the data

df <- HR_data %>%
  filter(EmploymentStatus %in% c("Active", "Voluntarily Terminated")) %>%
  select(Sex, MaritalDesc, RaceDesc, Department, PayRate, ManagerName, 
         PerformanceScore, EngagementSurvey, EmploymentStatus) %>%
  rename(Marital_Status = MaritalDesc, Race = RaceDesc, Manager = ManagerName)
 



  