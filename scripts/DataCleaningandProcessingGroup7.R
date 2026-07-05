# DS project: Predictive Analytics for Phishing Website Detection
# group 7: Nervindraj, Haridvarna, Rithish, Riknesh 


#load libraries
library(tidyverse)
library(randomForest)
library(caret)
library(cluster)
library(reshape2)

#load dataset
data <- read.csv("D:/UNI FILES/DataScienceGroupAssignment/phishing (1).csv")

#data preprocessing
#(-1 = phishing, 1 = legitimate)
data_clean <- data %>%
  select(-Index) %>%
  mutate(class = as.factor(class))

#training(80%) // testing(20%)
set.seed(42)
trainIndex <- createDataPartition(data_clean$class, p = 0.8, list = FALSE)
train_data <- data_clean[trainIndex, ]
test_data  <- data_clean[-trainIndex, ]

#predictive modeling (random forest)

rf_model <- randomForest(class ~ ., data = train_data, ntree = 100, importance = TRUE)

#model
predictions <- predict(rf_model, test_data)
conf_matrix <- confusionMatrix(predictions, test_data$class)
print(conf_matrix)

#feature importance
importance_df <- as.data.frame(importance(rf_model))
importance_df$Feature <- rownames(importance_df)

p1 <- ggplot(importance_df, aes(x = reorder(Feature, MeanDecreaseGini), y = MeanDecreaseGini)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  labs(title = "Top Feature Importance for Phishing Detection") +
  theme_minimal()
print(p1)

#segmentation
phishing_sites <- data_clean %>% 
  filter(class == -1) %>% 
  select(-class)

set.seed(42)
clusters <- kmeans(phishing_sites, centers = 3, nstart = 25)
phishing_sites$Cluster <- as.factor(clusters$cluster)

cluster_summary <- phishing_sites %>%
  group_by(Cluster) %>%
  summarise(across(everything(), mean))

print("Phishing Attack Profiles (Mean Feature Values):")
print(cluster_summary)

#confusion matrix
cm_table <- as.data.frame(conf_matrix$table)
p2 <- ggplot(cm_table, aes(Prediction, Reference, fill = Freq)) +
  geom_tile() +
  geom_text(aes(label = Freq), color = "white") +
  scale_fill_gradient(low = "lightblue", high = "darkblue") +
  theme_minimal()
print(p2)

#save importance grapgh
ggsave("Feature_Importance.png", plot = p1, width = 10, height = 8)

#save confusion matrix
ggsave("Confusion_Matrix.png", plot = p2, width = 8, height = 6)

