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

###################
# for the fig5 ####
###################
#step1: reading the file
fig5 <- read_csv("unique_pre_post.csv")

#step2:crop column to a factor to maintain the order
fig5 <- fig5 %>%
  mutate(Crop = factor(Crop, levels = unique(Crop)))

#step3: calculate the each crop group level percent
percentage_each_group_under_each_crop <- fig5 %>%
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
fig5_plot <- ggplot(plot_data, aes(x = Crop, y = percentage / 100,  fill = trait_type)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_fill_ptol() +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(y = "Percentage usage (%)",
       x = "Crop group levels",
       fill = "trial type") +
  theme_few() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "right") +
  scale_x_discrete(limits = levels(plot_data$Crop))

print(fig5_plot)

#step6: save the graph
ggsave("unique pre- and post-composed traits.png", plot = fig5_plot, width = 10, height = 6)

######################
# for the fig6 #######
######################

#step 1 reading the file 
fig6 <- read_csv("DB_objects.csv")

#step2 calculating the each DB_objects by each crop in percent
percent_all_DB_objects <- fig6 %>%
  rowwise() %>%
  mutate(DB_object_total = cassava + banana + yam + sweet_potato) %>%
  ungroup() %>%
  mutate(cassava_percent_each_db_objects = (cassava / DB_object_total) * 100,
         banana_percent_each_db_objects = (banana / DB_object_total) * 100, 
         yam_percent_each_db_objects = (yam / DB_object_total) * 100,
         sweet_potato_percent_each_db_objects = (sweet_potato / DB_object_total) * 100) %>%
  select(database_objects, cassava_percent_each_db_objects, banana_percent_each_db_objects, yam_percent_each_db_objects, sweet_potato_percent_each_db_objects)
print(percent_all_DB_objects)

# step3: Reshape the data for plotting
plot_data <- percent_all_DB_objects %>%
  pivot_longer(cols =  c(cassava_percent_each_db_objects, banana_percent_each_db_objects, yam_percent_each_db_objects, sweet_potato_percent_each_db_objects), 
               names_to = "different_crops", 
               values_to = "percentage") %>%
  mutate(different_crops = recode(different_crops,
                             "cassava_percent_each_db_objects" = "Cassava",
                             "banana_percent_each_db_objects" = "Banana",
                             "yam_percent_each_db_objects" = "Yam",
                             "sweet_potato_percent_each_db_objects" = "Sweet Potato"))

#step4: maintian the order of crops as the column headers in the dataset
plot_data$different_crops <- factor(plot_data$different_crops, levels = c("Cassava", "Banana", "Yam", "Sweet Potato"))
print(plot_data)

#step5: here, plotting the graph
x11()
fig6_plot <- ggplot(plot_data, aes(x = database_objects, y = percentage / 100, fill = different_crops)) +
  geom_bar(stat = "identity", position = "fill") +
  scale_fill_ptol() +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(x = "Database objects",
       y = "Percentage usage (%) ",
       fill = "different crops") +
  theme_few() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "right")

print(fig6_plot)

#step6: save the plot
ggsave("Database objects.png" , plot =fig6_plot, width = 10, height = 6)

###################
# for the fig7 ####
###################

#step1: reading the file
fig7 <- read_csv("trial_types.csv")

#step2: calculating the each percentage of each trial types of each crop
percent_all_trial_types <- fig7 %>%
  rowwise() %>%
  mutate(each_trial_type = cassava + banana + yam + sweet_potato) %>%
  ungroup() %>%
  mutate(cassava_percent_each_trial_type = (cassava/each_trial_type) * 100,
         banana_percent_each_trial_type = (banana/each_trial_type) * 100,
         yam_percent_each_trial_type = (yam/each_trial_type) * 100,
         sweet_potato_each_trial_type = (sweet_potato/each_trial_type) * 100) %>%
  select(trial_type_name, cassava_percent_each_trial_type, banana_percent_each_trial_type, yam_percent_each_trial_type,sweet_potato_each_trial_type)

print(percent_all_trial_types)

#step3:Reshape the data for plotting
plot_data <- percent_all_trial_types %>%
  pivot_longer(cols =  c(cassava_percent_each_trial_type, banana_percent_each_trial_type, yam_percent_each_trial_type, sweet_potato_each_trial_type), 
               names_to = "unique_crops", 
               values_to = "percentage") %>%
  mutate(unique_crops = recode(unique_crops,
                                  "cassava_percent_each_trial_type" = "Cassava",
                                  "banana_percent_each_trial_type" = "Banana",
                                  "yam_percent_each_trial_type" = "Yam",
                                  "sweet_potato_each_trial_type" = "Sweet Potato"))

#step4: maintian the order of crops as per the column headers in dataset
plot_data$unique_crops = factor(plot_data$unique_crops, level=c("Cassava", "Banana", "Yam", "Sweet Potato"))

#step5: plotting the graph
x11()
fig7_plot <- ggplot(plot_data, aes(x = trial_type_name, y = percentage / 100, fill = unique_crops)) +
  geom_bar(stat = "identity", position = "fill") +
  scale_fill_ptol() +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(x = "Trial types",
       y = "Percentage usage(%) ",
       fill = "unique crops") +
  theme_few() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "right")

print(fig7_plot)

#step6: save the plot
ggsave("trial types.png" , plot =fig7_plot, width = 10, height = 6)