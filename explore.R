# Install the following packages 

install.packages("pharmaverseadam") # contains example clinical trial data
install.packages("dplyr")
install.packages("ggplot2")
install.packages("shiny")
install.packages("plotly")
install.packages("DT")



library(pharmaverseadam)
library(dplyr)

# ?adsl run in console to understrand one of the datasets

glimpse(adsl) # one row per patient
glimpse(adae) # one row per adverse event
glimpse(adlb) # one row per lab result

count(adsl, TRT01A) # patients per treatment arm
n_distinct(adsl$USUBJID) # number of unique patients


df = adsl
head(df)
nrow(df) # 306 rows hence 306 unique patients
ncol(df)

n_distinct(adsl$USUBJID)

nrow(adae) # one row per adverse event 
n_distinct(adae$USUBJID)


adsl |>
  count(TRT01A)

adae |> count(AEDECOD) |> arrange(desc(n)) |> head(10)

adae |> count(TRT01A)
