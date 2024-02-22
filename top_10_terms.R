library(dplyr)
library(ggplot2)
library(readr)

# Step 1: Import the CSV files
spbase <- read_csv("spbase_composed_terms.csv") %>% mutate(crop = "Sweet Potato")
yambase <- read_csv("yambase_composed_terms.csv") %>% mutate(crop = "Yam")
musabase <- read_csv("musabase_composed_terms.csv") %>% mutate(crop = "Banana")
cassava <- read_csv("cassava_composed_terms.csv") %>% mutate(crop = "Cassava")

# Step 2: Combine all datasets and replace 'subject' with 'term'
all_crops <- bind_rows(spbase, yambase, musabase, cassava) %>%
  rename(term = subject)

# Step 3: Calculate the percentage usage of each term within each crop
percentage_use_within_crop <- all_crops %>%
  count(crop, term) %>%
  group_by(crop) %>%
  mutate(crop_total = sum(n)) %>%
  ungroup() %>%
  mutate(percentage = (n / crop_total) * 100) %>%
  select(-n, -crop_total)

# Step 4: Calculate the summed percentage across crops for each term
total_percentage_use <- percentage_use_within_crop %>%
  group_by(term) %>%
  summarise(total_percentage = sum(percentage)) %>%
  ungroup() %>%
  arrange(desc(total_percentage)) %>%
  top_n(10, total_percentage)

# Filter the original percentages for only the top 10 terms
top_terms_data <- percentage_use_within_crop %>%
  filter(term %in% total_percentage_use$term)

# Order terms based on their total usage percentage
top_terms_data <- top_terms_data %>%
  mutate(term = factor(term, levels = total_percentage_use$term))

# Step 5: Create a stacked barplot graph for the top 10 terms
ggplot(top_terms_data, aes(x = term, y = percentage, fill = crop)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(title = "Top 10 Terms by Percent Usage in Composed Traits Across Databases",
       x = "Composable Term",
       y = "Percentage Usage (%)",
       fill = "Crop") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Save the plot
ggsave("top_10_terms.png", width = 10, height = 8, dpi = 300)
