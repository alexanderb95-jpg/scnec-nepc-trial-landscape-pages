# Helper function to extract and execute R code chunks from R Markdown files
extract_and_run_chunk <- function(rmd_file, chunk_name) {
  # Read the Rmd file
  if (!file.exists(rmd_file)) {
    stop(paste("File not found:", rmd_file))
  }
  
  lines <- readLines(rmd_file)
  
  # Find the chunk - handle both with and without options
  chunk_pattern <- paste0("^```\\{r ", chunk_name, "(,|\\}|$)")
  chunk_start <- which(stringr::str_detect(lines, chunk_pattern))
  
  if (length(chunk_start) == 0) {
    # Try alternative pattern without comma/brace
    chunk_pattern2 <- paste0("^```\\{r ", chunk_name)
    chunk_start <- which(stringr::str_detect(lines, chunk_pattern2))
  }
  
  if (length(chunk_start) == 0) {
    warning(paste("Chunk", chunk_name, "not found in", rmd_file, "- skipping"))
    return(invisible(NULL))
  }
  
  # Find the end of the chunk (next ```)
  all_code_blocks <- which(stringr::str_detect(lines, "^```"))
  chunk_end <- all_code_blocks[all_code_blocks > chunk_start[1]][1]
  
  if (is.na(chunk_end)) {
    warning(paste("Chunk", chunk_name, "does not have a closing marker - skipping"))
    return(invisible(NULL))
  }
  
  # Extract the code (skip the chunk header)
  code_lines <- lines[(chunk_start[1]+1):(chunk_end-1)]
  
  # Remove any remaining markdown markers
  code_lines <- code_lines[!stringr::str_detect(code_lines, "^```")]
  
  # Remove empty lines at start/end
  code_lines <- code_lines[!grepl("^\\s*$", code_lines) | seq_along(code_lines) <= length(code_lines)]
  
  if (length(code_lines) == 0) {
    warning(paste("Chunk", chunk_name, "is empty - skipping"))
    return(invisible(NULL))
  }
  
  # Execute the code in the parent environment (global environment for R Markdown)
  tryCatch({
    # Use globalenv() to ensure objects persist across chunks
    eval(parse(text = paste(code_lines, collapse = "\n")), envir = .GlobalEnv)
  }, error = function(e) {
    warning(paste("Error executing chunk", chunk_name, ":", e$message))
    # Print the error for debugging
    cat("Error in chunk", chunk_name, ":", e$message, "\n")
  })
}

# Function to source multiple chunks in sequence
source_chunks <- function(rmd_file, chunk_names) {
  for (chunk_name in chunk_names) {
    extract_and_run_chunk(rmd_file, chunk_name)
  }
}

