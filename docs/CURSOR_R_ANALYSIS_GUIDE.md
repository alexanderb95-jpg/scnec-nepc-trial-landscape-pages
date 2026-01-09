# Using Cursor for R Data Analysis - Complete Guide

## Table of Contents
1. [Key Concepts](#key-concepts)
2. [Running R Code](#running-r-code)
3. [Working with R Markdown](#working-with-r-markdown)
4. [Terminal Integration](#terminal-integration)
5. [File Management & Navigation](#file-management--navigation)
6. [Debugging & Troubleshooting](#debugging--troubleshooting)
7. [Best Practices](#best-practices)
8. [Quick Reference](#quick-reference)

---

## Key Concepts

### How Cursor Works with R
Cursor is an **AI-powered code editor** (like VS Code). It doesn't replace RStudio, but offers:
- ✅ **AI assistance** for writing code
- ✅ **Integrated terminal** for running R interactively
- ✅ **R Markdown support** for reproducible reports
- ✅ **Git integration** for version control
- ✅ **File navigation** across large projects

**You'll still use R commands** - Cursor just helps you write and manage them better.

---

## Running R Code

### Method 1: Integrated Terminal (Most Common for R)

1. **Open Terminal in Cursor:**
   - Press `` Ctrl+` `` (backtick) or `` Cmd+` `` on Mac
   - Or: View → Terminal
   - Or: Terminal → New Terminal

2. **Start R Session:**
   ```bash
   R
   ```
   You'll see the R prompt: `>`

3. **Run R Commands:**
   ```r
   library(dplyr)
   data <- read_excel("your_file.xlsx")
   head(data)
   ```

4. **Exit R:**
   ```r
   q()  # Don't save workspace
   # or
   quit(save = "no")
   ```

### Method 2: Run Selected Code (AI Feature)

1. **Select code** in your `.R` or `.Rmd` file
2. **Right-click** → "Ask Cursor" or use `Cmd+L` (Mac) / `Ctrl+L` (Windows)
3. Ask: "Run this code" or "Execute this R code"

**Note:** This sends code to AI - it won't actually execute in your R session. Use for understanding, not running.

### Method 3: Source Entire R Script

In terminal:
```bash
Rscript your_script.R
```

Or in R console (in terminal):
```r
source("your_script.R")
```

---

## Working with R Markdown

### What is R Markdown?
R Markdown (`.Rmd`) files combine:
- **Markdown** (text formatting)
- **R code chunks** (executable code)
- **Output** (HTML, PDF, Word)

### Your Current Workflow (What You're Doing Now)

Looking at your files like `Question1_Baseline_ctDNA_Prognosis.Rmd`:

1. **You write R chunks:**
   ```r
   ```{r setup, include=FALSE}
   library(dplyr)
   data <- read_excel("file.xlsx")
   ```
   ```

2. **You knit to HTML:**
   - In terminal: `Rscript -e "rmarkdown::render('your_file.Rmd')"`
   - Or in R console: `rmarkdown::render("your_file.Rmd")`

### Better Workflow in Cursor

#### Option A: Knit Button (If R Extension Installed)

1. **Install R Extension:**
   - Press `Cmd+Shift+X` (extensions)
   - Search "R" by REditorSupport
   - Install it

2. **After installing:**
   - You'll see a "Knit" button above R chunks
   - Click to run individual chunks
   - Use chunk options to control execution

#### Option B: Terminal Knitting (Recommended for You)

Since you already use `rmarkdown::render()`, continue this way:

1. **Open terminal in Cursor** (`` Cmd+` ``)
2. **Navigate to your file:**
   ```bash
   cd ~/R  # or wherever your .Rmd file is
   ```
3. **Knit the document:**
   ```bash
   Rscript -e "rmarkdown::render('Question1_Baseline_ctDNA_Prognosis.Rmd')"
   ```

Or create a helper script `knit_file.R`:
```r
# knit_file.R
library(rmarkdown)
render("your_file.Rmd")
```

Then run: `Rscript knit_file.R`

#### Running Individual Chunks for Testing

Instead of knitting the whole document, you can:

1. **Copy chunk code** to R console:
   ```r
   # Copy this chunk:
   # ```{r test}
   # data <- read_excel("file.xlsx")
   # head(data)
   # ```
   
   # Paste into R console in terminal:
   data <- read_excel("file.xlsx")
   head(data)
   ```

2. **Source setup code first:**
   ```r
   source("ctDNA_Research_Questions_Shared_Setup.R")
   # Then run your chunk code
   ```

---

## Terminal Integration

### Setting Up Your R Environment

Create an `.Rprofile` file in your home directory or project root:

```r
# .Rprofile
# Auto-load common packages
.First <- function() {
  cat("\nWelcome to R in Cursor!\n")
  options(repos = c(CRAN = "https://cloud.r-project.org"))
}

# Auto-load libraries you always use
if (interactive()) {
  suppressPackageStartupMessages({
    library(dplyr)
    library(tidyr)
    library(readxl)
  })
}
```

### Multi-line Commands in Terminal

**Problem:** R console in terminal is hard for multi-line code

**Solution:** Write code in `.R` file, then source it:
```r
source("my_analysis.R")
```

Or use RStudio for interactive work, Cursor for writing/editing.

### R Terminal Tips

1. **Clear console:** `Ctrl+L` (in R console)
2. **History:** Use up/down arrows
3. **Cancel command:** `Ctrl+C`
4. **Auto-complete:** `Tab` key (if R console supports it)

---

## File Management & Navigation

### Opening Files Quickly

- **Quick Open:** `Cmd+P` (Mac) / `Ctrl+P` (Windows)
- **Type filename:** e.g., type "Question1" to find `Question1_Baseline_ctDNA_Prognosis.Rmd`
- **Use AI:** "Open the file with baseline ctDNA analysis"

### Finding Files in Large Projects

Your workspace has 50+ Rmd files. Use:

1. **File Explorer:** Left sidebar (folder icon)
2. **Search files:** `Cmd+P` then type part of filename
3. **Search in files:** `Cmd+Shift+F` (search content across files)
4. **AI search:** "Find files that use read_excel with AK_Clean"

### Organizing Your Project

**Current state:** Many files with similar names (`AK_Clean_12_21.Rmd`, `AK_Clean_12_23.Rmd`, etc.)

**Recommendation:** Organize by project/date:
```
project/
  ├── analyses/
  │   ├── 2024-12/
  │   │   ├── AK_Clean_12_21.Rmd
  │   │   └── AK_Clean_12_23.Rmd
  │   └── 2025-01/
  ├── data/
  │   └── AK_Clean_Temp.xlsx
  └── scripts/
      └── ctDNA_Research_Questions_Shared_Setup.R
```

---

## Debugging & Troubleshooting

### Common Issues

#### Issue 1: "Cannot find file" or "file not found"

**Problem:** Path issues (especially with `setwd()`)

**Solution:** Use absolute paths or `here::here()`:
```r
# Instead of:
setwd("~/R")
data <- read_excel("file.xlsx")

# Use:
library(here)
data <- read_excel(here("data", "file.xlsx"))

# Or absolute:
data <- read_excel("~/R/AK_Clean_Temp.xlsx")
```

#### Issue 2: "Package not found"

**Solution:** Install in terminal:
```r
install.packages("package_name")
```

#### Issue 3: R Markdown won't knit

**Debug steps:**
1. Check for errors in setup chunk:
   ```r
   # Run this in R console first:
   source("ctDNA_Research_Questions_Shared_Setup.R")
   ```
2. Check file paths exist
3. Run chunks one at a time to find which fails

#### Issue 4: "Detached HEAD" (Git issue)

**You're currently in detached HEAD state.** This means changes aren't on a branch.

**Fix:**
```bash
# Create a branch from current state:
git checkout -b my-analysis-branch

# Or switch to existing branch:
git checkout main
```

### Using AI to Debug

Ask Cursor:
- "Why is this R code giving an error?"
- "Help me debug this read_excel call"
- "What's wrong with this ggplot?"

Select the problematic code and use `Cmd+L` to ask.

---

## Best Practices

### 1. Path Management

**❌ Bad:**
```r
setwd("~/R")  # Changes working directory
data <- read_excel("file.xlsx")  # Breaks if you run from different location
```

**✅ Good:**
```r
# Use knitr root.dir (you're already doing this!):
knitr::opts_knit$set(root.dir = "~/R")

# Or use here package:
library(here)
data <- read_excel(here("data", "file.xlsx"))
```

### 2. Package Management

**Create a package loading script:**
```r
# packages.R
required_packages <- c("dplyr", "tidyr", "readxl", "ggplot2", ...)

install_if_missing <- function(packages) {
  new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
  if(length(new_packages)) install.packages(new_packages)
}

install_if_missing(required_packages)
```

### 3. Code Organization

**Separate concerns:**
- **Data loading:** `load_data.R` or setup chunk
- **Functions:** `functions.R` or shared setup file
- **Analysis:** Your `.Rmd` files
- **Output:** HTML/PDF files (add to `.gitignore`)

### 4. Version Control

**Add to `.gitignore`:**
```
# R
.Rhistory
.RData
.Ruserdata
*.Rproj

# Output files (regenerate with knitting)
*.html
*.pdf
*.docx

# Cache
.Rproj.user/
*.rds
cache/

# Temporary files
~$*.xlsx
~$*.docx
```

### 5. Documentation

Use comments and section headers:
```r
# ============================================================================
# Data Loading
# ============================================================================

# Load patient data
data <- read_excel("patients.xlsx")

# ============================================================================
# Data Cleaning
# ============================================================================

# Remove missing values
data_clean <- data %>% filter(!is.na(patient_id))
```

---

## Quick Reference

### Essential Keyboard Shortcuts

| Action | Mac | Windows/Linux |
|--------|-----|---------------|
| Open terminal | `` Cmd+` `` | `` Ctrl+` `` |
| Quick open file | `Cmd+P` | `Ctrl+P` |
| Search in files | `Cmd+Shift+F` | `Ctrl+Shift+F` |
| AI chat | `Cmd+L` | `Ctrl+L` |
| Command palette | `Cmd+Shift+P` | `Ctrl+Shift+P` |

### Common R Commands in Terminal

```bash
# Start R
R

# Run R script
Rscript script.R

# Install package
Rscript -e "install.packages('package_name')"

# Knit R Markdown
Rscript -e "rmarkdown::render('file.Rmd')"
```

### Your Typical Workflow Should Be:

1. **Open Cursor** in your project directory
2. **Edit `.Rmd` file** with AI assistance
3. **Test code chunks** in terminal R console:
   - Open terminal (`` Cmd+` ``)
   - Start R: `R`
   - Source setup: `source("ctDNA_Research_Questions_Shared_Setup.R")`
   - Run code from chunk
4. **Fix issues** with AI help (`Cmd+L` on selected code)
5. **Knit document** when ready:
   ```bash
   Rscript -e "rmarkdown::render('your_file.Rmd')"
   ```
6. **View output** HTML file in browser

### When to Use What Tool

| Task | Use This |
|------|----------|
| Writing/editing R code | **Cursor** (with AI) |
| Interactive data exploration | **RStudio** or **R console in terminal** |
| Running complex analyses | **Terminal** with `Rscript` |
| Creating reports | **Cursor** to write `.Rmd`, **terminal** to knit |
| Debugging | **Cursor AI** + **R console** |
| Version control | **Cursor** (Git integration) |

---

## Next Steps

1. **Try the terminal workflow:**
   - Open terminal in Cursor
   - Start R
   - Load your data and run a quick analysis

2. **Use AI for code help:**
   - Select a chunk of R code
   - Press `Cmd+L`
   - Ask: "Explain this code" or "How can I improve this?"

3. **Organize your files:**
   - Create folders for different projects
   - Move related files together

4. **Set up `.gitignore`:**
   - Exclude `.RData`, `.Rhistory`, output files
   - Keep only source code in Git

5. **Consider R Extension:**
   - Install "R" extension from REditorSupport
   - Provides better syntax highlighting and chunk execution

---

## Example: Your Actual Workflow

Based on your `Question1_Baseline_ctDNA_Prognosis.Rmd`:

```bash
# 1. Open terminal in Cursor
# 2. Navigate to your directory
cd ~/R

# 3. Start R
R

# 4. In R console, source your setup
source("ctDNA_Research_Questions_Shared_Setup.R")

# 5. Test a chunk manually
library(dplyr)
library(survival)
# ... test your code ...

# 6. Exit R when done testing
q()

# 7. Knit the document
Rscript -e "rmarkdown::render('Question1_Baseline_ctDNA_Prognosis.Rmd')"

# 8. Open the HTML output (double-click in file explorer)
```

---

## Getting Help

- **AI in Cursor:** Select code → `Cmd+L` → Ask questions
- **R Help:** In R console: `?function_name`
- **Package docs:** `help(package = "package_name")`
- **Stack Overflow:** For R-specific questions

---

**Remember:** Cursor is a tool to help you write and manage R code more efficiently. The R language itself and your analysis workflow remain the same!
