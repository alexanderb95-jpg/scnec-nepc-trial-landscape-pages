setwd("/Users/Alex/R")

# Install packages if they are not already installed
if (!requireNamespace("readxl", quietly = TRUE)) install.packages("readxl")
if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr")
if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")
if (!requireNamespace("broom", quietly = TRUE)) install.packages("broom")

# Load the packages
library(readxl)
library(dplyr)
library(ggplot2)
library(broom)
library(tidyr) # Make sure to include this



library(readxl)



GFR_Graph_Clean <- read_excel("GFR_Graph_Clean.xlsx", 
                                            col_types = c("text", "numeric", "numeric", 
                                                          "text", "numeric", "numeric", "numeric", 
                                                          "numeric", "numeric", "numeric"))


# Let's inspect the column names to ensure we're using the correct one
colnames(GFR_Graph_Clean)
GFR_Graph_Clean


# Assuming GFR_Graph_Clean is already loaded and contains the necessary columns

# Step 2: Pivot the data to a long format
data_long <- GFR_Graph_Clean %>%
  pivot_longer(
    cols = crabs:n_a_formula, # Use actual column names for the criteria
    names_to = "Criterion",
    values_to = "Used"
  ) %>%
  filter(enrollment_start < 2020) # Exclude the year 2020 and onwards

# Step 3: Calculate the percentages for each year and criterion
# This step now also includes calculation of standard error for the error bars
data_percentage <- data_long %>%
  group_by(enrollment_start, Criterion) %>%
  summarise(
    Percentage = mean(Used, na.rm = TRUE) * 100,
    SE = sd(Used, na.rm = TRUE) / sqrt(n()) * 100
  ) %>%
  ungroup()

# Step 4: Plot the line graph with error bars
p <- ggplot(data_percentage, aes(x = as.factor(enrollment_start), y = Percentage, color = Criterion, group = Criterion)) +
  geom_line() +
  geom_point() +
  geom_errorbar(aes(ymin = Percentage - SE, ymax = Percentage + SE), width = 0.2, alpha= 0.5) +
  scale_x_discrete(breaks = unique(as.character(data_percentage$enrollment_start))) + # Ensure all years are shown
  labs(title = "Renal Function Exclusion Criteria Over Time",
       x = "Enrollment Start Year",
       y = "Percentage of Trials (%)") +
  theme_classic() +  # Using classic theme for a clean look suitable for medical publications
  theme(plot.title = element_text(size = 14, hjust = 0.5),  # Centering title
        axis.title = element_text(size = 12),
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 10),
        aspect.ratio = 1)  # Making plot more square




print(p)

# Iterate over each Criterion to add its linear regression line
#criteria <- unique(data_percentage$Criterion)

# Create an empty dataframe to store rounded R-squared and p-values
#rsquared_pvalue_table <- data.frame(Criterion = character(), R_squared = numeric(), P_value = numeric(), stringsAsFactors = FALSE)

# Iterate over each Criterion to add its linear regression line and collect R-squared values and p-values
#for(crit in criteria) {
  # Filter data for the current criterion
  #data_crit <- filter(data_percentage, Criterion == crit)
  
  # Fit a linear model
  #model <- lm(Percentage ~ as.numeric(as.character(enrollment_start)), data = data_crit)
  
  # Calculate R-squared value
  #r_squared <- round(summary(model)$r.squared, 2)
  
  # Extract p-value
  #p_value <- round(summary(model)$coefficients[2,4], 2) # p-value for the slope coefficient
  
  # Store rounded R-squared and p-value in the dataframe
  #rsquared_pvalue_table <- rbind(rsquared_pvalue_table, data.frame(Criterion = crit, R_squared = r_squared, P_value = p_value))
#}

# Print the rounded R-squared and p-value table
#print(rsquared_pvalue_table)



