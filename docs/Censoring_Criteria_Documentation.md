# Censoring Criteria in ctDNA Analysis

## Definition of Censoring

In survival analysis, a patient is **censored** if they did not experience the event of interest (death) by the end of follow-up.

## Criteria Used in This Dataset

### Event (os_event = 1):
A patient is considered to have an **event** (death) if **ANY** of the following conditions are met:

1. **Explicit death date is available** (`death_date` column is not NA)
2. **Alive status is "No"** (`alive_yes_no` = "No" or similar)

### Censored (os_event = 0):
A patient is considered **censored** if:
- They do NOT have a death date, AND
- Their alive status is NOT "No" (i.e., "Yes", missing, or unknown)

## Time Calculation

- **Event time**: Death date (if available)
- **Censoring time**: Last follow-up date (`last_follow_up_date` or similar)
- **Survival time**: `max(last_fu_date, death_date) - anchor_date`

Where the anchor date is:
- For Question 1: `ctdna_diagnosis_date` (first ctDNA measurement)
- For other questions: varies by question (e.g., cystectomy date, radiation date)

## Data Sources

The code extracts information from:
1. **Death date columns**: `death_date`, `death.*date` (excluding cause/reason columns)
2. **Follow-up date columns**: `last.*follow.*up.*date`, `follow.*up.*date` (excluding death-related columns)
3. **Alive status columns**: `alive_yes_no`, `alive.*yes.*no`

## Example Logic (from Question 1):

```r
os_event = case_when(
  !is.na(death_date) ~ 1,        # Has death date = Event
  alive_status == "No" ~ 1,      # Alive status = No = Event
  TRUE ~ 0                        # Otherwise = Censored
)

os_time = as.numeric(pmax(last_fu_date, death_date, na.rm = TRUE) - ctdna_diagnosis_date)
```

## Notes

- If a patient has both a death date and a last follow-up date, the death date takes precedence (they are an event, not censored)
- Patients with missing follow-up information may be excluded from analysis
- The censoring is considered **non-informative** if censoring rates do not differ significantly between groups (tested via chi-square test)

