
install.packages("readxl")


# Load the readxl library
library(readxl)

# Set the file path
file_path <- "Withdrawl_Sample_R.xlsx"


# Read the Excel file from the specified path
data <- read_excel(file_path, sheet = "Sheet1")

# View the first few rows of the data to confirm it's loaded correctly
head(data)
