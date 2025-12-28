# India Farmers Insurance Data Analysis (SQL)

## Project Overview
This project performs a deep-dive analysis into the **Farmers Insurance Dataset (PMFBY)** using MySQL. The goal was to transform raw insurance data into actionable insights regarding state-wise coverage, premium distributions, and demographic correlations.

## Database Operations Covered
* **DQL (Data Query Language):** Advanced filtering, sorting, and pattern matching.
* **Aggregations:** Grouping data by geography and time to calculate totals and averages.
* **Joins & Subqueries:** Implementing multi-level nested subqueries and self-joins for complex comparisons.
* **DDL (Data Definition Language):** Creating relational table structures with Primary and Foreign Keys.
* **DML (Data Manipulation Language):** Bulk updates and conditional record deletions.

## Key Insights Solved
1. **District Performance:** Identified top-performing districts based on the ratio of insured farmers to total population.
2. **Premium Analysis:** Filtered and ranked states by Government vs. Farmer premium contributions.
3. **Demographic Shifts:** Analyzed rural vs. urban population metrics in relation to insurance uptake.
4. **Relational Mapping:** Designed a normalized schema for `states` and `districts` to improve data integrity.

## How to Use
1. Clone this repository.
2. Ensure you have a MySQL environment with `local_infile` enabled.
3. Place the `data.csv` in the same directory as the script.
4. Run `analysis_script.sql` to generate the schema and results.

## Skills Demonstrated
- Complex SQL Logic (Nested Subqueries)
- Data Integrity & Constraints
- Performance Optimization (LIMIT/DISTINCT)
- Database Architecture
