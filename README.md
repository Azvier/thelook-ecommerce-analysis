# Full-Stack E-commerce Analysis: TheLook Dataset

This is a comprehensive, full-stack data analysis project simulating a real-world workflow for the e-commerce dataset "TheLook". The project covers the entire data lifecycle from database design and data loading to in-depth analysis via SQL and preparation for business intelligence reporting.

## Technical Overview

-   **Database Architecture & Deployment:** Designed a relational database schema in PostgreSQL to ensure data integrity with proper constraints and keys (PK/FK). The entire database was deployed in a Docker container for portability and environment consistency.
-   **Data Ingestion:** Performed data loading from raw CSV files (extracted from Google BigQuery) into the designed PostgreSQL database.
-   **Complex SQL Analysis:** Wrote complex SQL queries to perform in-depth analysis directly within the database. This included analyzing sales trends, product performance, and customer behavior patterns.
-   **Python for EDA:** Connected to the PostgreSQL database from a Python environment to pull structured data for further Exploratory Data Analysis (EDA) using libraries like Pandas.
-   **Business Intelligence (Planned):** The final stage of this project will involve connecting the database to a BI tool like Power BI to create an interactive dashboard visualizing key performance indicators (KPIs).

## Technologies & Libraries Used

-   SQL (PostgreSQL)
-   Docker
-   Python
-   Pandas
-   Power BI (Planned)
-   Google BigQuery (Data Source)

## Project Workflow

Data Extraction (BigQuery) → DB Design & Deployment (PostgreSQL, Docker) → Data Loading → SQL Analysis → Python EDA → BI Dashboard (Planned)

---

***Disclaimer:** Please note that this is a large-scale project that is currently in progress. The repository will be updated continuously as new stages of the analysis (such as the Power BI dashboard) are completed.*
