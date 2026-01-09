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
library(gridExtra)
library(patchwork)
library(readxl)
library(ggplot2)
library(RColorBrewer)
library(svglite)
library(forcats)




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



# Define base font size
base_font_size <- 9

# Define colors
colors <- RColorBrewer::brewer.pal(8, "Set2")

# Plot p1
p1 <- ggplot(data_percentage, aes(x = as.factor(enrollment_start), y = Percentage, color = Criterion, group = Criterion)) +
  geom_line(size = 0.5) +  
  geom_point(size = 1) +   
  geom_errorbar(aes(ymin = Percentage - SE, ymax = Percentage + SE), width = 0.2, size = 0.5) +  
  scale_x_discrete(breaks = levels(as.factor(data_percentage$enrollment_start))) + 
  scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, by = 25)) + 
  labs(
    x = "Enrollment Start Year",
    y = "Percentage of Trials (%)",
    color = "Exclusion criteria"
  ) +
  theme_classic(base_size = base_font_size) +  
  theme(
    plot.title = element_text(size = 18, hjust = 0.5, face = "bold"),  
    axis.title = element_text(size = base_font_size),  
    legend.title = element_blank(),  
    legend.text = element_text(size = base_font_size),  
    legend.position = "bottom",  
    panel.grid.major.x = element_blank(),  
    panel.grid.major.y = element_line(color = "lightgrey"),  
    panel.grid.minor = element_blank(),  
    panel.border = element_blank(),  
    panel.background = element_blank()  
  )

print(p1)





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



# Rename the category column for each dataset
data_left <- rename(data_left, Category = Exclusion_Criteria)
data_middle <- rename(data_middle, Category = Estimation_Equation)
data_right <- rename(data_right, Category = Cutoff)

# Add the Source column
data_left$Source <- 'Exclusion Criteria'
data_middle$Source <- 'Estimation Equation'
data_right$Source <- 'Cutoff'

# Read the Excel file for the fourth data table
data_renal <- read_excel("~/Downloads/Pie_chart.xlsx", sheet = "Renal_fxn")

# Assuming you have a column named Count in your data
data_renal$Percentage <- (data_renal$Count / sum(data_renal$Count)) * 100

# Drop NA values which may cause plotting issues
data_renal <- na.omit(data_renal)

# Make sure the data is in the right format for ggplot2
data_renal <- transform(data_renal, Renal_function = as.factor(Renal_function))  # Corrected column name

# Rename the category column for the "Renal_fxn" dataset
data_renal <- rename(data_renal, Category = Renal_function)  # Corrected column name


# Add the Source column
data_renal$Source <- 'Renal_fxn'



# Modify the combine_small_categories function for the "cut-off" data frame
combine_small_categories_cutoff <- function(data, threshold, category_column) {
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
      Category = 'Other',
      Count = other_count,
      Percentage = other_percentage,
      SE = NA,
      Source = unique(data$Source)[1],  # Take the first source value as an example
      stringsAsFactors = FALSE
    )
    
    # Append the 'Other' category row to the dataset
    data <- rbind(data, other_row, stringsAsFactors = FALSE)
  }
  
  # Return the modified dataset
  data
}

# Apply the modified function to the "cut-off" data frame with a 10% threshold
data_right <- combine_small_categories_cutoff(data_right, 10, "Cutoff")
# Apply the modified function to the "cut-off" data frame with a 10% threshold
data_renal <- combine_small_categories_cutoff(data_renal, 10, "Renal_function")

# Define colors, with grey for "Other" category
colors_cutoff <- ifelse(data_right$Category == "Other", "grey", rainbow(length(unique(data_right$Category))))


# Combine the datasets
data_combined <- rbind(data_left, data_middle, data_renal, data_right)



# Determine the number of unique categories
num_categories <- length(unique(data_combined$Category))




# Create a palette
if (num_categories > 12) {
  colors <- colorRampPalette(RColorBrewer::brewer.pal(12, "Set3"))(num_categories)
} else {
  colors <- RColorBrewer::brewer.pal(num_categories, "Paired")
}



# Plot p2
# Define base font size
base_font_size <- 9

# Plot p2 with reordered and relabeled graphs
p2 <- ggplot(data_combined, aes(x = Source, y = Percentage, fill = fct_reorder(Category, Percentage), order = -Percentage)) +
  geom_bar(stat = "identity", position = "stack", width = 0.7, color = "black") +  
  scale_fill_manual(values = colors) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.05)), name = "Percentage of Trials (%)") +  
  theme_classic(base_size = base_font_size) +  
  theme(
    panel.border = element_blank(),  
    panel.grid.major.y = element_line(color = "lightgrey"),  
    strip.background = element_blank(),  
    strip.text = element_blank(),  
    legend.position = "bottom",  
    legend.title = element_blank(),  
    legend.text = element_text(size = base_font_size - 4),  # Smaller legend text size
    axis.title.x = element_blank(),  
    axis.text.x = element_text(angle = 45, hjust = 1)  
  ) +
  labs(x = NULL, y = NULL) +
  
  guides(fill = guide_legend(title = "Category", ncol = 4, reverse = TRUE))  # Organize legend alphabetically

# Print p1 and p2
print(p1)
print(p2)

# Combine the plots
combined_plot <- p1 + p2

print(combined_plot)

# Save the combined plot as SVG
ggsave("combined_plot_stack.svg", plot = combined_plot, device = "svg")
