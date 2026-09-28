# EuroEats --- End-to-End Food Delivery Analytics Project

> **Data Analytics Portfolio Project \| SQL Server • Python • Machine
> Learning • Power BI**

## 1. Project Overview

**EuroEats** is an end-to-end food-delivery analytics project built
around a relational marketplace dataset covering customers, restaurants,
menu items, drivers, orders, deliveries, payments and reviews.

The project combines **SQL Server, Python, regression modeling and Power
BI** to transform raw operational data into:

-   Business-focused SQL analysis
-   Data cleaning and validation
-   Exploratory data analysis and operational insights
-   A predictive model for actual delivery duration
-   An interactive Power BI dashboard
-   Business-focused delivery, customer and restaurant insights

### Business Domain

**Food Delivery Marketplace / Last-Mile Delivery**

EuroEats is a food-delivery marketplace founded in 2023 and
headquartered in Amsterdam, Netherlands. The case study describes
operations across **15 European countries**, connecting customers,
independent restaurant partners and delivery drivers.

The business focuses on independent restaurants, transparent driver pay
and reliable delivery estimates.

### Dataset Size

The project contains:

-   **1,500 customers**
-   **120 restaurants**
-   **1,500 menu items**
-   **350 drivers**
-   **4,500 orders**
-   **4,697 order items**
-   **1,000 deliveries**
-   **800 payments**
-   **500 reviews**
-   **14,967 total rows**

------------------------------------------------------------------------

## 2. Business Problem Statement

Over the previous two quarters, EuroEats received increasing customer
complaints that the delivery time shown at checkout frequently does not
match the actual delivery duration.

The business wants to understand:

1.  What factors actually drive delivery time.
2.  Where delivery performance is weakest.
3.  How large the gap is between estimated and actual delivery time.
4.  How customer and restaurant performance vary across markets.
5.  Whether delivery duration can be predicted before an order is
    dispatched.

The primary machine-learning problem is therefore a **regression
problem**, where the target is:

``` text
actual_delivery_minutes
```

The business objective is to build a model that can predict how long a
new order will actually take to deliver before dispatch, so that the
checkout experience can provide a more trustworthy delivery estimate.

The project also addresses the broader analytical questions raised by
Operations and Product through SQL analysis, Python EDA and Power BI
reporting.

------------------------------------------------------------------------

# 3. Dataset & Data Model

The project uses a relational database containing **9 connected
tables**.

### Database Tables

``` text
customers
restaurants
menu_items
drivers
orders
order_items
deliveries
payments
reviews
```

The `orders` table acts as the central transactional record, with
one-to-many relationships to customers, restaurants and order items, and
optional one-to-one extensions for deliveries, payments and reviews.

### Relational Structure

``` text
customers   1 ──< orders
restaurants 1 ──< orders
restaurants 1 ──< menu_items
orders      1 ──< order_items
menu_items  1 ──< order_items
orders      1 ──0/1 deliveries
drivers     1 ──< deliveries
orders      1 ──0/1 payments
orders      1 ──0/1 reviews
customers   1 ──< reviews
```

### Dataset Size

  Table                 Rows
  ------------- ------------
  customers            1,500
  restaurants            120
  menu_items           1,500
  drivers                350
  orders               4,500
  order_items          4,697
  deliveries           1,000
  payments               800
  reviews                500
  **Total**       **14,967**

### Key Analytical Tables

#### Orders

Contains customer orders, restaurant information, order timing, item
quantity, pricing, discounts, payment method and order status.

#### Deliveries

The core operational and machine-learning table containing:

-   Distance
-   Traffic level
-   Weather condition
-   Temperature
-   Pickup delay
-   Restaurant wait
-   Existing platform ETA
-   Actual delivery duration
-   Delivery status

#### Reviews

Contains customer rating, delivery rating, food rating and review
sentiment.

------------------------------------------------------------------------

# 4. Tools & Technologies

## Database

-   **SQL Server**
-   **Python `pyodbc`**

Used for database creation, relational data storage, joins and SQL
business analysis.

## Python & Data Analytics

-   **Python**
-   **pandas**
-   **NumPy**
-   **scikit-learn**
-   **Jupyter Notebook**
-   **Pickle**

Used for data cleaning, validation, EDA, machine-learning preparation,
regression modeling, model evaluation and model serialization.

## Machine Learning

-   **Linear Regression**
-   **Decision Tree Regressor**
-   **Random Forest Regressor**
-   **Gradient Boosting Regressor**
-   **GridSearchCV**
-   Regression evaluation using:
    -   MAE
    -   RMSE
    -   R²
    -   Cross-validation
    -   Residual analysis
    -   Decile analysis

## Business Intelligence

-   **Power BI**
-   **Power Query**
-   **DAX**

Used for data transformation, data modeling, KPI development,
interactive reporting and dashboard design.

## Design & Documentation

-   **Figma** --- dashboard visual/layout design
-   **Stitch** --- dashboard visual/layout design -- AI tool
-   **ChatGPT** --- technical assistance, troubleshooting,
    SQL/Python/modeling guidance and project documentation

------------------------------------------------------------------------

# 5. End-to-End Data Analytics Workflow

``` text
EuroEats Relational Dataset
        │
        ▼
1. Dataset & Data Dictionary Understanding
        │
        ▼
2. SQL Server Database Creation
   Python + pyodbc
        │
        ▼
3. 30 Business SQL Problems
        │
        ▼
4. Python Data Cleaning & Validation
        │
        ▼
5. 20 Business-Focused EDA Questions
        │
        ▼
6. ML Data Preparation
        │
        ▼
7. Regression Model Building & Comparison
        │
        ▼
8. Candidate Model Evaluation
        │
        ▼
9. Gradient Boosting Hyperparameter Tuning
        │
        ▼
10. Final Model Selection & Validation
        │
        ▼
11. Residual & Decile Analysis
        │
        ▼
12. Final Model Serialization
        │
        ▼
13. Power BI Transformation & Data Modeling
        │
        ▼
14. DAX Measures & KPIs
        │
        ▼
15. Interactive Three-Page Dashboard
```

------------------------------------------------------------------------

## 5.1 Dataset & Data Dictionary Understanding

The first stage was understanding the relational structure and business
meaning of the EuroEats data.

The data dictionary was used to understand:

-   Table structures
-   Column definitions
-   Data types
-   Primary and foreign keys
-   Relationships
-   Business meaning of variables
-   Analytical role of each table
-   Delivery-time variables used for the regression problem

This established the foundation for SQL analysis, EDA, machine learning
and Power BI.

------------------------------------------------------------------------

## 5.2 SQL Server Database Creation --- Python + pyodbc

Python was used with `pyodbc` to connect to SQL Server and create the
EuroEats relational database.

The source data was loaded into nine relational tables while preserving
the required primary-key and foreign-key relationships.

The database provides a structured foundation for answering the
operational, commercial and customer-related business questions.

------------------------------------------------------------------------

## 5.3 SQL-Based Business Problem Solving --- 30 Questions

After creating the database, **30 business problems** were solved using
SQL Server.

The questions were organized into four major analytical areas.

### A. Customer Insights & Loyalty

Analysis included:

-   Customer segment order mix by country
-   Top lifetime-spend customers
-   Delivered customers without reviews
-   Customer spend ranking and spending tiers
-   Customer inactivity / win-back analysis
-   Cumulative customer spending over time

### B. Restaurant & Menu Performance

Analysis included:

-   Restaurant revenue by country
-   Top frequently ordered menu items
-   Restaurant customer ratings with review counts
-   Top three menu items by restaurant
-   Vegetarian share by cuisine
-   Restaurants with longer preparation times relative to their market

### C. Revenue, Orders & Promotions

Analysis included:

-   Revenue by country and month
-   Month-over-month revenue growth
-   Discount usage and discount size
-   Payment-method failure analysis
-   Lost order value from cancellations and refunds
-   Highest-revenue restaurant in each country

### D. Delivery & Driver Operations

Analysis included:

-   Delivery time under traffic and weather conditions
-   Late-delivery share
-   Driver volume and rating analysis
-   Vehicle-type delivery performance
-   Typical delivery time using median analysis
-   Same-city / same-restaurant order patterns

### E. Strategic & Cross-Functional Analysis

The SQL work also covered:

-   Fastest and slowest countries by delivery time
-   Order size versus discounts
-   Restaurant-and-city delay patterns
-   Restaurant rating versus business volume
-   Driver employment-type performance
-   A combined order → delivery → review analytical view

The SQL work demonstrates joins, CTEs, window functions, ranking,
percentiles, median analysis, cumulative calculations and
business-oriented analytical SQL.

------------------------------------------------------------------------

# 5.4 Data Cleaning & Validation --- Python / Jupyter

After SQL analysis, the data was cleaned and validated in Python.

The cleaning and validation process included:

-   Working copies of source tables
-   Structure validation
-   Duplicate-row checks
-   Primary-key duplicate checks
-   Missing-value analysis
-   Text stripping
-   Numeric conversion
-   Date conversion
-   Invalid conversion checks
-   Numeric range validation
-   Categorical-value validation
-   Categorical standardization
-   Referential-integrity checks
-   Business-logic validation
-   Cross-table consistency checks
-   Final data-quality reporting

The cleaned datasets were stored in:

``` text
EuroEats_cleaned_data.pkl
```

This cleaned dataset was then used for downstream EDA and
machine-learning preparation.

------------------------------------------------------------------------

# 5.5 Exploratory Data Analysis --- Python / Jupyter

After data cleaning, an extensive exploratory data analysis was
performed in Python/Jupyter.

The EDA contains **20 business-focused analytical questions**, with each
question supported by analytical summaries and visualizations.

### EDA Questions

  -----------------------------------------------------------------------
  \#                                  Business Question
  ----------------------------------- -----------------------------------
  **Q1**                              What actually drives delivery time
                                      the most, and how large is each
                                      effect in practice?

  **Q2**                              Are certain countries or cities
                                      consistently slower to deliver than
                                      others, and what might explain it?

  **Q3**                              Does bad weather slow deliveries
                                      down enough to justify a
                                      weather-based delivery surcharge?

  **Q4**                              Which cuisines bring in the most
                                      revenue versus the most orders, and
                                      is there a mismatch worth
                                      investigating?

  **Q5**                              Are Premium customers actually more
                                      valuable to the business, or do
                                      they mainly order more often at a
                                      similar order value?

  **Q6**                              Do higher-rated restaurants
                                      actually get more business, or is
                                      rating disconnected from order
                                      volume?

  **Q7**                              Which vehicle types work best for
                                      short-distance deliveries versus
                                      long-distance ones?

  **Q8**                              Do discounted orders meaningfully
                                      increase how much customers buy?

  **Q9**                              What is the financial cost of
                                      cancelled and refunded orders, and
                                      does it vary by country?

  **Q10**                             Does driver experience translate
                                      into faster or better-rated
                                      deliveries?

  **Q11**                             Which restaurants consistently run
                                      slower than their own stated
                                      preparation time would suggest?

  **Q12**                             How much of the variation in
                                      delivery time comes from
                                      time-of-day and day-of-week
                                      congestion?

  **Q13**                             Do customers who receive slow
                                      deliveries leave worse reviews, and
                                      does this pattern hold across
                                      countries?

  **Q14**                             Which countries or cities represent
                                      potential growth opportunities
                                      based on the existing customer
                                      base?

  **Q15**                             Is there a seasonal pattern to
                                      revenue or delivery performance?

  **Q16**                             Do bigger orders take
                                      proportionally longer to prepare
                                      and deliver, and does this hold
                                      across restaurant sizes?

  **Q17**                             How reliable are current
                                      delivery-time estimates, and where
                                      is the estimated-versus-actual gap
                                      largest?

  **Q18**                             What share of revenue comes from
                                      repeat customers versus one-time
                                      customers, and how does this split
                                      by segment?

  **Q19**                             Do freelance drivers perform
                                      differently from full-time drivers
                                      in terms of speed and ratings?

  **Q20**                             Based on customer reviews and
                                      delivery ratings, where are the
                                      biggest customer-experience pain
                                      points?
  -----------------------------------------------------------------------

The EDA uses business-focused visualizations including:

-   Bar charts
-   Line charts
-   Boxplots
-   Scatter plots
-   Heatmaps
-   Distribution plots
-   Country comparisons
-   Operational segmentation

------------------------------------------------------------------------

# 5.6 Regression Modeling Data Preparation

The predictive objective is to predict:

``` text
actual_delivery_minutes
```

The modeling dataset was created by combining relevant information from:

-   Deliveries
-   Orders
-   Restaurants
-   Customers
-   Drivers

### Modeling Features

The model uses operational, order, restaurant, customer and driver
attributes such as:

-   Number of items
-   Subtotal
-   Delivery fee
-   Discount
-   Distance
-   Traffic
-   Weather
-   Temperature
-   Country
-   City
-   Cuisine
-   Price level
-   Restaurant rating
-   Average preparation time
-   Restaurant size
-   Average daily orders
-   Customer age
-   Gender
-   Customer segment
-   Loyalty status
-   Vehicle type
-   Driver experience
-   Driver rating
-   Completed deliveries
-   Employment type
-   Average driver speed

### Target

``` text
actual_delivery_minutes
```

### Leakage Prevention

The model excludes variables that represent the delivery outcome itself,
including:

``` text
actual_delivery_minutes
delivery_status
```

Variables that become available only after or during the delivery
process were also reviewed carefully against the intended prediction
point.

------------------------------------------------------------------------

# 5.7 Important Modeling Decision --- Removing Existing ETA

During the initial model evaluation, `estimated_delivery_minutes` was
included as a feature.

A review of the business problem showed that this variable represents
the **platform's existing ETA shown to the customer**.

The initial model also gave this variable overwhelmingly high
importance.

Therefore, `estimated_delivery_minutes` was removed from the primary
regression model.

### Reasoning

The final model is intended to independently learn the operational
factors that drive actual delivery duration rather than relying heavily
on an already-existing platform prediction.

The existing ETA remains useful for a separate business analysis of
**estimated versus actual delivery accuracy**, but it is not used as a
predictive feature in the primary regression model.

This feature decision was documented and implemented after the initial
model review.

------------------------------------------------------------------------

# 5.8 Regression Model Building & Comparison

Four fast, interpretable scikit-learn regression models were evaluated:

-   Linear Regression
-   Decision Tree Regressor
-   Random Forest Regressor
-   Gradient Boosting Regressor

The models were evaluated using:

-   Mean Absolute Error (MAE)
-   Root Mean Squared Error (RMSE)
-   R²

### Baseline Results --- Revised Feature Set

After removing `estimated_delivery_minutes`, the baseline results were:

  ---------------------------------------------------------------------------------
  Model         Train MAE    Test MAE Train RMSE   Test RMSE   Train R²     Test R²
  ------------ ---------- ----------- ---------- ----------- ---------- -----------
  **Gradient        4.515   **6.898**      5.729   **9.386**      0.913   **0.801**
  Boosting**                                                            

  Linear            6.891       7.065      9.057       9.543      0.782       0.795
  Regression                                                            

  Random            2.769       7.414      3.756      10.058      0.963       0.772
  Forest                                                                

  Decision          0.000      10.141      0.000      13.992      1.000       0.559
  Tree                                                                  
  ---------------------------------------------------------------------------------

### Baseline Interpretation

Gradient Boosting currently provides the strongest baseline Test MAE and
Test R² among the four models.

Linear Regression shows a relatively small train-test performance gap
and provides a useful interpretable benchmark.

Random Forest shows a substantially larger train-test gap, indicating
overfitting in the baseline configuration.

Decision Tree severely overfits the training data and performs
considerably worse on the test set.

The final model is **not selected solely from these baseline results**.
Further evaluation and tuning are performed in the final model-selection
notebook.

------------------------------------------------------------------------

# 5.9 Model Evaluation, Tuning & Final Selection

The final evaluation stage focuses primarily on:

-   Gradient Boosting
-   Linear Regression

The evaluation workflow includes:

1.  Cross-validation on the training data.
2.  Linear Regression diagnostic analysis.
3.  Gradient Boosting hyperparameter tuning.
4.  Comparison of tuned Gradient Boosting against Linear Regression.
5.  Final evaluation on the untouched test set.
6.  Actual-versus-predicted analysis.
7.  Residual analysis.
8.  Feature-importance analysis when applicable.
9.  Decile analysis.

### Gradient Boosting Tuning

A small parameter grid is used to keep the tuning process efficient:

``` python
{
    "n_estimators": [100, 150],
    "learning_rate": [0.05, 0.1],
    "max_depth": [2, 3]
}
```

The final model selection will be based primarily on predictive
performance on the test set, with **MAE** given strong business
importance because it directly represents average prediction error in
minutes.

The final selected model and results are saved after the evaluation
workflow is completed.

------------------------------------------------------------------------

# 5.10 Model Validation & Error Analysis

The final model is evaluated beyond a single accuracy metric.

### Actual vs Predicted

Used to assess how closely predicted delivery duration follows actual
delivery duration.

### Residual Analysis

Residuals are analyzed using:

-   Residuals vs. predicted values
-   Residual distribution
-   Q-Q analysis where appropriate

These checks help identify systematic errors, changing variance and
areas where the model struggles.

### Decile Analysis

The final test predictions are divided into ten approximately
equal-sized prediction groups.

For each decile, the analysis compares:

-   Number of observations
-   Average actual delivery time
-   Average predicted delivery time
-   MAE
-   Prediction error
-   Percentage error

This helps determine whether model performance changes across shorter
and longer predicted delivery durations.

------------------------------------------------------------------------

# 5.11 Model Serialization

The final trained regression pipeline is saved using pickle so that the
complete preprocessing and model workflow can be reused without
retraining.

Final model artifact:

``` text
EuroEats_Final_Regression_Model.pkl
```

The saved pipeline includes the preprocessing steps required by the
selected regression model.

------------------------------------------------------------------------

# 5.12 Power BI --- Data Transformation & Modeling

The Power BI stage transforms the relational EuroEats data into an
interactive business-reporting layer.

Power Query is used for required data preparation and analytical fields.

The Power BI model connects information across:

-   Customers
-   Restaurants
-   Menu items
-   Orders
-   Order items
-   Deliveries
-   Drivers
-   Payments
-   Reviews

The dashboard is designed around the business requirements provided by
EuroEats Operations, Leadership and Product teams.

------------------------------------------------------------------------

# 5.13 Power BI --- DAX Measures & KPIs

DAX is used to create business metrics required across the dashboard.

### Page 1 --- Executive Overview

Headline metrics include:

``` text
Total Orders
Total Revenue
Average Order Value
Average Delivery Time
On-Time Delivery Rate
```

### Page 2 --- Delivery & Driver Performance

Headline metrics include:

``` text
Average Delivery Time
Delayed Delivery %
Average Distance
Average Driver Rating
```

### Page 3 --- Customer & Restaurant Health

Headline metrics include:

``` text
Total Customers
Repeat-Order Rate
Average Rating Given
Average Restaurant Rating
```

Additional measures support country, restaurant, customer, driver,
delivery and review analysis.

------------------------------------------------------------------------

# 5.14 Power BI --- Dashboard Design

The case study requires a **three-page Power BI report** that
Operations, Leadership and Product teams can review on a recurring
basis.

All three pages share common filtering capabilities where applicable.

## Page 1 --- Executive Overview

### Purpose

> Provide management with a high-level view of overall business
> performance.

Key analysis includes:

-   Total orders
-   Total revenue
-   Average order value
-   Average delivery time
-   On-time delivery rate
-   Revenue and order-volume trends
-   Revenue and order volume by country
-   Revenue split by cuisine type
-   Delivered vs. cancelled vs. refunded orders
-   Top-performing restaurants

Filters:

``` text
Country
Date Range
Customer Segment
Cuisine Type
```
<img width="1958" height="1096" alt="image" src="https://github.com/user-attachments/assets/c3147e0f-68d1-495a-8f82-9fc75d0a3b14" />


------------------------------------------------------------------------

## Page 2 --- Delivery & Driver Performance

### Purpose

> Identify where delivery operations are breaking down and which
> conditions, locations and drivers require attention.

Key analysis includes:

-   Average delivery time
-   Delayed-delivery percentage
-   Average distance
-   Average driver rating
-   Delivery time by traffic level
-   Delivery time by weather condition
-   Delivery time versus distance by vehicle type
-   Delivery time by vehicle type
-   Delivery time by hour of day
-   Delivery time by day of week
-   Driver leaderboard showing volume, rating and speed

Filters:

``` text
Country / City
Traffic Level
Weather Condition
Vehicle Type
Date Range
```
<img width="1968" height="1092" alt="image" src="https://github.com/user-attachments/assets/9bee630d-923d-4a80-ae47-fc91c43d6992" />


------------------------------------------------------------------------

## Page 3 --- Customer & Restaurant Health

### Purpose

> Understand customer behavior, restaurant performance and customer
> satisfaction.

Key analysis includes:

-   Total customers
-   Repeat-order rate
-   Average rating given
-   Average restaurant rating
-   Customer segment mix by country
-   Loyalty tier breakdown
-   Top restaurants by rating
-   Top restaurants by revenue
-   Review sentiment breakdown
-   Restaurant rating versus order volume

Filters:

``` text
Country
Customer Segment
Loyalty Status
Cuisine Type
Date Range
```
<img width="1968" height="1102" alt="image" src="https://github.com/user-attachments/assets/bed59a1b-38cb-46b1-bbad-2d7559b6edef" />


------------------------------------------------------------------------

# 6. Key Analytical Areas

The project provides analysis across four major business areas.

### Delivery Performance

-   Delivery duration
-   Estimated versus actual delivery time
-   Traffic conditions
-   Weather conditions
-   Distance
-   Vehicle type
-   Time-of-day and day-of-week patterns

### Driver Performance

-   Driver rating
-   Driver experience
-   Average speed
-   Completed deliveries
-   Employment type
-   Vehicle type
-   Delivery volume

### Restaurant Performance

-   Revenue
-   Order volume
-   Restaurant rating
-   Cuisine type
-   Preparation time
-   Restaurant size
-   Average daily orders

### Customer Performance

-   Customer segment
-   Loyalty status
-   Order frequency
-   Revenue contribution
-   Repeat-order behavior
-   Customer ratings
-   Review sentiment

------------------------------------------------------------------------

# 7. End-to-End Project Architecture

``` text
┌────────────────────────────────┐
│       EuroEats Dataset         │
│  9 Relational Tables / 14,967  │
│             Rows               │
└───────────────┬────────────────┘
                │
                ▼
┌────────────────────────────────┐
│      Data Understanding        │
│   Schema + Data Dictionary     │
└───────────────┬────────────────┘
                │
                ▼
┌────────────────────────────────┐
│        Python + pyodbc         │
│  SQL Server Database Creation  │
└───────────────┬────────────────┘
                │
                ▼
┌────────────────────────────────┐
│          SQL Server            │
│       EuroEats Database        │
└───────────────┬────────────────┘
                │
        ┌───────┴────────┐
        │                │
        ▼                ▼
┌───────────────┐ ┌──────────────────┐
│ 30 SQL        │ │ Python / Jupyter │
│ Business      │ │ Cleaning & EDA   │
│ Questions     │ │                  │
└───────────────┘ └────────┬─────────┘
                           │
                           ▼
                  ┌──────────────────┐
                  │ ML Data          │
                  │ Preparation      │
                  └────────┬─────────┘
                           │
                           ▼
                  ┌──────────────────┐
                  │ Regression       │
                  │ Model Building   │
                  └────────┬─────────┘
                           │
                           ▼
                  ┌──────────────────┐
                  │ Model Evaluation │
                  │ & Tuning         │
                  └────────┬─────────┘
                           │
                           ▼
                  ┌──────────────────┐
                  │ Final Regression │
                  │ Model (.pkl)     │
                  └──────────────────┘

SQL / Analytical Data
          │
          ▼
┌────────────────────────────────┐
│            Power BI             │
│ Power Query → Model → DAX      │
│ → KPI Cards → Visuals          │
└───────────────┬────────────────┘
                │
                ▼
┌────────────────────────────────┐
│       Three-Page Dashboard      │
│                                │
│ 1. Executive Overview          │
│ 2. Delivery & Driver Performance│
│ 3. Customer & Restaurant Health│
└────────────────────────────────┘
```

------------------------------------------------------------------------

# 8. My Contribution

I worked across the complete analytics lifecycle:

-   Studied the EuroEats relational dataset and data dictionary.
-   Created and populated the SQL Server relational database using
    Python and `pyodbc`.
-   Solved 30 business problems using SQL Server.
-   Performed data cleaning and validation in Python/Jupyter.
-   Performed 20 business-focused EDA questions using analytical tables
    and visualizations.
-   Built the machine-learning dataset for delivery-duration prediction.
-   Reviewed potential target leakage and feature availability.
-   Identified the existing ETA as unsuitable for the primary
    independent regression model.
-   Removed `estimated_delivery_minutes` from the primary predictive
    feature set.
-   Built and compared four regression models.
-   Evaluated models using MAE, RMSE and R².
-   Performed cross-validation and diagnostic analysis.
-   Tuned Gradient Boosting using GridSearchCV.
-   Performed residual and decile analysis.
-   Serialized the final regression pipeline using pickle.
-   Prepared the Power BI data model and analytical reporting layer.
-   Designed a three-page Power BI dashboard structure covering
    executive, operational, customer and restaurant performance.
-   Used AI-assisted tools as supporting resources for technical
    problem-solving, ideation, design and documentation.

------------------------------------------------------------------------

# 9. Skills Demonstrated

## SQL & Database

-   SQL Server
-   Relational Database Design
-   Primary / Foreign Keys
-   Joins
-   CTEs
-   Subqueries
-   Window Functions
-   Ranking
-   Running Totals
-   Percentile / Median Analysis
-   Quartile Analysis
-   Cohort Analysis
-   Business-Oriented SQL

## Python & Data Analytics

-   Python
-   pandas
-   NumPy
-   Data Cleaning
-   Missing-Value Analysis
-   Duplicate Detection
-   Data-Type Conversion
-   Date Validation
-   Categorical Standardization
-   Referential Integrity Validation
-   Business Logic Validation
-   Jupyter Notebook
-   `pyodbc`

## Exploratory Data Analysis

-   Business Question Framing
-   Univariate & Bivariate Analysis
-   Grouped Analysis
-   Trend Analysis
-   Correlation Analysis
-   Distribution Analysis
-   Boxplots
-   Scatter Plots
-   Heatmaps
-   Country / City Comparisons
-   Operational Segmentation

## Machine Learning

-   Regression
-   Linear Regression
-   Decision Tree Regression
-   Random Forest Regression
-   Gradient Boosting Regression
-   Train/Test Split
-   Preprocessing Pipelines
-   Imputation
-   One-Hot Encoding
-   Feature Leakage Prevention
-   Cross-Validation
-   GridSearchCV
-   Model Evaluation
-   Residual Analysis
-   Decile Analysis
-   Model Serialization

## Power BI

-   Power Query
-   Data Modeling
-   Relationships
-   DAX
-   KPI Development
-   Measures
-   Slicers
-   Interactive Visuals
-   Dashboard Design
-   Business Storytelling

## Business Analytics

-   Food Delivery Analytics
-   Last-Mile Delivery Analytics
-   Delivery Performance
-   Driver Analytics
-   Restaurant Analytics
-   Customer Analytics
-   Revenue Analysis
-   Promotion Analysis
-   Review & Sentiment Analysis
-   Operational Analytics
-   Predictive Analytics

## Figma
## Stitch

------------------------------------------------------------------------

# 10. Interview Explanation

> **EuroEats is an end-to-end food-delivery analytics project where I
> combined SQL, Python, regression modeling and Power BI.**
>
> I started by understanding a relational dataset containing customers,
> restaurants, menu items, drivers, orders, deliveries, payments and
> reviews. I then created the SQL Server database using Python and
> `pyodbc`.
>
> After creating the database, I solved 30 business problems using SQL
> Server. These covered customer behavior, restaurant performance, menu
> items, revenue, promotions, delivery operations and driver
> performance.
>
> I then performed data cleaning and validation in Python and answered
> 20 business-focused EDA questions to understand what factors were
> associated with delivery time, customer behavior and operational
> performance.
>
> For the predictive component, the objective was to predict
> `actual_delivery_minutes`, making it a regression problem. I prepared
> a modeling dataset by combining relevant order, restaurant, customer,
> driver and delivery information.
>
> During model review, I noticed that the existing
> `estimated_delivery_minutes` feature dominated the initial model.
> Since that value represents the platform's existing ETA shown to the
> customer, I removed it from the primary model so the final regression
> could independently learn the operational factors driving actual
> delivery duration.
>
> I then compared Linear Regression, Decision Tree, Random Forest and
> Gradient Boosting. Gradient Boosting provided the strongest baseline
> Test MAE and Test R², while Linear Regression provided a useful stable
> benchmark. I then moved the serious candidates into a final evaluation
> and tuning workflow using cross-validation and GridSearchCV.
>
> Finally, I performed residual and decile analysis and saved the final
> regression pipeline as a pickle artifact.
>
> For the BI layer, I designed a three-page Power BI report covering
> Executive Overview, Delivery & Driver Performance, and Customer &
> Restaurant Health. I used Power Query for transformation, DAX for KPIs
> and interactive visuals for operational and commercial analysis.
>
> Overall, the project demonstrates a complete workflow from
> **relational data → SQL analysis → data cleaning → EDA → regression
> modeling → model evaluation → Power BI reporting → business
> insights**.

------------------------------------------------------------------------

# 11. Project Outcome

The project delivers both **descriptive/diagnostic** and **predictive**
analytics.

### Descriptive & Diagnostic Layer

The SQL analysis, Python EDA and Power BI reporting allow users to:

-   Monitor orders and revenue.
-   Compare countries and cities.
-   Analyze restaurant and cuisine performance.
-   Monitor delivery duration.
-   Identify traffic and weather patterns.
-   Analyze driver performance.
-   Understand customer segments and loyalty.
-   Evaluate review sentiment.
-   Compare estimated and actual delivery times.
-   Investigate cancellations and refunds.
-   Identify restaurant performance patterns.

### Predictive Layer

The regression workflow provides a foundation for predicting actual
delivery duration before dispatch.

The model can support:

-   More informed delivery-time estimates.
-   Operational planning.
-   Identification of factors associated with longer deliveries.
-   Investigation of high-error prediction segments.
-   Further improvement of customer-facing delivery estimates.

### Final Deliverables

``` text
EuroEats/
│
├── 01_Business_Analysis_Questions.ipynb
├── 02_Data_Cleaning_and_Validation.ipynb
├── 03_ML_Data_Preparation.ipynb
├── 04_Build_Compare_Regression_Models.ipynb
├── 05_Evaluate_Tune_and_Select_Final_Model.ipynb
│
├── EuroEats_cleaned_data.pkl
├── EuroEats_ML_prepared_data.pkl
├── EuroEats_baseline_models.pkl
├── EuroEats_Final_Regression_Model.pkl
│
├── sql/
│   └── 30 Business Problem Queries
│
├── powerbi/
│   └── EuroEats Power BI Dashboard
│
└── README.md
```

------------------------------------------------------------------------

## Project Summary

  -----------------------------------------------------------------------
  Item                                Details
  ----------------------------------- -----------------------------------
  **Project**                         EuroEats

  **Domain**                          Food Delivery / Last-Mile Delivery

  **Business Context**                European Food-Delivery Marketplace

  **Markets**                         15 European countries

  **Dataset**                         9 relational tables

  **Total Rows**                      14,967

  **Database**                        SQL Server

  **SQL Analysis**                    30 Business Problems

  **Python EDA**                      20 Business Questions

  **ML Problem**                      Regression

  **Target**                          `actual_delivery_minutes`

  **Models**                          Linear Regression, Decision Tree,
                                      Random Forest, Gradient Boosting

  **Current Best Baseline**           Gradient Boosting

  **Primary Evaluation Metrics**      MAE, RMSE, R²

  **Hyperparameter Tuning**           GridSearchCV

  **Model Format**                    Pickle (`.pkl`)

  **BI Tool**                         Power BI

  **Dashboard Pages**                 3

  **Status**                          End-to-End Analytics Portfolio
                                      Project
  -----------------------------------------------------------------------

------------------------------------------------------------------------

## Disclaimer

**EuroEats is the business context used for this analytics portfolio
project.**

The project is intended to demonstrate practical skills in **SQL,
Python, machine learning, Power BI, data modeling, business analysis and
analytical storytelling**.
