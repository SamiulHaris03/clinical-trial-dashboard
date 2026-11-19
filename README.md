# Clinical Trial Dashboard

An interactive R Shiny dashboard for exploring safety data from a clinical trial, built on example datasets in CDISC ADaM format. It summarises patient demographics, treatment-emergent adverse events and lab results by treatment arm, and includes a data quality checks tab.

## Data

The data comes from the [`pharmaverseadam`](https://pharmaverse.github.io/pharmaverseadam/) R package, which provides example ADaM datasets based on the CDISC pilot study. In this trial, patients received a placebo or xanomeline (low or high dose) as a skin patch.

| Dataset | Structure | Contents |
| --- | --- | --- |
| ADSL | One row per patient | Demographics, treatment arm, key dates |
| ADAE | One row per adverse event | Event name, severity, timing |
| ADLB | One row per patient, lab test and visit | Lab results and normal ranges |

All three datasets link through the unique subject ID, `USUBJID`.

## Features

- **Treatment arm filter:** one dropdown controls every tab
- **Demographics:** number of patients, mean age and percentage female per arm
- **Adverse events:** the 10 most common treatment-emergent adverse events
- **Lab results:** mean value over time for any lab test, one line per arm
- **Data checks:** a summary of quality checks and a table of missing values

## Data preparation decisions

- **Screen failures removed.** 52 patients were screened but never entered the trial, so they received no treatment and are excluded from all summaries, leaving 254 treated patients.
- **Treatment-emergent adverse events only.** Events that started before the first dose cannot have been caused by the drug, so only events flagged as treatment-emergent (`TRTEMFL == "Y"`) are included.
- **Actual treatment used.** Safety summaries use the treatment patients actually received (`TRT01A`) rather than the one planned (`TRT01P`).
- **Visits ordered numerically.** Lab results are plotted by the numeric visit variable (`AVISITN`), since text labels such as "Week 12" and "Week 2" do not sort correctly.

A key finding from this preparation: adverse events per patient rise with dose, from 3.3 on placebo to 4.4 on low dose and 5.8 on high dose. Raw event counts alone would have hidden this, because the arms have different numbers of patients.

## Data checks

| Check | Dataset | Result | Interpretation |
| --- | --- | --- | --- |
| Duplicate patient IDs | ADSL | 0 found | Each patient appears once, as expected |
| AE patients missing from ADSL | ADAE | 0 found | Every patient with an adverse event exists in the patient-level data |
| Lab values outside normal range | ADLB | 3,889 found | Clinically notable values for review, not data errors |

The missing values check also highlights the difference between expected and unexpected gaps. Death-related columns are missing for most patients simply because most patients did not die, and screen failure columns are empty because screen failures were removed. Two patients are missing a treatment end date, which in a real study would be raised as a query with the data management team.

## How to run

1. Install the required packages:

```r
install.packages(c("shiny", "bslib", "dplyr", "DT", "ggplot2", "pharmaverseadam"))
```

2. Open the project in RStudio, open `app.R` and click **Run App**, or run:

```r
shiny::runApp()
```

## Project structure

```
clinical-trial-dashboard/
├── app.R               # Shiny app: user interface and server
├── R/
│   ├── prepare_data.R  # data cleaning and summaries
│   └── qc_checks.R     # data quality check functions
├── explore.R           # initial data exploration
└── README.md
```

## Screenshots

<!-- Add screenshots to a screenshots/ folder and uncomment these lines -->
<!-- ![Demographics tab](screenshots/demographics.png) -->
<!-- ![Adverse events tab](screenshots/adverse_events.png) -->
<!-- ![Lab results tab](screenshots/lab_results.png) -->
<!-- ![Data checks tab](screenshots/data_checks.png) -->
