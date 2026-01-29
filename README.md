# 📊 Amazon SQL Analytics

A comprehensive SQL analytics project analyzing an Amazon-like e-commerce dataset using SQL Server / T-SQL.  
This repository demonstrates real-world data modeling, extraction, transformation, and analysis skills through structured queries that answer key business questions.

---

## 📁 Repository Structure

```
amazon-sql-analytics/
├── 01_schema/ # Tables definition scripts
├── 02_data_loading/ # Data load procedures (BULK INSERT)
├── 03_analysis_queries/ # Business analytics queries
├── assets/ # Supporting images (ERD, diagrams)
├── data/ # Reference datasets (if used for local testing)
├── README.md # Project overview & documentation
└── LICENSE # MIT License
```


---

## 📘 Project Objective

This project aims to transform raw transactional data into actionable business insights using SQL — simulating a typical analytics workflow in an enterprise or e-commerce environment.

You will find solutions to business problems such as:
- Revenue analysis
- Customer segmentation
- Operational analytics
- Inventory monitoring
- Performance KPIs

---

## 🗂️ Data Model (ERD)

The project is built on a normalized relational data model that represents a real-world e-commerce system.  
The schema captures customer behavior, sales transactions, product information, logistics, and payments.

### Entity Relationship Diagram

![Amazon ERD](assets/ERD.png)

### Key Relationships

- **Customers → Orders** (1-to-Many)  
  A customer can place multiple orders.

- **Orders → Order Items** (1-to-Many)  
  Each order can contain multiple products.

- **Products → Categories** (Many-to-1)  
  Each product belongs to a single category.

- **Orders → Payments** (1-to-Many)  
  An order can have multiple payment attempts.

- **Orders → Shipping** (1-to-1)  
  Each order has associated shipping details.

- **Products → Inventory** (1-to-Many by warehouse)  
  Inventory levels are tracked per product per warehouse.

- **Sellers → Orders** (1-to-Many)  
  Sellers fulfill multiple orders.

This data model enables robust analytical use cases such as revenue analysis, customer lifetime value, inventory alerts, return analysis, and seller performance evaluation.

---

## 🧠 Business Questions Covered

The `03_analysis_queries/` folder contains professionally structured SQL scripts that answer the following:

1. **Top Selling Products** — Identify products contributing most to sales.  
2. **Total Sales by Category** — Evaluate category revenue and percentage contribution.  
3. **Average Order Value (AOV)** — Compute average order spend for active customers.  
4. **Monthly Sales Trend** — Compare month-over-month sales performance.  
5. **Customers with No Purchases** — Identify registered users who never ordered.  
6. **Least Selling Categories by State** — Find categories with lowest demand by state.  
7. **Customer Lifetime Value (CLTV)** — Rank customers by total value generated.  
8. **Inventory Stock Alerts** — Alert products with low stock with warehouse info.  
9. **Shipping Delays** — Detect orders with shipping delays and measure delay days.  
10. **Payment Success Rate** — Analyze success and failure of payment attempts.  
11. **Top Performing Sellers** — Rank sellers by sales & success rates.  
12. **Product Profit Margin** — Evaluate profitability and rank products.  
13. **Most Returned Products** — Find products with highest return rates.  
14. **Inactive Sellers** — Identify sellers with no recent sales and summarize performance.  
15. **Customer Return Behavior** — Classify customers based on return activity.

Each script is:
- Well documented  
- Industry-ready  
- Designed with business logic clarity  

---

## 📈 Skills Demonstrated

This project is crafted to highlight core SQL competency expected in data analytics roles:

| Skill | Description |
|-------|-------------|
| **Relational Modeling** | Understanding of keys, relationships, and schema design |
| **Aggregations & Joins** | Complex groupings, multiple joins across tables |
| **Window Functions** | Use of RANK, LAG, etc. for trend and ranking analysis |
| **Conditional Logic** | CASE statements for segmentation and categorization |
| **Time-based Analytics** | Rolling windows, date functions, month-over-month measures |
| **Performance Awareness** | Explicit fields, safe calculations, edge case handling |

---

## 🧪 Assumptions & Definitions

To ensure clarity and reproducibility, the following are defined in many of the scripts:

- **Gross Sales** represents total revenue regardless of order status unless specified.
- **Revenue** may be filtered for only “Completed” and “Delivered” transactions when relevant.
- **Return rate** is calculated at the unit level to avoid row inflation from order items.
- **Inactive customers or sellers** are defined using dynamic windows based on the latest data.

These definitions are documented in each query script.

---

## 🎯 Potential Extensions

This repository can be enhanced further with:

- **Views for reusable metrics** (e.g., revenue per month, cumulative customer metrics)
- **Stored procedures** for automation
- **Index recommendations** for performance
- **Power BI / Tableau dashboards** sourced from these queries
- **Testing dataset generator** for reproducibility

---

## 🧰 Tech Stack

- **SQL Server / T-SQL**
- **BULK INSERT** for data ingestion
- **Window Functions & CTEs**
- **Business metric modeling**

---

## 📌 Getting Started

1. Clone this repository:
   ```bash
   git clone https://github.com/Pranshulx26/amazon-sql-analytics
   ```
2. Restore the database schema from 01_schema/

3. Load data using the 02_data_loading/ scripts

4. Run analytics queries from 03_analysis_queries/

5. Inspect results with your SQL Server client of choice

## 🛡️ License
This project is licensed under the **[MIT License](https://opensource.org/licenses/MIT)**.  
You are free to use, modify, and share this project with proper attribution.

---

## 🌟 About Me
Hi there! I’m **Pranshul Sharma**, a **B.Tech student in Information Technology** and a **Data Analyst enthusiast** on a mission to build a strong career in data analytics. I am passionate about transforming raw data into meaningful insights using **SQL, Python, and data visualization tools**.

I enjoy working on real-world datasets, exploring patterns, and presenting insights that support data-driven decision-making. Through continuous learning and hands-on projects, I am actively developing my skills in **data analysis, business intelligence, and analytical storytelling**, with the goal of becoming a proficient and impactful **Data Analyst**.

