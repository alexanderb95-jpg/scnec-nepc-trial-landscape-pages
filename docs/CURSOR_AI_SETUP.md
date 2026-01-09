# Setting Up Cursor AI Agent for Scientific Data Analysis

## Overview

Cursor uses a `.cursorrules` file in your project root to configure how the AI agent behaves when helping you with code. This file has been created with rules specific to scientific data analysis in R.

## Location

The AI rules file is located at:
```
/Users/Alex/R/.cursorrules
```

## What's Configured

The `.cursorrules` file includes:

1. **Project Context**: Understanding of your clinical trial/ctDNA analysis project
2. **Directory Structure**: Knowledge of where files should go
3. **Code Style**: Tidyverse conventions and best practices
4. **Statistical Methods**: Guidelines for survival analysis, regression, etc.
5. **Reproducibility**: Standards for R Markdown and reproducible research
6. **Visualization**: Publication-quality figure standards
7. **Data Handling**: Best practices for clinical data

## How to Use

### Automatic Behavior
Once `.cursorrules` is in place, the AI agent will automatically:
- Follow your project's coding style
- Suggest appropriate R packages for tasks
- Place files in the correct directories
- Write reproducible, well-documented code
- Use statistical methods appropriate for your research

### Interacting with the Agent

1. **Ask for help with analysis**:
   - "Help me create a Cox regression model for survival analysis"
   - "Generate a publication-quality survival curve plot"
   - "Clean this clinical trial data and handle missing values"

2. **Request code following your patterns**:
   - "Create an R Markdown file following the project structure"
   - "Write a script to load and clean the ctDNA data"
   - "Generate a table of descriptive statistics"

3. **Get statistical guidance**:
   - "What assumptions should I check for this regression model?"
   - "How should I handle censoring in this survival analysis?"
   - "What's the appropriate multiple comparison correction here?"

### Customizing the Rules

You can edit `.cursorrules` to add:
- Project-specific patterns you want the agent to follow
- Additional packages or methods you prefer
- Specific statistical approaches for your research
- Custom file naming conventions

## Example Interactions

### Example 1: Creating a Survival Analysis
**You**: "I need to analyze survival by treatment group"

**Agent will**:
- Use `survival` and `survminer` packages
- Create a Cox model with proper syntax
- Generate a publication-quality plot
- Save to `figures/` directory
- Include proper statistical checks

### Example 2: Data Cleaning
**You**: "Load the Excel file and clean the dates"

**Agent will**:
- Use `readxl::read_excel()` 
- Use the `as_date_safe()` pattern from your shared setup
- Handle Excel date serials correctly
- Save processed data appropriately
- Follow your project's data handling patterns

### Example 3: Creating a Report
**You**: "Create an R Markdown report for the baseline ctDNA analysis"

**Agent will**:
- Create file in `rmarkdown/` directory
- Use proper chunk structure
- Include setup, data loading, analysis, results sections
- Follow your existing R Markdown patterns
- Use appropriate chunk options

## Tips for Best Results

1. **Be specific**: The more context you give, the better the agent can help
   - ✅ "Create a Cox regression model with age, sex, and treatment as covariates"
   - ❌ "Do a regression"

2. **Reference existing code**: Point to similar analyses you've done
   - "Create a survival analysis similar to Question1_Baseline_ctDNA_Prognosis.Rmd"

3. **Ask for explanations**: The agent can explain statistical methods
   - "Why should I check proportional hazards assumption?"
   - "What's the difference between landmark and time-dependent analysis?"

4. **Request documentation**: Ask the agent to document code
   - "Add comments explaining the statistical approach"
   - "Document why we're using this transformation"

## Viewing Current Rules

To see what rules are active:
```bash
cat .cursorrules
```

Or open the file in Cursor to view and edit.

## Updating Rules

1. Edit `.cursorrules` directly
2. The changes take effect immediately for new AI interactions
3. Commit changes to git to share with collaborators:
   ```bash
   git add .cursorrules
   git commit -m "Update AI agent rules for [specific change]"
   ```

## Additional Cursor Settings

You can also configure Cursor globally:
1. Open Cursor Settings (Cmd+, on Mac, Ctrl+, on Windows)
2. Search for "AI" or "Rules"
3. Configure model preferences, temperature, etc.

The `.cursorrules` file works in addition to these global settings and provides project-specific guidance.

## Troubleshooting

**Agent not following rules?**
- Make sure `.cursorrules` is in the project root
- Try restarting Cursor
- Check that the file is properly formatted (no syntax errors)

**Want different behavior?**
- Edit `.cursorrules` to add or modify rules
- Be specific about what you want changed
- Test with a simple request to verify behavior

**Rules too restrictive?**
- You can always override by being explicit in your requests
- The rules are guidelines, not hard constraints
- Modify rules to match your actual workflow

## Best Practices

1. **Keep rules updated**: As your project evolves, update the rules
2. **Be specific in rules**: Vague rules lead to inconsistent behavior
3. **Document custom patterns**: If you have project-specific patterns, add them
4. **Review agent suggestions**: Always review AI-generated code before using
5. **Share with team**: Commit `.cursorrules` so collaborators benefit

## Next Steps

1. ✅ `.cursorrules` file is created and configured
2. Try asking the agent for help with your analysis
3. Refine the rules based on what works best for your workflow
4. Share the rules file with collaborators

The AI agent is now configured to help with your scientific data analysis following best practices for R, reproducibility, and clinical research!
