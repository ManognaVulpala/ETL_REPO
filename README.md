# Healthcare Patient Intake – ETL Project (Informatica | SQL | Python)

# Overview
This project demonstrates a complete **ETL (Extract, Transform, Load)** workflow to clean and standardize patient intake data using three different technologies:
 **Informatica PowerCenter**
 **SQL (Oracle)**
 **Python**
# Use Case
 A hospital receives external patient intake forms in CSV format, where fields like `DOB`, `Gender`, and `Name` are inconsistent in format and casing. This data must be cleaned and loaded into an Oracle database and a downstream reporting file for use by healthcare professionals.

# Tools & Technologies

**Informatica PowerCenter**  ETL tool used to transform and load data 
**Oracle SQL Developer** Used for SQL-based transformation and data loading 
**Python (Pandas)** Script-based data transformation 
**CSV** Raw and cleaned input/output files
**GitHub** Version control and project hosting

# ETL Logic & Transformation Rules

| Field         | Raw Issues | Transformation Applied |
|---------------|------------|------------------------|
| `Patient_ID`  | None       | Retained as-is         |
| `First_Name`  | Mixed case | Converted to UPPERCASE |
| `Last_Name`   | Mixed case | Converted to lowercase |
| `DOB`         | Inconsistent formats (`MM/DD/YYYY`, `DD-MM-YYYY`, etc.) | Standardized to `DD-MM-YYYY` |
| `Gender`      | Inconsistent values (`M`, `male`, `f`, `FEMALE`, etc.) | Standardized to `Male` / `Female` |

# Informatica PowerCenter
Extracted data from raw CSV
Used **Expression Transformation** to clean:
  - Name casing
  - Gender standardization
  - Date parsing
  - Loaded into:
  **Target Flat File**
   **Oracle staging table**
# SQL (Oracle SQL Developer)
- Loaded raw data into a temporary table
- Created a SQL function  to standardize inconsistent date formats
- Converts firstname to UPPERCASE
- Converts lastname to lowercase
- Concatenates both into a new name column
- Standardizes gender values using a CASE expression
- Inserted cleaned data into final staging table

# Python (Pandas)
- Read CSV using `pandas.read_csv()`
- Applied:
  - String casing with `.str.upper()` / `.str.lower()`
  - `datetime` normalization
  - Gender normalization with mapping dictionary
- Exported cleaned file to `pythoncleaned_Patient_data.csv`

# How to Run

# Using Informatica
1. Open **PowerCenter Designer** and import the mapping
2. Configure **Session** and **Workflow** in Workflow Manager
3. Point source to raw CSV and target to Oracle or flat file
4. Run and monitor the job via Workflow Monitor
# Using SQL
1. Use `SQL/` scripts to:
   - Load data into raw table
   - Transform using SQL queries
   - Insert into cleaned table
# Using Python
1. Navigate to `python/` directory
2. Run:
   ```bash
   python Sorting_raw_patient_data.py
