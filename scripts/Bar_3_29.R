# Load the required packages
library(readxl)
library(dplyr)
library(ggplot2)

# Read the Excel file from the specified sheet
data <- read_excel("~/Downloads/Pie_chart.xlsx", sheet = "Exclusion Criteria2")

# Drop NA values which may cause plotting issues
data <- na.omit(data)

# Ensure the Exclusion_Criteria column is a factor for ggplot2 to use it properly
data$Exclusion_Criteria <- as.factor(data$Exclusion_Criteria)

# Create a single, non-stacked bar chart using absolute counts
p <- ggplot(data, aes(x = Exclusion_Criteria, y = Count, fill = Exclusion_Criteria)) +
  geom_bar(stat = "identity", width = 0.7, color = "black", show.legend = FALSE) +
  scale_fill_brewer(palette = "Set3") +
  theme_classic() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid.minor = element_line(color = "gray", size = 0.5, linetype = "dashed") # Define minor gridlines
  ) +
  labs(x = "Evaluation Approaches", y = "Count") +
  scale_y_continuous(
    breaks = seq(0, max(data$Count) + 20, by = 20), # Set y-axis intervals to 20
    minor_breaks = seq(0, max(data$Count) + 20, by = 10) # Set minor y-axis intervals for gridlines
  )

# Print the plot
print(p)

# Save the plot as PDF
ggsave("exclusion_criteria2_bar_chart.pdf", plot = p, device = "pdf", path = "~/Downloads/")
