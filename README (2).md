# Regression Analysis on Auto-MPG Data

## 📖 Introduction
This project is a **final report for STA 232A (2021F, UC Davis)**, focusing on regression modeling using the **Auto-MPG dataset**.  
The primary goal is to build a suitable regression model for **miles per gallon (MPG)** and explore statistical methods to handle data issues such as multicollinearity.

## 👥 Authors & Contributions
- **Chenze Li**: Model construction and inference  
- **Xi Chen**: Multicollinearity analysis and PCA  
- **Zhentao Li**: Data preprocessing and Ridge regression  

## ⚙️ Methodology
### 1. Data Preprocessing
- Removed missing values.
- Explored distributions of predictors.
- Identified strong **multicollinearity** among variables (weight, displacement, horsepower).

### 2. Model Building
- Initial linear regression model showed heteroscedasticity and non-linearity.
- Applied **Box-Cox transformation** (log-transformation of MPG).
- Conducted **Forward Stepwise Selection** using AIC and BIC criteria.
- Selected simplified model using BIC.

### 3. Inference
- Verified assumptions: **normality, linearity, homoscedasticity**.
- The model fit true MPG values well with significant predictors: horsepower, weight, cylinders, model year, origin.

### 4. Model Adjustment
- **Multicollinearity Analysis**: Detected severe correlation among cylinders, displacement, horsepower, and weight (GVIF > 10).
- **Principal Component Analysis (PCA)**: Synthesized these into a single PC1 explaining 92.6% of variance.
- **Ridge Regression**: Tried but performed worse (R²=0.823 < 0.89).
- **Final Model**: log(MPG) ~ PC1 + model year + origin

## 📊 Results & Insights
- Higher **PC1** → lower fuel consumption efficiency (higher cylinders, displacement, horsepower, weight → lower MPG).
- Cars produced after **1976** have better MPG on average.
- Cars from **Japan and Europe** outperform U.S. cars in fuel efficiency.
- PCA regression was more stable and interpretable than Ridge regression.

## ✅ Conclusion
- **Log-transformation** of MPG improves model fit.  
- **PCA** effectively solves multicollinearity, representing vehicle performance/fuel consumption.  
- **Final model** provides insights into how performance metrics, model year, and origin influence fuel economy.  

## 📚 References
- Quinlan, J.R. (1993). *Combining instance-based and model-based learning*.  
- Fox, J. & Monette, G. (1992). *Generalized collinearity diagnostics*. JASA.  
- Venables, W.N. & Ripley, B.D. (2002). *Modern Applied Statistics with S*.  
- Gruber, M. (1998). *Improving Efficiency by Shrinkage: The James–Stein and Ridge Regression Estimators*.  

