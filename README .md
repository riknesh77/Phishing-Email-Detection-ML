# Phishing Email Detection - Data Science Group 7 Assignment

## 📊 Project Overview

This project develops and evaluates machine learning models for detecting phishing emails. The analysis includes data cleaning, exploratory data analysis, feature importance analysis, clustering, and an interactive Shiny dashboard for visualization and predictions.

**Key Features:**
- Comprehensive data cleaning and preprocessing pipeline
- Machine learning classification models with performance evaluation
- Feature importance analysis and visualization
- Customer segmentation through clustering analysis
- Interactive Shiny dashboard for exploration and predictions

---

## 📁 Project Structure

```
DataScienceGroup7Assignment/
├── README.md                          # This file
├── .gitignore                         # Git ignore rules
├── data/
│   └── phishing.csv                   # Raw phishing dataset
├── scripts/
│   └── DataCleaningandProcessingGroup7.R  # Data processing & analysis
├── dashboard/
│   └── app.R                          # Interactive Shiny dashboard
├── visualizations/
│   ├── Feature_Importance.png         # Model feature importance plot
│   └── Confusion_Matrix.png           # Classification performance matrix
└── results/
    └── Cluster_Mean_Table.csv         # Clustering summary statistics
```

---

## 🎯 Key Findings

- **Dataset**: Phishing email classification dataset with multiple features
- **Clustering**: Customer/email segmentation with statistical summaries
- **Model Performance**: Classification metrics evaluated via confusion matrix
- **Feature Analysis**: Top predictive features identified and ranked

---

## 🚀 Getting Started

### Prerequisites

- **R** (version 3.6 or higher)
- **RStudio** (recommended for running scripts and dashboard)

### Required R Packages

```R
install.packages(c(
  "tidyverse",      # Data manipulation
  "ggplot2",        # Visualization
  "dplyr",          # Data wrangling
  "shiny",          # Interactive dashboard
  "caret",          # Machine learning
  "corrplot",       # Correlation plots
  "cluster"         # Clustering analysis
))
```

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/YourUsername/DataScienceGroup7Assignment.git
   cd DataScienceGroup7Assignment
   ```

2. **Install dependencies**
   - Open `scripts/DataCleaningandProcessingGroup7.R` in RStudio
   - Install required packages (see above)

3. **Run the analysis**
   - Execute the script in `scripts/DataCleaningandProcessingGroup7.R`
   - This generates visualizations and results

---

## 📊 Running the Interactive Dashboard

The project includes a **Shiny dashboard** for interactive exploration:

### Option 1: RStudio
1. Open `dashboard/app.R` in RStudio
2. Click the **Run App** button (top right)

### Option 2: R Console
```R
library(shiny)
setwd("path/to/DataScienceGroup7Assignment")
runApp("dashboard/app.R")
```

The dashboard will open in your browser at `http://localhost:3838`

---

## 📈 Analysis Workflow

1. **Data Loading & Exploration** → Load phishing dataset
2. **Data Cleaning & Preprocessing** → Handle missing values, encode variables
3. **Exploratory Data Analysis** → Visualize distributions and relationships
4. **Feature Engineering** → Create derived features if needed
5. **Model Development** → Train classification models
6. **Model Evaluation** → Confusion matrix, accuracy, precision, recall
7. **Clustering Analysis** → Customer/email segmentation
8. **Visualization & Dashboard** → Create interactive dashboard

---

## 📁 File Descriptions

| File | Purpose |
|------|---------|
| `data/phishing.csv` | Raw dataset with email features and phishing labels |
| `scripts/DataCleaningandProcessingGroup7.R` | Main analysis script (data processing, modeling, clustering) |
| `dashboard/app.R` | Interactive Shiny dashboard for exploration |
| `visualizations/Feature_Importance.png` | Bar plot of most important predictive features |
| `visualizations/Confusion_Matrix.png` | Classification performance matrix visualization |
| `results/Cluster_Mean_Table.csv` | Cluster statistics and centroids |

---

## 🔍 Model Performance

**Classification Results:**
- View the **Confusion_Matrix.png** for detailed model performance metrics
- Metrics include: Accuracy, Precision, Recall, F1-Score

**Feature Importance:**
- Top predictive features shown in **Feature_Importance.png**
- Indicates which variables are most useful for detecting phishing

---


## 📝 Methods & Technologies

- **Language**: R
- **Data Processing**: dplyr, tidyverse
- **Visualization**: ggplot2
- **Machine Learning**: caret, built-in ML algorithms
- **Dashboard**: Shiny
- **Clustering**: K-means, hierarchical clustering

---

## 🚨 Important Notes

1. **File Paths**: All paths in scripts are relative to the project root
2. **Data Privacy**: Ensure dataset doesn't contain sensitive information before sharing
3. **Reproducibility**: Set random seeds in scripts for consistent results
4. **Updates**: If updating data or models, ensure all visualizations and results are regenerated

---

## 📚 Usage Tips

### Running Individual Sections
```R
# Load data
phishing_data <- read.csv("data/phishing.csv")

# View structure
str(phishing_data)
head(phishing_data)

# Source the full analysis
source("scripts/DataCleaningandProcessingGroup7.R")
```

### Modifying the Dashboard
Edit `dashboard/app.R` to:
- Add new visualizations
- Change themes and styling
- Add interactive filters
- Modify layout

---

## 🐛 Troubleshooting

**Dashboard won't start?**
- Ensure all required packages are installed
- Check file paths are correct
- Restart R session

**Missing data files?**
- Verify `data/phishing.csv` exists in the correct folder
- Check file permissions

**Visualizations not generating?**
- Ensure ggplot2 is installed and loaded
- Check file write permissions in `visualizations/` folder

---

## 📖 References & Resources

- [R Data Science Guide](https://r4ds.had.co.nz/)
- [Shiny Tutorial](https://shiny.rstudio.com/tutorial/)
- [ggplot2 Documentation](https://ggplot2.tidyverse.org/)
- [Machine Learning in R](https://www.analyticsvidhya.com/blog/2016/08/practicing-machine-learning-techniques-in-r/)

---
 
**Status**: Completed Assignment
