# Therapy Combination Distribution - Summary

## What Was Added

I've added code to the `Question1_Baseline_ctDNA_Prognosis.Rmd` file that will create a new table showing the **actual therapy combinations** (monotherapy vs combination therapy) received by patients.

## Table Structure

The new table will show:

| Therapy Class/Combination | Type | N Patients | N Patients (%) | N Lines |
|---------------------------|------|------------|----------------|---------|
| ADC                       | Monotherapy | X | X.X% | X |
| ICI                       | Monotherapy | X | X.X% | X |
| Chemo                     | Monotherapy | X | X.X% | X |
| ADC + ICI                 | Combination | X | X.X% | X |
| Other + ICI               | Combination | X | X.X% | X |
| ICI + Chemo              | Combination | X | X.X% | X |
| ...                       | ... | ... | ... | ... |

## Key Differences from Existing Table

### **Existing Table (Expanded Classes):**
- Shows individual therapy classes (ADC, ICI, Chemo, etc.)
- **Expands combinations** so "ADC + ICI" patients are counted in BOTH ADC and ICI rows
- Purpose: Shows how many patients received each therapy class (allowing overlap)

### **New Table (Actual Combinations):**
- Shows **actual therapy combinations** as received
- "ADC + ICI" appears as a single row (combination)
- "ADC" alone appears as a separate row (monotherapy)
- Purpose: Shows the distribution of mono vs combo therapy

## Example

If a patient received "ADC + ICI":
- **Existing table:** Counted in both "ADC" row AND "ICI" row
- **New table:** Counted only in "ADC + ICI" row (combination)

## Summary Table

The code also creates a summary table:

| Type | N Combinations | Total Patients | Total Lines |
|------|----------------|----------------|-------------|
| Monotherapy | X | X | X |
| Combination | X | X | X |

## How to Generate

1. **Knit the R Markdown file** (`Question1_Baseline_ctDNA_Prognosis.Rmd`)
2. The new table will appear **after** the existing "Palliative Systemic Therapy Classes" table
3. It will show the actual distribution of mono vs combination therapy

## Location in Code

The new code was added at **lines 675-700** in `Question1_Baseline_ctDNA_Prognosis.Rmd`, right after the existing therapy class table.

## Next Steps

1. **Knit the Rmd file** to see the actual numbers
2. **Review the table** to ensure it matches your expectations
3. **Add to manuscript** if you want to include this distribution






