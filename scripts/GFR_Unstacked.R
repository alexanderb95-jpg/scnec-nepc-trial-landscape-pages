setwd("/Users/Alex/R")

if (!requireNamespace("readxl", quietly = TRUE)) install.packages("readxl")
if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr")
if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")
if (!requireNamespace("broom", quietly = TRUE)) install.packages("broom")
if (!requireNamespace("RColorBrewer", quietly = TRUE)) install.packages("RColorBrewer")
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
library(RColorBrewer)
library(svglite)
library(forcats)
library(viridis)

GFR_Graph_Clean <- read_excel("GFR_Graph_Clean.xlsx", 
                              col_types = c("text", "numeric", "numeric", 
                                            "text", "numeric", "numeric", "numeric", 
                                            "numeric", "numeric","numeric"))

# Pivot the data to a long format and filter as before
data_long <- GFR_Graph_Clean %>%
  pivot_longer(
    cols = c("cr", "crcl", "n_a_formula", "egfr", "heterogenous","Three"), # Corrected column name
    names_to = "Criterion",
    values_to = "Used"
  ) %>%
  filter(enrollment_start < 2020)

# Recode the Criterion column to replace specified values with the desired text
data_long$Criterion <- recode(data_long$Criterion,
                              "cr" = "sCR",
                              "crcl" = "CrCl",
                              "n_a_formula" = "Not specified",
                              "egfr" = "eGFR",  
                              "heterogenous" = "CrCl or sCR",
                              "Three" = "eGFR or sCR or CrCl")  # Corrected spelling for recoding

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

# Define custom colors using the RColorBrewer palette and replace yellow with a darker color
custom_colors <- brewer.pal(6, "Set1")
custom_colors[custom_colors == "#FFFF33"] <- "#1B9E77"  # Replace yellow (#FFFF33) with a dark green (#1B9E77)

# Plot p1 with all lines dashed using custom colors
p1 <- ggplot(data_percentage, aes(x = as.factor(enrollment_start), y = Percentage, group = Criterion, color = Criterion)) +
  geom_line(size = 0.55, linetype = "dashed") +  # Set all lines to dashed
  geom_point(size = 1) +   
  geom_errorbar(aes(ymin = Percentage - SE, ymax = Percentage + SE, color = Criterion), width = 0.2, size = 0.5) +  
  scale_x_discrete(breaks = levels(as.factor(data_percentage$enrollment_start))) + 
  scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, by = 25)) + 
  labs(
    x = "Enrollment Start Year",
    y = "Percentage of Trials (%)",
    color = "Exclusion criteria"
  ) +
  scale_color_manual(values = custom_colors) +  # Set manual color scale
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
# Load necessary libraries
library(readxl)
library(dplyr)
library(ggplot2)
library(tidyr)
library(forcats)
library(patchwork)
library(RColorBrewer)
library(viridis)

# Read the Excel file
data_left <- read_excel("~/Downloads/Pie_chart.xlsx", sheet = "Exclusion Criteria")
data_middle <- read_excel("~/Downloads/Pie_chart.xlsx", sheet = "Estimation Equations")

# Calculate percentages and standard error
data_left <- data_left %>%
  group_by(Exclusion_Criteria) %>%
  summarise(Count = sum(Count)) %>%
  mutate(
    Percentage = (Count / sum(Count)) * 100,
    SE = sqrt(Percentage * (100 - Percentage) / sum(Count))
  )

data_middle <- data_middle %>%
  group_by(Estimation_Equation) %>%
  summarise(Count = sum(Count)) %>%
  mutate(
    Percentage = (Count / sum(Count)) * 100,
    SE = sqrt(Percentage * (100 - Percentage) / sum(Count))
  )

# Rename the category column for each dataset
data_left <- rename(data_left, Category = Exclusion_Criteria)
data_middle <- rename(data_middle, Category = Estimation_Equation)

# Add the Source column
data_left$Source <- 'Exclusion Criteria'
data_middle$Source <- 'Estimation Equation'

# Define base font size
base_font_size <- 9

# Define custom colors using the viridis palette
colors <- viridis_pal()(6)  # Adjust the number of colors as needed
colors_p3 <- brewer.pal(8, "Set1")
colors_p3[colors_p3 == "#FFFF33"] <- "#1B9E77"  # Replace yellow with a dark green

# Define common Y-axis limits
y_limits <- c(0, max(c(data_left$Percentage + data_left$SE, data_middle$Percentage + data_middle$SE)))

# Plot p2 with reordered and relabeled graphs using the same color palette as p1
p2 <- ggplot(data_left, aes(x = Source, y = Percentage, fill = fct_reorder(Category, Percentage), order = -Percentage)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.7), width = 0.7, color = "black") +  
  geom_errorbar(aes(ymin = Percentage - SE, ymax = Percentage + SE), position = position_dodge(0.7), width = 0.2) +
  scale_fill_manual(values = colors) +  # Using the same color palette as p1
  scale_y_continuous(expand = expansion(mult = c(0, 0.05)), name = "Percentage of Trials (%)", limits = y_limits) +  
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
  labs(x = NULL, y = NULL) + plot_annotation(title = "B") +
  guides(fill = guide_legend(title = "Category", ncol = 2, reverse = TRUE))   # Organize legend alphabetically

# Plot p3 with reordered and relabeled graphs using the Set1 color palette
p3 <- ggplot(data_middle, aes(x = Source, y = Percentage, fill = fct_reorder(Category, Percentage), order = -Percentage)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.7), width = 0.7, color = "black") +  
  geom_errorbar(aes(ymin = Percentage - SE, ymax = Percentage + SE), position = position_dodge(0.7), width = 0.2) +
  scale_fill_manual(values = colors_p3) +  # Use the new color palette
  scale_y_continuous(expand = expansion(mult = c(0, 0.05)), name = "Percentage of Trials (%)", limits = y_limits) +  
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
  guides(fill = guide_legend(title = "Category", ncol = 2, reverse = TRUE))  # Organize legend alphabetically

# Modify p1 to adjust legend text size
p1 <- p1 + theme(
  legend.text = element_text(size = base_font_size + 2)  # Increase legend text size
)

# Modify p2 to adjust legend text size
p2 <- p2 + theme(
  legend.text = element_text(size = base_font_size + 2)  # Increase legend text size
)

# Modify p3 to adjust legend text size
p3 <- p3 + theme(
  legend.text = element_text(size = base_font_size + 2)  # Increase legend text size
)

# Modify p1 to adjust legend text size and set all fonts to Arial
p1 <- p1 + theme(
  legend.key.width = unit(0.5, "cm"),  # Adjust legend key width
  legend.key.height = unit(0.5, "cm"),  # Adjust legend key height
  legend.spacing = unit(0.1, "cm"),  # Adjust spacing between legend items
  legend.text = element_text(size = base_font_size + 2),  # Increase legend text size
  axis.text.x = element_text(size = base_font_size + 2)  # Increase X-axis label text size
)

# Modify p2 to adjust legend text size, set all fonts to Arial, and adjust X-axis labels
p2 <- p2 + theme(
  legend.key.width = unit(0.5, "cm"),  # Adjust legend key width
  legend.key.height = unit(0.5, "cm"),  # Adjust legend key height
  legend.spacing = unit(0.1, "cm"),  # Adjust spacing between legend items
  legend.text = element_text(size = base_font_size + 2),  # Increase legend text size
  axis.text.x = element_text(size = base_font_size + 2, angle = 0, hjust = 0.5)  # Make X-axis labels horizontal
)

# Modify p3 to adjust legend text size, set all fonts to Arial, and adjust X-axis labels
p3 <- p3 + theme(
  legend.key.width = unit(0.5, "cm"),  # Adjust legend key width
  legend.key.height = unit(0.5, "cm"),  # Adjust legend key height
  legend.spacing = unit(0.1, "cm"),  # Adjust spacing between legend items
  legend.text = element_text(size = base_font_size + 2),  # Increase legend text size
  axis.text.x = element_text(size = base_font_size + 2, angle = 0, hjust = 0.5)  # Make X-axis labels horizontal
)

# Combine the plots
combined_plot <- (p2 + p3) | p1

print(combined_plot)

# Save the combined plot as SVG
ggsave("combined_plot_stack.pdf", plot = combined_plot, device = "pdf")
