# Fetch-Rewards-Solution-Engineer-Challenge

## Overview

This repository contains the solution to the Fetch Rewards Solution Engineer coding exercise. The objective of this exercise was to demonstrate how I reason about data, model it, answer business questions with SQL, identify and resolve data quality issues, and effectively communicate findings to business stakeholders.

The exercise was completed in four main parts:

1. **Structured Relational Data Model**: Reviewing unstructured JSON data and designing a relational data model for use in a data warehouse.
2. **SQL Queries**: Writing SQL queries to answer specific business questions based on the newly structured data model.
3. **Data Quality Evaluation**: Using SQL/Python to identify and analyze potential data quality issues.
4. **Communication**: Constructing a message to a business stakeholder to summarize the data quality issues and solutions.

---

## Project Structure

The repository contains the following files:

- **1_DataModel.png**: Image of the data model diagram that shows the tables, fields, and relationships.
- **2_SQL_Queries.sql**: SQL queries that answer the business questions listed in the exercise.
- **3_DataQualityValidation.ipynb**: Python code used to identify and analyze data quality issues in the provided datasets.
- **4_Communicate_Stakeholders**: A Slack message drafted to communicate data quality issues to business stakeholders.

---

## Part 1: Structured Relational Data Model

### Process

- I reviewed the unstructured JSON data from the following sources:
  - **Receipts Data**: Contains information on user purchases, receipt statuses, and bonus points earned.
  - **Users Data**: Contains user information, including account creation date and last login.
  - **Brands Data**: Contains brand information, including category and barcode.

- I created a simplified relational model for these datasets to store them efficiently in a data warehouse.

- **Diagram**: [[data_model.png](https://github.com/naman02602/Fetch-Rewards-Solution-Engineer-Challenge/blob/main/1_DataModel.png)] contains the ER diagram representing the tables and relationships (users, receipts, brands).

---

## Part 2: SQL Queries

### Business Questions

I wrote SQL queries to answer the following business questions:

1. **Top 5 Brands by Receipts Scanned for Most Recent Month**
2. **Comparison of Top 5 Brands Between the Most Recent Month and the Previous Month**
3. **Average Spend Comparison for 'Accepted' vs. 'Rejected' Receipts**
4. **Total Number of Items Purchased for 'Accepted' vs. 'Rejected' Receipts**
5. **Brand with Most Spend Among Users Created in the Last 6 Months**
6. **Brand with Most Transactions Among Users Created in the Last 6 Months**

The queries are contained in **2_SQL_Queries.sql**. Each query is written to extract data from the relational model created in Part 1.

---

## Part 3: Data Quality Evaluation

### Approach

Using SQL and Python, I reviewed the provided JSON data for the following data quality issues:

- **Missing Values**: Fields such as `userId`, `receipt_id`, `totalSpent` were found to have missing data.
- **Non-Numeric Values**: Inconsistent data in numeric fields like `totalSpent`.
- **Duplicate Records**: Identified duplicate entries for `user_id` and `receipt_id`.
- **Invalid Date Ranges**: Some `purchaseDate` entries were far earlier than expected.
- **Referential Integrity Issues**: Receipts referencing non-existent user IDs or brands.

### Solution

I used **3_DataQualityValidation.ipynb** to run various checks on the data and identified issues related to missing values, duplicates, and inconsistencies.

---

## Part 4: Communication with Stakeholders

To communicate my findings, I drafted a Slack message for the business stakeholders. The message outlines the data quality issues, asks for clarification on certain points, and recommends steps to address performance and scaling concerns.

- The draft message is available in **4_Communicate_Stakeholders**.

---

## How to Run the Code

1. **SQL Queries**: You can execute the queries in **2_SQL_Queries.sql** on your database after creating the relational tables from the provided data model.
2. **Data Quality Script**: Run the Python Notebook **3_DataQualityValidation.ipynb** on the provided JSON data to identify data quality issues.

---

## SQL Dialect

I used **T-SQL** SQL dialect for the queries. Please let me know if you need assistance with executing the queries or adapting them to a different SQL environment.

---

## Conclusion

This exercise allowed me to demonstrate my skills in data modeling, SQL query writing, data quality evaluation, and communication. I’m excited about the possibility of working together to ensure data quality and optimize data processes.

Feel free to reach out if you have any questions or need further details!
