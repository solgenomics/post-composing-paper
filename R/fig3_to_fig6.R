getwd()
setwd("~/Desktop/post_composing_paper")

# install.packages("ggthemes")
# install.packages("forcats")
library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)
library(ggthemes)
library(forcats)
#install.packages("ragg")
library(ragg)

###################
# for the fig3 ####
###################

#step 1 reading the file 
fig3 <- read_csv("DB_objects.csv")
# View(fig3)
# str(fig3)

# step2: Reshape the data to long format for easier plotting
fig3_long <- fig3 %>%
  pivot_longer(cols = c(cassava, banana, sweet_potato, yam), names_to = "Crop", values_to = "Ratio") %>%
  mutate(Crop = factor(Crop, levels = c("cassava", "banana", "yam", "sweet_potato"))) %>%
  mutate(Crop = recode(Crop,
                       "cassava" = "Cassava", 
                       "banana" = "Banana", 
                       "yam" = "Yam", 
                       "sweet_potato" = "Sweet Potato"))
View(fig3_long)

#step3: filter the data for cassava, yam and sweeet_potato
fig3_only_three_DB_crops <- fig3_long %>%
  filter(Crop %in% c("Cassava", "Yam", "Sweet Potato"))
# View(fig3_only_three_DB_crops)

# step4: plot the graph for cassava, yam and sweet_potato
x11()
fig3_three_crops <- ggplot(fig3_only_three_DB_crops, aes(x = fct_inorder(database_objects), y = Ratio, fill = Crop)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_ptol()+
  scale_y_continuous(labels = scales::number_format(accuracy = 0.0001)) +
  labs(x = "Database objects",
       y = "Ratios of post/pre-composed traits",
       fill = "") +
  theme_few() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "right")

print(fig3_three_crops)

# step5: save the file
ggsave("Database_objects_three_crops_fig3.tiff" , plot =fig3_three_crops, width = 10, height = 6, dpi = 400, compression = "lzw", device = ragg::agg_tiff)

# Step 6:  filter the data only for banana 
fig3_only_banana <- fig3_long %>%
  filter(Crop %in% c("Banana"))
View(fig3_only_banana)

# custom_colors <- ggthemes::tableau_color_pal("Tableau 20")(20)
# banana_color <- c("Banana" = "#006400")

# step6: Plot the graph for banana only 
x11()
fig3_only_banana <- ggplot(fig3_only_banana, aes(x = fct_inorder(database_objects), y = Ratio, fill = Crop)) +
  geom_bar(stat = "identity", position = "dodge") +
  # scale_fill_ptol()+
  scale_fill_manual(values = c("Banana" = ggthemes::ptol_pal()(4)[2])) + 
  scale_y_continuous(labels = scales::number_format(accuracy = 5.0)) +
  labs(x = "Database objects",
       y = "Ratios of post/pre-composed traits",
       fill = "") +
  theme_few() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "right")

print(fig3_only_banana)

#step6: save the plot
ggsave("Database_objects_banana_fig3.tiff" , plot =fig3_only_banana, width = 10, height = 6, dpi = 400, compression = "lzw", device = ragg::agg_tiff)

###################
# for the fig5 ####
###################

# Step 1: Import the CSV files
spbase <- read_csv("spbase_composed_terms.csv") %>% mutate(crop = "Sweet Potato")
yambase <- read_csv("yambase_composed_terms.csv") %>% mutate(crop = "Yam")
musabase <- read_csv("musabase_composed_terms.csv") %>% mutate(crop = "Banana")
cassava <- read_csv("cassava_composed_terms.csv") %>% mutate(crop = "Cassava")

# Step 2: Combine all datasets
all_crops <- bind_rows(spbase, yambase, musabase, cassava) %>%
  mutate(ontology = if_else(ontology == "cxgn_time_ontology", parent, ontology))

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

# Order crops
top_terms_data$crop <- factor(top_terms_data$crop, levels = c("Cassava", "Banana", "Yam", "Sweet Potato"))

# Step 5: Create a stacked barplot graph for the top 10 terms using Paul Tol's bright color scheme
x11()
fig5_top_10_terms <- ggplot(top_terms_data, aes(x = term, y = percentage, fill = crop)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_fill_ptol() +  # Apply Paul Tol's bright color scheme
  labs(title = "",
       x = "Composable Term",
       y = "Percentage Usage (%)",
       fill = "") +
  theme_classic() +  # Use classic theme for white background and visible axis lines
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.background = element_rect(fill = "white"),  
    panel.grid = element_blank(),  # Remove grid lines
    axis.line = element_line(color = "black"),  
    plot.background = element_rect(fill = "white", color = NA)
  )

print(fig5_top_10_terms)
ggsave("top_10_terms_fig5.tiff", plot = fig5_top_10_terms,  width = 10, height = 6, dpi = 400, compression = "lzw", device = ragg::agg_tiff)

###################
# for the fig4 ####
###################

# Step 6: Calculate percentage usage of each ontology within each crop
data_for_plot <- all_crops %>%
  count(crop, ontology) %>% # Count terms for each crop and name
  group_by(crop) %>%
  mutate(total_terms_in_crop = sum(n), # Calculate total terms in each crop
         percentage = (n / total_terms_in_crop) * 100) %>% # Calculate percentage
  ungroup() %>%
  select(crop, ontology, percentage)

# Order crops
data_for_plot$crop <- factor(data_for_plot$crop, levels = c("Cassava", "Banana", "Yam", "Sweet Potato"))

# Step 7: Create a stacked barplot showing percentage of terms using Paul Tol's bright color scheme
x11()
fig4_orthogonal_ontology <- ggplot(data_for_plot, aes(x = crop, y = percentage, fill = ontology)) +
  geom_bar(stat = "identity", position = "fill") + # Use position="fill" for percentage stack
  scale_fill_ptol() +  # Apply Paul Tol's bright color scheme
  scale_y_continuous(labels = scales::percent_format()) + # Format y-axis as percentage
  labs(title = "",
       x = "Crop",
       y = "Percent Usage (%)",
       fill = "") +
  theme_classic() +  # Use classic theme for white background and visible axis lines
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.background = element_rect(fill = "white"),  
    panel.grid = element_blank(),  
    axis.line = element_line(color = "black"),  
    plot.background = element_rect(fill = "white", color = NA)
  )

print(fig4_orthogonal_ontology)
ggsave("orthogonal_ontology_usage_by_crop_fig4.tiff", plot = fig4_orthogonal_ontology, width = 10, height = 6, dpi = 400, compression = "lzw", device = ragg::agg_tiff)

###################
# for the fig6 ####
###################
#step1: reading the file
fig6 <- read_csv("unique_pre_post.csv")

#step2:crop column to a factor to maintain the order
fig6 <- fig6 %>%
  mutate(Crop = factor(Crop, levels = unique(Crop)))

#step3: calculate the each crop group level percent
percentage_each_group_under_each_crop <- fig6 %>%
  rowwise() %>%
  mutate(each_group_total = unique_post_composed + unique_regular_traits) %>%
  ungroup() %>%
  mutate(percentage_unique_post_composed = (unique_post_composed / each_group_total) * 100,
         percentage_regular_traits = (unique_regular_traits / each_group_total) * 100) %>%
  select(Crop, percentage_unique_post_composed, percentage_regular_traits)

print(percentage_each_group_under_each_crop)

#step4: reshape the data for plotting
plot_data <- percentage_each_group_under_each_crop %>%
  pivot_longer(cols = starts_with("percentage"), 
               names_to = "trait_type", 
               values_to = "percentage") %>%
  mutate(trait_type = recode(trait_type,
                             "percentage_unique_post_composed" = "post-composed traits",
                             "percentage_regular_traits" = "pre-composed traits"))

print(plot_data)

#step5: plotting the graph
x11()
fig6_plot <- ggplot(plot_data, aes(x = Crop, y = percentage / 100,  fill = trait_type)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_fill_ptol() +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(y = "Percentage usage (%)",
       x = "Crop group levels",
       fill = "") +
  theme_few() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "right",
        legend.title = element_blank()) +
  scale_x_discrete(limits = levels(plot_data$Crop))

print(fig6_plot)

#step6: save the graph
ggsave("unique_pre_and_post_composed_traits_fig6.tiff", plot = fig6_plot, width = 10, height = 6, dpi = 400, compression = "lzw", device = ragg::agg_tiff)

# ###################
# # for the fig7 ####
# ###################
# 
# #step1: reading the file
# fig7 <- read_csv("trial_types.csv")
# 
# #step2: calculating the each percentage of each trial types of each crop
# percent_all_trial_types <- fig7 %>%
#   rowwise() %>%
#   mutate(each_trial_type = cassava + banana + yam + sweet_potato) %>%
#   ungroup() %>%
#   mutate(cassava_percent_each_trial_type = (cassava/each_trial_type) * 100,
#          banana_percent_each_trial_type = (banana/each_trial_type) * 100,
#          yam_percent_each_trial_type = (yam/each_trial_type) * 100,
#          sweet_potato_each_trial_type = (sweet_potato/each_trial_type) * 100) %>%
#   select(trial_type_name, cassava_percent_each_trial_type, banana_percent_each_trial_type, yam_percent_each_trial_type,sweet_potato_each_trial_type)
# 
# print(percent_all_trial_types)
# 
# #step3:Reshape the data for plotting
# plot_data <- percent_all_trial_types %>%
#   pivot_longer(cols =  c(cassava_percent_each_trial_type, banana_percent_each_trial_type, yam_percent_each_trial_type, sweet_potato_each_trial_type), 
#                names_to = "unique_crops", 
#                values_to = "percentage") %>%
#   mutate(unique_crops = recode(unique_crops,
#                                   "cassava_percent_each_trial_type" = "Cassava",
#                                   "banana_percent_each_trial_type" = "Banana",
#                                   "yam_percent_each_trial_type" = "Yam",
#                                   "sweet_potato_each_trial_type" = "Sweet Potato"))
# 
# #step4: maintian the order of crops as per the column headers in dataset
# plot_data$unique_crops = factor(plot_data$unique_crops, level=c("Cassava", "Banana", "Yam", "Sweet Potato"))
# 
# #step5: plotting the graph
# x11()
# fig7_plot <- ggplot(plot_data, aes(x = trial_type_name, y = percentage / 100, fill = unique_crops)) +
#   geom_bar(stat = "identity", position = "fill") +
#   scale_fill_ptol() +
#   scale_y_continuous(labels = scales::percent_format()) +
#   labs(x = "Trial types",
#        y = "Percentage usage(%) ",
#        fill = "unique crops") +
#   theme_few() +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1),
#         legend.position = "right")
# 
# print(fig7_plot)
# 
# #step6: save the plot
# ggsave("trial types.png" , plot =fig7_plot, width = 10, height = 6)