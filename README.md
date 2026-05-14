# UPI Transaction Analytics & Fraud Detection System

## Overview

This project simulates a real-world UPI transaction analytics and fraud detection system using Python, MySQL, Pandas, and Jupyter Notebook.

The project analyzes digital payment transactions to identify:
- Fraudulent transactions
- Failed payments
- Customer spending behavior
- Merchant performance
- Transaction success rates

---

## Technologies Used

- Python
- Pandas
- MySQL
- Jupyter Notebook

---

## Dataset Information

- 1000+ simulated UPI transaction records
- Includes:
  - User ID
  - Transaction amount
  - Merchant details
  - Transaction status
  - Payment mode
  - Fraud indicators

---

## SQL Concepts Used

- SELECT Statements
- WHERE Conditions
- GROUP BY
- ORDER BY
- Aggregations
- CASE Statements
- Filtering
- Joins

---

## Python Concepts Used

- Data Cleaning
- Exploratory Data Analysis (EDA)
- Pandas DataFrames
- KPI Analysis
- Fraud Detection Logic
- Business Insight Generation

---

## Key Business Insights

- Identified high-risk and failed UPI transactions
- Calculated transaction success rate
- Analyzed top merchants by transaction volume
- Detected high-spending customers
- Generated fraud-risk indicators using Python logic

---

## Project Structure

```text
upi-analytics-python-sql/
│
├── README.md
├── upi_analysis.ipynb
├── upi_transactions.csv
├── sql_queries.sql
├── screenshots/
│   ├── transactions_table.png
│   ├── fraud_transactions.png
│   └── python_business_insights.png
```

---

## Sample SQL Queries

### Transaction Status Analysis

```sql
SELECT status, COUNT(*) AS total_transactions
FROM transactions
GROUP BY status;
```

### Top Merchants Analysis

```sql
SELECT merchant,
       COUNT(*) AS total_transactions,
       SUM(amount) AS total_amount
FROM transactions
GROUP BY merchant
ORDER BY total_amount DESC
LIMIT 5;
```

### Fraud Transaction Detection

```sql
SELECT *
FROM transactions
WHERE amount > 50000
AND status = 'FAILED';
```

---

## Python Business Insights

```python
print("===== BUSINESS INSIGHTS =====")

print("Highest spender:", highest_spender)
print("Most used merchant:", most_used_merchant)
print("Success rate:", round(success_rate, 2), "%")
print("High risk transactions:", len(high_risk_txn))
```

---

## Project Screenshots

### Transaction Dataset
<img width="1885" height="540" alt="image" src="https://github.com/user-attachments/assets/35f04035-3808-4a12-beb2-2f435ac3b1d4" />


### Fraud Detection Analysis
<img width="739" height="386" alt="image" src="https://github.com/user-attachments/assets/9753c68a-9bb2-47e6-8953-2c310e4405ad" />


### Python Business Insights
<img width="1479" height="326" alt="image" src="https://github.com/user-attachments/assets/76972902-bf28-44a8-ab98-8d1d55470ef3" />


---

## Business Impact

This project demonstrates how transaction analytics can help financial organizations:

- Detect suspicious payment behavior
- Monitor merchant transaction performance
- Improve fraud detection processes
- Track payment success trends
- Generate business-ready analytical reports

The workflow simulates real-world fintech and digital payments analytics scenarios commonly used in banking and financial services industries.
## Author

Akash Gangadhari
