setwd("/Users/Alex/R")

# Install packages if they are not already installed
if (!requireNamespace("readxl", quietly = TRUE)) install.packages("readxl")
if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr")
if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")
if (!requireNamespace("broom", quietly = TRUE)) install.packages("broom")
library(patchwork)

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

# Pivot the data to a long format and filter as before
data_long <- GFR_Graph_Clean %>%
  pivot_longer(
    cols = c("crabs", "crcl", "cruln", "n_a_formula", "egfr", "heterogenous"), # Corrected column name
    names_to = "Criterion",
    values_to = "Used"
  ) %>%
  filter(enrollment_start < 2020)

# Recode the Criterion column to replace specified values with the desired text
data_long$Criterion <- recode(data_long$Criterion,
                              "crabs" = "Absolute sCR",
                              "crcl" = "CrCl",
                              "cruln" = "sCR ULN",
                              "n_a_formula" = "Not specified",
                              "egfr" = "eGFR",  
                              "heterogenous" = ">1 method")  # Corrected spelling for recoding

# Proceed with calculation of percentages and standard error
data_percentage <- data_long %>%
  group_by(enrollment_start, Criterion) %>%
  summarise(
    Percentage = mean(Used, na.rm = TRUE) * 100,
    SE = sd(Used, na.rm = TRUE) / sqrt(n()) * 100
  ) %>%
  ungroup()

# Plot with updated criteria names and legend title
p1 <- ggplot(data_percentage, aes(x = as.factor(enrollment_start), y = Percentage, color = Criterion, group = Criterion)) +
  geom_line() +
  geom_point() +
  geom_errorbar(aes(ymin = Percentage - SE, ymax = Percentage + SE), width = 0.2, alpha= 0.5) +
  scale_x_discrete(breaks = unique(as.character(data_percentage$enrollment_start))) +
  labs(title = "Renal Function Exclusion Criteria Over Time",
       x = "Enrollment Start Year",
       y = "Percentage of Trials (%)",
       color = "Exclusion criteria") +
  theme_classic() +
  theme(plot.title = element_text(size = 14, hjust = 0.5),
        axis.title = element_text(size = 12),
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 10),
        aspect.ratio = 1)

print(p1)
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

# Load necessary libraries
library(patchwork)
library(readxl)
library(ggplot2)
library(RColorBrewer)
library(svglite)

# Read the Excel file
data_left <- read_excel("~/Downloads/Pie_chart.xlsx", sheet = "Exclusion Criteria")
data_middle <- read_excel("~/Downloads/Pie_chart.xlsx", sheet = "Estimation Equations")                  
data_right <- read_excel("~/Downloads/Pie_chart.xlsx", sheet = "Cutoff")   

# Ensure the 'Count' and 'SE' columns are numeric
data_left$Count <- as.numeric(data_left$Count)
data_middle$Count <- as.numeric(data_middle$Count)
data_right$Count <- as.numeric(data_right$Count)
data_left$SE <- as.numeric(data_left$SE)
data_middle$SE <- as.numeric(data_middle$SE)
data_right$SE <- as.numeric(data_right$SE)




# Read the Excel file
data_left <- read_excel("~/Downloads/Pie_chart.xlsx", sheet = "Exclusion Criteria")
data_middle <- read_excel("~/Downloads/Pie_chart.xlsx", sheet = "Estimation Equations")                  
data_right <- read_excel("~/Downloads/Pie_chart.xlsx", sheet = "Cutoff")                                 

# Assuming you have a column named Count in your data
data_left$Percentage <- (data_left$Count / sum(data_left$Count)) * 100
data_middle$Percentage <- (data_middle$Count / sum(data_middle$Count)) * 100
data_right$Percentage <- (data_right$Count / sum(data_right$Count)) * 100

# Drop NA values which may cause plotting issues
data_left <- na.omit(data_left)
data_middle <- na.omit(data_middle)
data_right <- na.omit(data_right)

# Make sure the data is in the right format for ggplot2
data_left <- transform(data_left, Exclusion_Criteria = as.factor(Exclusion_Criteria))
data_middle <- transform(data_middle, Estimation_Equation = as.factor(Estimation_Equation))
data_right <- transform(data_right, Cutoff = as.factor(Cutoff))

combine_small_categories <- function(data, threshold, category_column) {
  # Find categories with a percentage less than or equal to the threshold
  small_categories <- data$Percentage <= threshold
  
  # Sum their counts and percentages
  other_count <- sum(data$Count[small_categories], na.rm = TRUE)
  other_percentage <- sum(data$Percentage[small_categories], na.rm = TRUE)
  
  # Remove small categories from the dataset
  data <- data[!small_categories, ]
  
  # Create a new row for the 'Other' category if there were any small categories
  if(other_percentage > 0) {
    other_row <- data.frame(
      Count = other_count,
      Percentage = other_percentage,
      SE = NA  # If standard errors are present, this will need to be calculated appropriately
    )
    other_row[[category_column]] <- 'Other'
    
    # Append the 'Other' category row to the dataset
    data <- rbind(data, other_row)
  }
  
  # Return the modified dataset
  data
}

# Apply the function to your datasets
data_left <- combine_small_categories(data_left, 1, "Exclusion_Criteria")
data_middle <- combine_small_categories(data_middle, 1, "Estimation_Equation")
data_right <- combine_small_categories(data_right, 1, "Cutoff")

# Your plotting function might need to handle the absence of 'SE' for 'Other' correctly.
# Now plot your bar charts with the updated datasets, using the plot_percentage_bar function or a similar one.


# Get unique categories from all data frames
all_categories <- unique(c(data_left$Exclusion_Criteria, data_middle$Estimation_Equation, data_right$Cutoff))

# Generate colors dynamically based on the number of unique categories
colors <- rainbow(length(all_categories))


base_theme <- theme_classic() +
  theme(plot.title = element_text(size = 14, hjust = 0.5),
        axis.title.y = element_text(size = 12),
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 10),
        legend.position = "right")

# Define a theme without x-axis labels for other bar charts
no_x_labels_theme <- base_theme +
  theme(axis.title.x = element_blank(),  # Remove x-axis title
        axis.text.x = element_blank())   # Remove x-axis text/labels

# Adjust 'p1' with the base theme and add x-axis labels
p1 <- p1 +
  scale_y_continuous(limits = c(0, 100)) +
  base_theme

# Function to create bar charts without x-axis labels
create_adjusted_bar_chart <- function(data, category_column, graph_title, palette_name = "Set3", threshold = 1) {
  # Calculate percentages and combine small categories into 'Other'
  data <- data %>%
    mutate(Category = ifelse(Percentage <= threshold, 'Other', as.character(data[[category_column]]))) %>%
    group_by(Category) %>%
    summarise(Count = sum(Count), Percentage = sum(Percentage), .groups = 'drop') %>%
    ungroup()
  
  # Generate colors, ensuring 'Other' is gray if it exists
  unique_categories <- unique(data$Category)
  colors <- brewer.pal(min(length(unique_categories), brewer.pal.info[palette_name, 'maxcolors']), palette_name)
  if ('Other' %in% unique_categories) {
    colors <- c('grey', colors[!(colors %in% 'grey')])
  }
  
  # Plot the bar chart with y-axis going up to 100% and apply no x-axis labels theme
  ggplot(data, aes(x = Category, y = Percentage, fill = Category)) +
    geom_bar(stat = "identity") +
    scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, by = 20)) +
    scale_fill_manual(values = colors, name = graph_title) +
    labs(y = "Percentage of Studies (%)") +
    no_x_labels_theme
}

# Apply the function to create bar charts without x-axis labels
left_chart_bar <- create_adjusted_bar_chart(data_left, "Exclusion_Criteria", "Exclusion Criteria", "Paired")
middle_chart_bar <- create_adjusted_bar_chart(data_middle, "Estimation_Equation", "Estimation Equation", "Dark2")
right_chart_bar <- create_adjusted_bar_chart(data_right, "Cutoff", "Exclusion Thresholds", "Set1")


# Apply the consistent theme to 'p1' and add it to the grid


final_layout <- p1 / left_chart_bar | middle_chart_bar / right_chart_bar 

# Print the arranged grid of bar charts with 'p1' on top
print(final_layout)

# Save the final layout as a PDF file
ggsave("final_adjusted_grid_layout.pdf", plot = final_layout, width = 16, height = 12, device = "pdf")
