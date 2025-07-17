# Load libraries
library(tidyverse)
library(showtext)
library(sysfonts)

# Load Montserrat font from Google Fonts
font_add_google(name = "Montserrat", family = "Montserrat")
showtext_auto()

# Set global font theme
theme_set(theme_minimal(base_family = "Montserrat"))

# Load CSV
df <- read_csv("Bus_Breakdown_and_Delays_20250707.csv", show_col_types = FALSE)

# Preprocess date
df$Occurred_On <- as.POSIXct(df$Occurred_On, format = "%m/%d/%Y %I:%M:%S %p")
df$year <- format(df$Occurred_On, "%Y")
df$month <- format(df$Occurred_On, "%m")

# ========== PLOT 1: Monthly Heavy Traffic Delays in Manhattan ==========
df_jan_june <- df %>%
  filter(month %in% c("01", "02", "03", "04", "05", "06"),
         Boro == "Manhattan",
         Reason == "Heavy Traffic")

df_summary1 <- df_jan_june %>%
  group_by(year, month) %>%
  summarise(count = n(), .groups = "drop")

df_summary1$month <- factor(df_summary1$month, levels = sprintf("%02d", 1:6),
                            labels = c("Jan", "Feb", "Mar", "Apr", "May", "June"))

plot1 <- ggplot(df_summary1, aes(x = month, y = count, fill = year)) +
  geom_col(position = "dodge") +
  labs(
    title = "Heavy Traffic Delays on NYC School Buses in Manhattan\nBefore and After Congestion Pricing (2024 vs. 2025)",
    x = "Month",
    y = "Number of Delays"
  )

ggsave("/Users/ashleylee/Downloads/monthly_delays.svg", plot = plot1, width = 8, height = 5)

# ========== PLOT 2: Percent Change Manhattan vs. Other Boroughs ==========
df$boro_group <- ifelse(df$Boro == "Manhattan", "Manhattan", "Other Boroughs")

df_filtered2 <- df %>%
  filter(month %in% c("01", "02", "03", "04", "05", "06"),
         Reason == "Heavy Traffic")

df_summary2 <- df_filtered2 %>%
  group_by(boro_group, year) %>%
  summarise(total_delays = n(), .groups = "drop")

df_wide <- pivot_wider(df_summary2,
                       names_from = year,
                       values_from = total_delays,
                       names_prefix = "year_") %>%
  mutate(percent_change = (year_2025 - year_2024) / year_2024 * 100) %>%
  filter(!is.na(percent_change))

plot2 <- ggplot(df_wide, aes(x = boro_group, y = percent_change, fill = boro_group)) +
  geom_col(width = 0.6) +
  geom_text(
    aes(label = sprintf("%.1f%%", percent_change)),
    hjust = ifelse(df_wide$percent_change > 0, -0.1, 1.1),
    size = 3
  ) +
  scale_y_continuous(limits = c(-60, 10)) +
  labs(
    title = "Percentage Change in School Bus Delays \nManhattan vs. Other Boroughs",
    x = NULL,
    y = "Percent Change"
  ) +
  coord_flip()

ggsave("/Users/ashleylee/Downloads/percent_change_by_boro.svg", plot = plot2, width = 8, height = 5)

# ========== PLOT 3: Delay Durations in Manhattan ==========
df_filtered3 <- df %>%
  filter(month %in% c("01", "02", "03", "04", "05", "06"),
         Reason == "Heavy Traffic",
         Boro == "Manhattan")

df_summary3 <- df_filtered3 %>%
  group_by(How_Long_Delayed, year) %>%
  summarise(count = n(), .groups = "drop") %>%
  filter(!is.na(How_Long_Delayed))

df_summary3$How_Long_Delayed <- factor(df_summary3$How_Long_Delayed,
                                       levels = c("0-15 Min", "16-30 Min", "31-45 Min", "46-60 Min",
                                                  "61-90 Min", "91-120 Min", "Over 120 Min"))

plot3 <- ggplot(df_summary3, aes(x = How_Long_Delayed, y = count, fill = year)) +
  geom_col(position = "dodge") +
  labs(
    title = "Heavy Traffic School Bus Delays in Manhattan (Jan–June)",
    subtitle = "Number of reported delays by duration, comparing 2024 and 2025",
    x = "Delay Duration",
    y = "Number of Delays"
  )

ggsave("/Users/ashleylee/Downloads/delay_duration_comparison.svg", plot = plot3, width = 8, height = 5)
