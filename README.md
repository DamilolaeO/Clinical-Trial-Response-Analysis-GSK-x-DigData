# GSK Clinical Trial Response Analysis

## Overview
This project explores clinical trial data from the GSK x DigData Step Up Challenge using R. It evaluates the effectiveness of a new drug candidate, Miraculon-B, compared to the standard of care in treating solid tumours. The workflow includes data cleaning, exploratory analysis, visualisation, and predictive modelling using a decision tree.

---

## Objective
To determine whether Miraculon-B improves treatment response compared to standard care and identify factors that predict patient response. This analysis supports clinical decision-making and regulatory strategy by highlighting response patterns.

---

## Tools Used
- **Language**: R
- **Libraries**: `tidyverse`, `dplyr`, `ggplot2`, `readr`, `gt`, `caret`,`rpart`,`rpart.plot`
- **Data Format**: CSV files

---
## Data Workflow  
### 1. Data Preparation  
- Imported and merged multiple CSV datasets  
- Replaced missing values using mean imputation  
- Filtered and selected relevant variables (e.g. Age, BMI, Protein Concentration, Treatment Group, Response)

### 2. Exploratory Data Analysis (EDA)  
- Visualised distributions of Age, BMI, and Protein levels by treatment group and response outcome  
- Used boxplots and summary tables to highlight key trends

### 3. Statistical Summary  
- Compared response rates across treatment groups  
- Investigated relationship between protein concentration and treatment response

### 4. Predictive Modelling – Decision Tree  
- Built a decision tree classifier to predict patient response (`Yes`/`No`)  
- Evaluated model performance using **confusion matrix**, **accuracy**, **sensitivity**, **specificity**, and **kappa**  
- Visualised the decision tree using `rpart.plot` for interpretability

---

## Key Findings  
- **Higher response rate** in the Miraculon-B group (54.8%) than in the Control group (32.2%)  
- **Protein concentration** was consistently lower in responders, suggesting potential as a predictive biomarker  
- **Decision tree model** achieved:
  - Accuracy: **80.3%**
  - Sensitivity: **83.7%**
  - Specificity: **75.8%**
  - Kappa: **0.60** (moderate agreement)

These results indicate that basic clinical features and protein levels can help predict patient response, supporting better targeting of treatment.

---

## Visuals Included  
- Boxplots of Age, BMI, and Protein Concentration by treatment and response  
- Tabular summaries of group-wise statistics  
- Decision tree diagram for model interpretation  
  

---

## Business Impact  
This analysis contributes to regulatory reporting and clinical decision-making by:  
- Highlighting key predictors of treatment response  
- Informing personalised medicine approaches  
- Supporting prescriber guidance and value assessment for Miraculon-B
- Advancing the **public good** by promoting data-driven healthcare decisions that improve patient outcomes, reduce unnecessary treatments, and enhance clinical trial efficiency—helping ensure that medical innovations reach the right patients faster and more fairly.  

---

## Files in this Repository  
- `Clinical_Trial_Decision_Tree.pdf`: Visualisation of the decision tree model 
-  `merged_data.csv`: Cleaned and processed dataset  
- `GSK_AnalysisScript.R`: Full R script (cleaning, EDA, modelling, visualisation)  
- `GSK X DigData-Damilola Ogungbemi.pptx`: Summary slides submitted for the challenge  
- `README.md`: Project documentation  

---

## Acknowledgements
This project was developed as part of the GSK x DigData Step Up career challenge.

---

## Author
**Damilola Ogungbemi**  
MSc Biotechnology | Data Scientist | *Passionate about using data for public good in healthcare and policy.*
