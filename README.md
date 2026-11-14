# 🛒 E-Commerce Retail & Profitability Analytics Dashboard

An end-to-end data analytics project that transforms raw e-commerce transaction data into actionable business insights. Using **Excel, SQL Server, and Power BI**, this project analyzes sales growth, profit margins, customer segmentation, and product return patterns.

---

## 📌 Executive Summary

* **Realized Revenue:** ₹728.47K[cite: 8, 10]
* **Realized Profit:** ₹202.2K[cite: 8, 10]
* **Overall Profit Margin:** 27.76%
* **Return Rate:** 5%

The dashboard addresses business-critical questions regarding revenue streams, high-performing product categories, demographic profit distribution, and root causes for item returns[cite: 8, 9].

---

## 🛠️ Data Pipeline & Architecture

1. **Microsoft Excel (Data Cleaning & Prep)**
   * Audited raw sales datasets for missing values and duplicates.
   * Standardized data types, currency formatting, and numeric precision.

2. **SQL Server (Database Schema & Analytics)**
   * Designed a relational schema normalized across 5 primary tables (`Categories`, `Products`, `Customers`, `Orders`, `Order_Details`).
   * Written analytical queries using Common Table Expressions (CTEs) and Window Functions (`NTILE`, `LAG`) for Month-over-Month (MoM) growth and **RFM (Recency, Frequency, Monetary)** customer segmentation.

3. **Power BI (Data Modeling & Visual Design)**
   * Built a **Star Schema** with a dedicated 1-to-Many calendar dimension (`DimDate`).
   * Authored dynamic **DAX measures** to calculate non-returned financial metrics (*Realized Revenue* and *Realized Profit*).
   * Developed a 2-page interactive UI layout with conditional formatting and drill-down analysis[cite: 8, 9].

---

## 📐 Key Business Rules & DAX Formulas

To ensure total financial accuracy, all order returns (`IsReturned = 1`) are excluded from revenue and profit calculations:

* **Realized Revenue:**
  ```dax
  Realized Revenue = 
  CALCULATE(
      SUMX(
          'Order_Details',
          'Order_Details'[Quantity] * 'Order_Details'[UnitPrice] * (1 - 'Order_Details'[DiscountRate])
      ),
      'Order_Details'[IsReturned] = 0
  )

* **Realized Profit:**
  ```dax
Realized Profit = 
CALCULATE(
    SUMX(
        'Order_Details',
        ('Order_Details'[Quantity] * 'Order_Details'[UnitPrice] * (1 - 'Order_Details'[DiscountRate])) 
        - ('Order_Details'[Quantity] * 'Order_Details'[UnitCost])
    ),
    'Order_Details'[IsReturned] = 0
)

---

## 📊 Dashboard Features & Insights

1. Executive Overview (Page 1)
KPI Metrics: Displays high-level totals — ₹728.47K Realized Revenue, ₹202.2K Realized Profit, 27.76% Profit Margin, and a 5% Return Rate[cite: 8, 10].
Time Intelligence: Line chart displaying continuous monthly sales trajectories from 2021 to 2023.   
Category Drivers: Identifies Meat & Poultry (33.63%) and Personal Care as top revenue-generating product groups.   
Customer Tiers: Highlights revenue contributions across Standard, Premium, and VIP customer segments.   

2. Profitability & Quality Analysis (Page 2)
Product Matrix Table: Uses conditional data bars to evaluate profit margins against return rates across all categories.   
Return Reason Breakdown: Categorizes returned inventory reasons (e.g., customer changed mind, damaged packaging, expired dates) to help reduce logistics losses.   
Demographic Performance: Analyzes profitability distribution across different customer age brackets.   
Decomposition Tree: Interactive visual path dissecting sales across category, region, and gender. 

## 📂 Project Structure
```text
├── Datasets/
│   ├── raw_ecommerce_data.xlsx
│   └── cleaned_retail_data.xlsx
├── SQL_Scripts/
│   ├── 01_schema_creation.sql
│   ├── 02_analytical_views.sql
│   └── 03_rfm_segmentation.sql
├── PowerBI_Report/
│   └── ECommerce_Retail_Analytics.pbix
├── Visuals/
│   ├── Executive_Overview.png
│   └── Profitability_Quality_Analysis.png
└── README.md
