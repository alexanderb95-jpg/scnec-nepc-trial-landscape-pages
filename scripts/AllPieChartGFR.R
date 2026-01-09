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
p <- ggplot(data_percentage, aes(x = as.factor(enrollment_start), y = Percentage, color = Criterion, group = Criterion)) +
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

print(p)
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
library(readxl)
library(ggplot2)
library(RColorBrewer)

library("svglite")

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

# Get unique categories from all data frames
all_categories <- unique(c(data_left$Exclusion_Criteria, data_middle$Estimation_Equation, data_right$Cutoff))

# Generate colors dynamically based on the number of unique categories
colors <- rainbow(length(all_categories))

create_pie_chart <- function(data, title, category_column, palette_name = "Set3") {
  # Ensure the 'Count' column is numeric
  data$Count <- as.numeric(data$Count)
  
  # Calculate percentages and labels for the slices
  data$Label <- paste0(round(data$Percentage, 1), "%") # Add % sign to the label
  
  # Generate a color palette with RColorBrewer
  num_categories <- length(unique(data[[category_column]]))
  if (num_categories > brewer.pal.info[palette_name,'maxcolors']) {
    colors <- brewer.pal(brewer.pal.info[palette_name,'maxcolors'], palette_name)
    colors <- colorRampPalette(colors)(num_categories)
  } else {
    colors <- brewer.pal(num_categories, palette_name)
  }
  
  # Plot the pie chart
  p <- ggplot(data, aes(x = factor(1), y = Count, fill = factor(data[[category_column]]))) +
    geom_bar(stat = "identity", width = 1) +
    coord_polar("y", start = 0) +
    geom_text(aes(label = Label), position = position_stack(vjust = 0.5), size = 3) +
    theme_void() +
    theme(legend.position = "right") +
    labs(title = title, fill = title) + # Use title for legend title
    scale_fill_manual(values = colors) +
    guides(fill = guide_legend(override.aes = list(size = 5))) +
    theme(legend.key.size = unit(0.5, "cm"),
          legend.text = element_text(size = 8))
  
  return(p)
}


# Recreate the pie charts with the modified function that includes percentages
left_chart <- create_pie_chart(data_left, "Exclusion criteria", "Exclusion_Criteria", "Paired")
middle_chart <- create_pie_chart(data_middle, "Estimation equation", "Estimation_Equation", "Dark2")
right_chart <- create_pie_chart(data_right, "Exclusion thresholds", "Cutoff", "Set1")

# Print the pie charts to the R plotting window
print(left_chart)
print(middle_chart)

create_pie_chart_right <- function(data, title, category_column, palette_name = "Set3", threshold = 3) {
  data$Count <- as.numeric(data$Count)
  data$Percentage <- as.numeric(data$Percentage)
  data$Label <- paste0(round(data$Percentage, 1), "%")
  
  # Determine rows to be grouped into "Other"
  below_threshold <- data$Percentage < threshold
  if(any(below_threshold)) {
    other_count <- sum(data$Count[below_threshold])
    other_percentage <- sum(data$Percentage[below_threshold])
    
    # Create a row for "Other"
    other_row <- data.frame(Count = other_count, Percentage = other_percentage)
    other_row[[category_column]] <- 'Other'
    other_row$Label <- paste0(round(other_percentage, 1), "%")
    
    # Ensure other_row has all necessary columns
    missing_cols <- setdiff(names(data), names(other_row))
    for(col in missing_cols) {
      other_row[[col]] <- NA  # Assign NA for compatibility
    }
    
    # Align 'other_row' columns with 'data'
    other_row <- other_row[names(data)]
    
    # Append 'Other' row to data
    data <- rbind(data[!below_threshold, ], other_row)
  }
  
  data[[category_column]] <- factor(data[[category_column]])
  
  # Adjust the color palette
  categories <- unique(data[[category_column]])
  colors <- brewer.pal(min(length(categories), brewer.pal.info[palette_name, 'maxcolors']), palette_name)
  names(colors) <- categories
  if("Other" %in% categories) {
    colors["Other"] <- "grey"
  }
  
  # Plot
  p <- ggplot(data, aes(x = "", y = Count, fill = as.factor(data[[category_column]]))) +
    geom_bar(stat = "identity", width = 1) +
    coord_polar("y", start = 0) +
    geom_text(aes(label = Label), position = position_stack(vjust = 0.5), size = 3) +
    theme_void() +
    theme(legend.position = "right") +
    labs(title = title, fill = title) +  # Use title for legend title
    scale_fill_manual(values = colors) +
    guides(fill = guide_legend(override.aes = list(size = 5))) +
    theme(legend.key.size = unit(0.5, "cm"), legend.text = element_text(size = 8))
  
  return(p)
}




# Assuming 'data_right', 'title', 'category_column', and 'palette_name' are correctly set
# You may now call `create_pie_chart_right` for your "Cutoff" data
right_chart <- create_pie_chart_right(data_right, "Exclusion thresholds", "Cutoff", "Set1", 3)
print(right_chart)

# Assuming p, left_chart, middle_chart, right_chart are already created

# Remove titles from each plot (if they have titles)
p <- p + theme(plot.title = element_blank())
left_chart <- left_chart + theme(plot.title = element_blank())
middle_chart <- middle_chart + theme(plot.title = element_blank())
right_chart <- right_chart + theme(plot.title = element_blank())

# Ensure patchwork is loaded
library(patchwork)

# Arrange the plots in a 2x2 grid
grid_layout <- p / left_chart | middle_chart / right_chart

# Print the arranged grid of plots
print(grid_layout)

# Filter out thresholds starting with "sCR"
data_right_filtered <- data_right[!grepl("^sCR", data_right$Cutoff), ]

# Calculate percentages again
data_right_filtered$Percentage <- (data_right_filtered$Count / sum(data_right_filtered$Count)) * 100

# Drop NA values which may cause plotting issues
data_right_filtered <- na.omit(data_right_filtered)

# Recreate the pie chart for the filtered data
right_chart_filtered <- create_pie_chart_right(data_right_filtered, "Exclusion thresholds", "Cutoff", "Set1", 3)

# Print the filtered pie chart to the R plotting window
print(right_chart_filtered)

# Assuming p, left_chart, middle_chart, right_chart are already created

# Remove titles from each plot (if they have titles)
p <- p + theme(plot.title = element_blank())
left_chart <- left_chart + theme(plot.title = element_blank())
middle_chart <- middle_chart + theme(plot.title = element_blank())
right_chart_filtered <- right_chart_filtered + theme(plot.title = element_blank())

# Ensure patchwork is loaded
library(patchwork)

# Arrange the plots in a 2x2 grid
grid_layout <- p / left_chart | middle_chart / right_chart_filtered

# Print the arranged grid of plots
print(grid_layout)

# Save the grid layout as a PDF file
ggsave("grid_layout.pdf", plot = grid_layout, width = 10, height = 8, device = "pdf")

# Filter out thresholds starting with "sCR" from data_right
data_right_sCR_filtered <- data_right[grepl("^sCR", data_right$Cutoff), ]

# Check if there are any rows after filtering
if (nrow(data_right_sCR_filtered) == 0) {
  print("No data available for thresholds starting with 'sCR'.")
} else {
  # Calculate percentages again
  data_right_sCR_filtered$Percentage <- (data_right_sCR_filtered$Count / sum(data_right_sCR_filtered$Count)) * 100
  
  # Drop NA values which may cause plotting issues
  data_right_sCR_filtered <- na.omit(data_right_sCR_filtered)
  
  # Recreate the pie chart for the filtered data
  right_chart_sCR_filtered <- create_pie_chart_right(data_right_sCR_filtered, "Exclusion thresholds (sCR)", "Cutoff", "Set1", 3)
  
  # Print the filtered pie chart to the R plotting window
  print(right_chart_sCR_filtered)
  
  # Assuming p, left_chart, and right_chart are already created
  
  # Remove titles from each plot (if they have titles)
  p <- p + theme(plot.title = element_blank())
  left_chart <- left_chart + theme(plot.title = element_blank())
  right_chart_sCR_filtered <- right_chart_sCR_filtered + theme(plot.title = element_blank())
  
  # Ensure patchwork is loaded
  library(patchwork)
  
  # Arrange the plots in a 2x2 grid
  grid_layout <- p / right_chart_sCR_filtered | middle_chart / right_chart_filtered
  
  # Print the arranged grid of plots
  print(grid_layout)
  
  # Save the grid layout as a PDF file
  ggsave("grid_layout.pdf", plot = grid_layout, width = 10, height = 8, device = "pdf")
}


