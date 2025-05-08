# Load and Install Required Libraries and packages
library(tidyverse)
library(ggplot2)
library(gt)

install.packages(c("caret", "rpart", "rpart.plot"))
library(caret)
library(rpart)
library(rpart.plot)

# Inspect the First Few Rows of Each Dataset
head(clinical_study)
head(protein_levels)

# Rename Columns for Consistency
clinical_study <- rename(clinical_study, participant_id = subject_id)
head(clinical_study)


#Data_Cleaning

## Remove Pediatric Participants (Under 18)
clinical_study <- filter(clinical_study, age >= 18)

## Remove Duplicate Rows
clinical_study <- distinct(clinical_study)

## Replace NA with Mean Value
clinical_study$weight <- as.numeric(clinical_study$weight)
clinical_study$weight[is.na(clinical_study$weight)] <- mean(clinical_study$weight, na.rm = TRUE)

## Replace NA with mean value
protein_levels$protein_concentration <- as.numeric(protein_levels$protein_concentration)
protein_levels$protein_concentration[is.na(protein_levels$protein_concentration)] <- 
  mean(protein_levels$protein_concentration, na.rm = TRUE)

## Calculate BMI
clinical_study <- clinical_study %>%
  mutate(BMI = weight / height^2)

## Merge Datasets on Participant ID
merged_data <- left_join(
  clinical_study,
  protein_levels,
  by = "participant_id"
)

head(merged_data, n=20)



# Exploratory Summary Statistics


## Mean Age by Treatment Group
merged_data %>%
  group_by(trt_grp) %>%
  summarise(mean_age = mean(age, na.rm = TRUE))

## Mean Weight by Response
merged_data %>%
  group_by(RESPONSE) %>%
  summarise(mean_weight = mean(weight, na.rm = TRUE))

## Count of Responses by Treatment Group
merged_data %>%
  group_by(trt_grp, RESPONSE) %>%
  summarise(count = n())

## Mean Age by Response Status
merged_data %>%
  group_by(RESPONSE) %>%
  summarise(mean_age = mean(age, na.rm = TRUE))

## Mean Protein Concentration by Response
merged_data %>%
  group_by(RESPONSE) %>%
  summarise(mean_protein_concentration = mean(protein_concentration, na.rm = TRUE))

## Mean Protein Concentration by Treatment & Response
merged_data %>%
  group_by(trt_grp, RESPONSE) %>%
  summarise(mean_protein_concentration = mean(protein_concentration, na.rm = TRUE))


# Visualisations


## Boxplot: Age by Response
ggplot(merged_data, aes(x = RESPONSE, y = age)) +
  geom_boxplot(fill = "#69b3a2") +
  labs(title = "Age by Treatment Response", x = "Response", y = "Age") +
  theme_minimal()

## Faceted Age by Response and Treatment
ggplot(merged_data, aes(x = RESPONSE, y = age, fill = trt_grp)) +
  geom_boxplot() +
  facet_wrap(~ trt_grp) +
  labs(title = "Age by Response and Treatment Group", x = "Response", y = "Age") +
  theme_minimal()

## Boxplot: BMI by Response
ggplot(merged_data, aes(x = RESPONSE, y = BMI)) +
  geom_boxplot(fill = "#f08080") +
  labs(title = "BMI by Treatment Response", x = "Response", y = "BMI") +
  theme_minimal()

## Faceted BMI by Response and Treatment Group
ggplot(merged_data, aes(x = RESPONSE, y = BMI, fill = trt_grp)) +
  geom_boxplot() +
  facet_wrap(~ trt_grp) +
  labs(title = "BMI by Response and Treatment Group", x = "Response", y = "BMI") +
  theme_minimal()

## Boxplot: Protein Concentration by Response
ggplot(merged_data, aes(x = RESPONSE, y = protein_concentration)) +
  geom_boxplot(fill = "#87ceeb") +
  labs(title = "Protein Concentration by Treatment Response", 
       x = "Response", y = "Protein Concentration") +
  theme_minimal()

## Faceted Protein Concentration by Response and Treatment
ggplot(merged_data, aes(x = RESPONSE, y = protein_concentration, fill = trt_grp)) +
  geom_boxplot() +
  facet_wrap(~ trt_grp) +
  labs(title = "Protein Concentration by Response and Treatment Group",
       x = "Response", y = "Protein Concentration") +
  theme_minimal()

# Summary Table: Response Rates by Treatment Group
summary_table <- merged_data %>%
  group_by(trt_grp, RESPONSE) %>%
  summarise(count = n(), .groups = "drop") %>%
  tidyr::pivot_wider(names_from = RESPONSE, values_from = count, values_fill = 0) %>%
  mutate(
    Total = N + Y,
    `Response Rate (%)` = round((Y / Total) * 100, 1)
  )

## Format Summary Table with gt
summary_table %>%
  gt() %>%
  tab_header(title = "Response Comparison by Treatment Group") %>%
  cols_label(
    trt_grp = "Treatment Group",
    N = "Did Not Respond (N)",
    Y = "Responded (Y)",
    Total = "Total",
    `Response Rate (%)` = "Response Rate (%)"
  )

# Save Final_clean Dataset
write.csv(merged_data, "merged_data.csv", row.names = FALSE)


#Data Modelling



# Prepare the data
# Select only relevant features (exclude participant_id and other identifiers)
model_data <- merged_data %>%
  select(RESPONSE, age, BMI, protein_concentration, trt_grp) %>%
  mutate(RESPONSE = as.factor(RESPONSE),
         trt_grp = as.factor(trt_grp))  

# Split into training and test sets (80% train, 20% test)
set.seed(123)  
train_index <- createDataPartition(model_data$RESPONSE, p = 0.8, list = FALSE)
train_data <- model_data[train_index, ]
test_data <- model_data[-train_index, ]

# Train a decision tree model
tree_model <- rpart(RESPONSE ~ ., data = train_data, method = "class")

# Plot the decision tree
rpart.plot(tree_model, type = 3, extra = 104, fallen.leaves = TRUE)

# Predict on the test set
predictions <- predict(tree_model, newdata = test_data, type = "class")

# Evaluate the model
confusionMatrix(predictions, test_data$RESPONSE)



































