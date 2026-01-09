# Script to knit RMarkdown to Word document
# Usage: Rscript knit_to_word.R

library(rmarkdown)

cat("========================================\n")
cat("Knitting ctDNA_Descriptive.Rmd to Word\n")
cat("========================================\n\n")

# Method 1: Try with word_document format
cat("Attempting to render to Word format...\n")
tryCatch({
  render('ctDNA_Descriptive.Rmd', 
         output_format = 'word_document',
         output_file = 'ctDNA_Descriptive.docx',
         quiet = FALSE)
  cat("\n✅ SUCCESS! Word document created: ctDNA_Descriptive.docx\n")
  cat("\nNote: Some HTML table styling may not appear in Word.\n")
  cat("All content (tables, figures, text) will be present.\n")
}, error = function(e) {
  cat("\n❌ Error occurred:\n")
  cat(conditionMessage(e), "\n\n")
  cat("Alternative: Use RStudio's 'Knit' button and select 'Word' from the dropdown.\n")
  cat("Or manually remove kable_styling() calls for Word compatibility.\n")
})
