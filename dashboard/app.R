# DS project: Predictive Analytics for Phishing Website Detection
# group 7: Nervindraj, Haridvarna, Rithish, Riknesh 
library(shiny)
library(shinydashboard)
library(tidyverse)
library(randomForest)
library(caret)
library(cluster)
library(DT)#colour table

#load and preprocess
data <- read.csv("D:/UNI FILES/DataScienceGroupAssignment/phishing (1).csv")
data_clean <- data %>% select(-Index) %>% mutate(class = as.factor(class))

#training
set.seed(42)
trainIndex <- createDataPartition(data_clean$class, p = 0.8, list = FALSE)
train_data <- data_clean[trainIndex, ]
test_data  <- data_clean[-trainIndex, ]

#random forest
rf_model <- randomForest(class ~ ., data = train_data, ntree = 100, importance = TRUE)

#pediction and confusion
predictions <- predict(rf_model, test_data)
conf_matrix <- confusionMatrix(predictions, test_data$class)

#accuracy
model_accuracy <- round(conf_matrix$overall['Accuracy'] * 100, 2)

#kmeans
phishing_sites <- data_clean %>% filter(class == "-1") %>% select(-class)
set.seed(42)
clusters <- kmeans(phishing_sites, centers = 3, nstart = 25)
phishing_sites$Cluster <- as.factor(clusters$cluster)


#ui
ui <- dashboardPage(
  skin = "blue",
  dashboardHeader(title = "G7: Phishing Detector"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("1. Project Overview", tabName = "overview", icon = icon("info-circle")),
      menuItem("2. Methodology", tabName = "methodology", icon = icon("cogs")),
      menuItem("3. Model Evaluation", tabName = "evaluation", icon = icon("chart-pie")),
      menuItem("4. Attack Profiles", tabName = "profiles", icon = icon("users-cog")),
      menuItem("5. Live Demo", tabName = "predictor", icon = icon("play-circle"))
    )
  ),
  dashboardBody(
    tabItems(
      
      #1.overview 
      tabItem(tabName = "overview",
              fluidRow(
                box(title = "Predictive Analytics for Phishing Detection", width = 12, solid_header = TRUE, status = "primary",
                    h3("Welcome to our Data Science Dashboard"),
                    p("Phishing attacks remain one of the most prevalent cybersecurity threats. Our group developed a machine learning pipeline to automatically classify URLs as legitimate or malicious based on their technical characteristics."),
                    hr(),
                    fluidRow(
                      column(6,
                             h4(icon("bullseye"), " Project Objectives"),
                             tags$ul(
                               tags$li("Build a highly accurate predictive model to detect phishing websites."),
                               tags$li("Identify the most critical technical red flags used by attackers."),
                               tags$li("Segment malicious websites into distinct 'Attack Profiles' to understand common threat strategies.")
                             )
                      ),
                      column(6,
                             h4(icon("database"), " The Dataset"),
                             tags$ul(
                               tags$li("Over 11,000 instances of classified URLs."),
                               tags$li("Features include URL structure, SSL certificate status, and domain registration details."),
                               tags$li("Target Variable: Class (1 = Legitimate, -1 = Phishing)")
                             )
                      )
                    ),
                    hr(),
                    h4("Developed by Group 7:"),
                    p("Nervindraj | Haridvarna | Rithish | Riknesh")
                )
              )
      ),
      
      #2.methodology 
      tabItem(tabName = "methodology",
              fluidRow(
                box(title = "Our Data Science Pipeline", width = 12, solid_header = TRUE, status = "info",
                    fluidRow(
                      column(4,
                             h4("1. Data Preprocessing"),
                             p("We cleaned the dataset by removing non-predictive identifiers (like the Index column) and factoring our target variable. We then applied an 80/20 train-test split to ensure our model could be evaluated on unseen data.")
                      ),
                      column(4,
                             h4("2. Predictive Modeling"),
                             p("We selected a ", strong("Random Forest Classifier"), " configured with 100 decision trees. Random Forest was chosen for its robustness against overfitting and its ability to rank feature importance.")
                      ),
                      column(4,
                             h4("3. Unsupervised Learning"),
                             p("We isolated the confirmed phishing websites and applied ", strong("K-Means Clustering (k=3)"), " to discover hidden groupings and define specific threat profiles.")
                      )
                    )
                )
              )
      ),
      
      #3.model evaluation 
      tabItem(tabName = "evaluation",
              fluidRow(
                valueBox(paste0(model_accuracy, "%"), "Overall Model Accuracy", icon = icon("check-double"), color = "green", width = 12)
              ),
              fluidRow(
                box(title = "Top Phishing Red Flags", width = 6, status = "warning",
                    plotOutput("importancePlot"),
                    footer = "Features with a higher Mean Decrease Gini are the strongest indicators of fraud."),
                
                box(title = "Confusion Matrix", width = 6, status = "success",
                    plotOutput("confMatrixPlot"),
                    footer = "Visualizing the predictions on the 20% testing data (-1 = Phishing, 1 = Legitimate).")
              )
      ),
      
      #4.attack profiles 
      tabItem(tabName = "profiles",
              fluidRow(
                box(title = "K-Means Phishing Attack Profiles", width = 12, status = "danger", solid_header = TRUE,
                    p("By clustering only the malicious websites, we identified 3 distinct operational strategies used by threat actors. The table below represents the centroid (average feature value) for each cluster."),
                    
                    # Interactive DT Output
                    DTOutput("clusterTable"),
                    
                    hr(),
                    h4("Presenter Notes:"),
                    p("Look for distinct differences between the clusters. ", 
                      strong(span(style="color:red", "Red cells")), " indicate a strong phishing signature (closer to -1) for that specific feature, while ", 
                      strong(span(style="color:green", "Green cells")), " indicate mimicking legitimate behavior. For example, one cluster might represent 'Zero-Day' attacks with completely invalid SSLs (dark red), while another might represent sophisticated clones that use valid SSLs but suspicious anchor tags.")
                )
              )
      ),
      
      #5.real-time predictor 
      tabItem(tabName = "predictor",
              fluidRow(
                box(title = "Input URL Features", width = 4, solid_header = TRUE, status = "primary",
                    helpText("Let's test the model live. Adjust these top markers to see how the Random Forest evaluates risk in real-time."),
                    selectInput("https", "SSL Certificate Status (HTTPS):", 
                                choices = c("Valid (1)" = 1, "Suspicious (0)" = 0, "Invalid (-1)" = -1)),
                    selectInput("anchor", "Unsafe Anchor URLs (%):", 
                                choices = c("Low (1)" = 1, "Medium (0)" = 0, "High (-1)" = -1)),
                    selectInput("prefix", "URL contains Dash (-):", 
                                choices = c("No (1)" = 1, "Yes (-1)" = -1)),
                    actionButton("predict", "Analyze Website", class = "btn-success", icon = icon("search"))
                ),
                box(title = "Prediction Result", width = 8, solid_header = TRUE, status = "info",
                    valueBoxOutput("resultBox", width = 12),
                    hr(),
                    h4("Data-Driven Explanation:"),
                    textOutput("reasoning")
                )
              )
      )
    )
  )
)





#server
server <- function(input, output) {
  
  #predictor logic
  prediction_val <- eventReactive(input$predict, {
    test_row <- data_clean[1, ] %>% select(-class)
    test_row$HTTPS <- as.numeric(input$https)
    test_row$AnchorURL <- as.numeric(input$anchor)
    test_row$PrefixSuffix. <- as.numeric(input$prefix)
    
    predict(rf_model, test_row)
  })
  
  output$resultBox <- renderValueBox({
    res <- prediction_val()
    if(res == 1) {
      valueBox("Safe", "Legitimate Website", icon = icon("check-circle"), color = "green")
    } else {
      valueBox("Danger", "Phishing Detected", icon = icon("exclamation-triangle"), color = "red")
    }
  })
  
  output$reasoning <- renderText({
    res <- prediction_val()
    if(res == -1) {
      "Warning: The inputted features match the statistical signatures of known phishing infrastructure in our training dataset."
    } else {
      "Result: The technical markers align with established legitimate domain behavior."
    }
  })
  
  #eval logic
  output$importancePlot <- renderPlot({
    imp <- as.data.frame(importance(rf_model))
    imp$Feature <- rownames(imp)
    top_imp <- imp %>% arrange(desc(MeanDecreaseGini)) %>% head(10)
    
    ggplot(top_imp, aes(x = reorder(Feature, MeanDecreaseGini), y = MeanDecreaseGini)) +
      geom_bar(stat = "identity", fill = "#f39c12") +
      coord_flip() + labs(x = "URL Attribute", y = "Statistical Significance (Gini)") +
      theme_minimal(base_size = 14)
  })
  
  output$confMatrixPlot <- renderPlot({
    cm_table <- as.data.frame(conf_matrix$table)
    ggplot(cm_table, aes(Prediction, Reference, fill = Freq)) +
      geom_tile() +
      geom_text(aes(label = Freq), color = "white", size = 8, fontface = "bold") +
      scale_fill_gradient(low = "#2ecc71", high = "#27ae60") +
      labs(x = "Predicted Class", y = "Actual Class") +
      theme_minimal(base_size = 14)
  })
  
  #cluster logic + COLOUR
  output$clusterTable <- renderDT({
    
    summary_df <- phishing_sites %>%
      group_by(Cluster) %>%
      summarise(across(everything(), mean)) %>%
      mutate(across(where(is.numeric), ~round(., 2)))
    
    
    feature_cols <- names(summary_df)[-1]
    
    #data table
    datatable(summary_df, 
              options = list(dom = 't', scrollX = TRUE, ordering = FALSE), 
              rownames = FALSE,
              class = 'cell-border stripe') %>%
      #highlight w clour
      formatStyle(
        columns = feature_cols,
        backgroundColor = styleInterval(c(-0.5, 0.5), c('#ff9999', '#ffffcc', '#ccffcc')),
        fontWeight = styleInterval(c(-0.5, 0.5), c('bold', 'normal', 'normal'))
      )
  })
}

shinyApp(ui, server)