# Data-Analytics-Using-SQL

A collection of SQL scripts that explore, analyze, and report on a small retail data warehouse. The project starts from raw CSV files,
loads them into a gold schema following a simple star schema, and walks through progressively more advanced analytics — from basic exploration to cumulative trends, segmentation, and reusable reporting views.

---

## Data Model

The warehouse follows a star schema with two dimension tables and one fact table:

| Table | Description |
|---|---|
| `gold.dim_customers` | One row per customer (name, country, gender, birthdate, etc.) |
| `gold.dim_products` | One row per product (name, category, subcategory, cost, etc.) |
| `gold.fact_sales` | One row per order line item (order/shipping/due dates, quantity, price, sales amount) |

`fact_sales.customer_key` and `fact_sales.product_key` are foreign keys into the two dimension tables.


## Project Structure

```
Data-Analytics-Using-SQL/
├── datasets/
│   ├── flat-files/                 # Source CSVs (dim_customers, dim_products, fact_sales)
│   └── DataWarehouseAnalytics.bak  # SQL Server backup of the pre-built database
├── docs/                           # Diagrams referenced in this README
├── results/                        # Screenshots of each script's output (SSMS)
├── scripts/                        # Numbered SQL scripts, meant to be run in order

```

## Scripts

All scripts live in [`scripts/`](scripts) and are numbered in the order they're intended to be run. Screenshots of each script's actual output (run in SSMS) are in [`results/`](results) and linked below.

| # | Script | What it covers | Result |
|---|---|---|---|
| 00 | [`00_init_database.sql`](scripts/00_init_database.sql) | Creates the `DataWarehouseAnalytics` database, `gold` schema, and the three tables, then bulk-loads them from the CSV files | [DBcreation](results/00A.png) · [tables](results/00B.png) |
| 01 | [`01_database_exploration.sql`](scripts/01_database_exploration.sql) | Lists tables and inspects column metadata via `INFORMATION_SCHEMA` | [view](results/01.png) |
| 02 | [`02_dimensions_exploration.sql`](scripts/02_dimensions_exploration.sql) | Explores distinct values in the dimension tables (countries, product hierarchy) | [view](results/02.png) |
| 03 | [`03_date_range_exploration.sql`](scripts/03_date_range_exploration.sql) | Finds the span of order dates and customer ages | [view](results/03.png) |
| 04 | [`04_measures_exploration.sql`](scripts/04_measures_exploration.sql) | Computes core business metrics (total sales, quantity, orders, customers, products) | [view](results/04.png) |
| 05 | [`05_magnitude_analysis.sql`](scripts/05_magnitude_analysis.sql) | Aggregates metrics by dimension (customers by country/gender, revenue by category, etc.) | [view 1](results/05A.png) · [view 2](results/05B.png) |
| 06 | [`06_ranking_analysis.sql`](scripts/06_ranking_analysis.sql) | Ranks top/bottom performing products and customers using `TOP` and window ranking functions | [view](results/06.png) |
| 07 | [`07_change_over_time_analysis.sql`](scripts/07_change_over_time_analysis.sql) | Tracks monthly sales trends using three different date-bucketing techniques | [view](results/07.png) |
| 08 | [`08_cumulative_analysis.sql`](scripts/08_cumulative_analysis.sql) | Computes running totals and moving averages with window functions | [view](results/08.png) |
| 09 | [`09_performance_analysis.sql`](scripts/09_performance_analysis.sql) | Year-over-year product performance vs. average and vs. prior year, using `LAG()` | [view](results/09.png) |
| 10 | [`10_data_segmentation.sql`](scripts/10_data_segmentation.sql) | Segments products by cost range and customers by spend/loyalty (VIP/Regular/New) | [view](results/10.png) |
| 11 | [`11_part_to_whole_analysis.sql`](scripts/11_part_to_whole_analysis.sql) | Calculates each product category's percentage contribution to total sales | [view](results/11.png) |
| 12 | [`12_report_customers.sql`](scripts/12_report_customers.sql) | Builds a reusable `gold.report_customers` view with per-customer KPIs (segment, recency, AOV, monthly spend) | [view](results/12.png) |
| 13 | [`13_report_products.sql`](scripts/13_report_products.sql) | Builds a reusable `gold.report_products` view with per-product KPIs (segment, recency, AOR, monthly revenue) | [view](results/13.png) |

## Getting Started

**Prerequisites:** SQL Server (2019+; `DATETRUNC()` in script 07 requires SQL Server 2022+) and a client such as SQL Server Management Studio(SSMS) or Azure Data Studio.

1. Clone the repository and open it in your SQL client.
2. Open [`scripts/00_init_database.sql`](scripts/00_init_database.sql) and update the `BULK INSERT ... FROM` file paths to point at your local copy of `datasets/flat-files/`.
3. Run `00_init_database.sql` to create the database, schema, tables, and load the data.

   > This script drops and recreates the `DataWarehouseAnalytics` database if it already exists. Back up any existing data first.
4. Run the remaining scripts in numeric order (`01` → `13`) to work through the exploration and analysis.

Alternatively, you can restore `datasets/DataWarehouseAnalytics.bak` directly in SQL Server and skip straight to script `01`.

---
