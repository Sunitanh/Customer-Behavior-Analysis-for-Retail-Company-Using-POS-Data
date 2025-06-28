# Customer-Behavior-Analysis-for-Retail-Company-Using-POS-Data
**Business Context:**
A retail company aims to enhance its understanding of customer behavior to improve strategic decision-making in marketing, inventory, and operations. Using data from Point of Sale (POS) systems, the company wants to analyze customer demographics, transaction trends, and product performance across store types and sales channels.
________________________________________
**Problem Statement:**
The company has large volumes of customer and transaction data but lacks clear visibility into customer preferences, product return patterns, revenue drivers, and high-performing categories. The goal is to uncover actionable insights such as:

•	Who are the most frequent or high-value customers?

•	What are the best-selling products/categories?

•	How are returns affecting revenue?

•	Which store/channel is most effective?
________________________________________
**Data Availability:**
The analysis is based on three primary tables:
1.	**Customer**– Contains demographic details such as customer ID, gender, age, and city.
2.	**Transactions** – Includes transaction-level data like transaction ID, date, quantity, revenue, return status, product ID, and channel/store type.
3.	**Product Category** – Maps each product to its category and sub-category.
________________________________________
**Data Understanding:**

**Key Observations:**

•	Date fields are not in the correct format and require conversion.

•	Returns are indicated in the transaction table and need to be filtered accordingly.

•	Categories and sub-categories must be joined for classification.

•	Revenue and quantity data are used for summarizing sales, returns, and product performance.

**Derived Insights from Data Profiling:**

•	Total rows in each table

•	Return transaction count

•	Time span of data in days, months, and years

•	Sub-category relationships (e.g., “DIY” falls under which category)
________________________________________
**Key Steps Performed**

**1.Data Preparation:**

o	Standardized date formats using SQL date conversion functions.

o	Filtered return transactions using return flags or negative revenue.

o	Joined transaction and category tables to add product context.

**2.Exploratory Analysis & SQL Querying:**

o	Counted transactions by channel, gender, city, and sub-category.

o	Aggregated revenue by product, sub-category, and store type.

o	Identified customer segments based on transaction volume and age.

o	Calculated sales vs returns for each product sub-category.

**3.Metric Calculation:**

o	Revenue, quantity, return rate, average order value, and transaction frequency.

o	Time-based analysis using rolling periods (e.g., last 30 days, last 3 months).

**4.Filtering and Ranking:**

o	Identified top sub-categories and top-performing categories by quantity and revenue.

o	Used ranking and conditional aggregation in SQL for filtering top-N outputs.

________________________________________
**Technology Stack Used**
•SQL (MySQL/PostgreSQL) – For querying, joining, aggregating, and transforming data.
________________________________________
**Key Outputs**

1.	Most used channel for purchases identified.

2.	Count of Male and Female customers across cities.

3.	City with the maximum customer base.

4.	Revenue performance of Electronics and Books categories.

5.	Top sub-categories by sales and returns.

6.	Customer segment (aged 25–35) spending in last 30 days.

7.	Revenue by store type and product category.

8.	Average revenue comparison against overall average to identify above-average categories.

9.	Customers with more than 10 transactions, excluding returns.

10.	Effectiveness of Flagship Stores in generating revenue from Electronics & Clothing.
________________________________________
**Challenges & Learnings:**

**Challenges:**

•	Parsing and converting inconsistent date formats.

•	Handling missing or inconsistent values in product category mappings.

•	Differentiating between valid transactions and returns (negative revenue or return flag).

•	Efficiently calculating rolling period insights (e.g., last 30 or 90 days) using SQL.

**Learnings:**

•	Improved skills in date functions, joins, group-by aggregations, and filtering in SQL.

•	Learned how to segment data by customer profile and time window.

•	Understood the importance of data enrichment (e.g., joining lookup tables) for full context.
•	Gained experience building SQL logic to support dynamic business KPIs like average revenue, return rates, and quantity sold rankings
