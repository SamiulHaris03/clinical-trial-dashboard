# Load the following libraries 

library(dplyr)
library(pharmaverseadam)

# Remove screen failures --> never recieved treatment 
adsl_trt = adsl |> filter (TRT01A != 'Screen Failure')

# Keep only treatment emergenet adverse events 
adae_te = adae |> 
  filter(TRTEMFL == 'Y')


# Patients and events per treatment arm
patients_per_arm <- adsl_trt |>
  count(TRT01A, name = "n_patients")

events_per_arm <- adae_te |>
  count(TRT01A, name = "n_events")

# Combine and calculate events per patient
ae_rate <- patients_per_arm |>
  left_join(events_per_arm, by = 'TRT01A') |>
  mutate(events_per_patient = round(n_events / n_patients, 1))

ae_rate