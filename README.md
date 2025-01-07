# **Data-Cleaning-and-Transformation-for-Retail-Orders**

## **Project Description**  
This project processes retail order data from CSV files and transforms it into a clean and structured format stored in a MySQL database. The script automates data cleaning, transformation, and insertion, creating a seamless pipeline to manage retail data efficiently for analysis or reporting.

---

1. **Cleans the Data**  
   - Handles missing or invalid data.  
   - Standardizes column names by replacing spaces with underscores.  

2. **Transforms the Data**  
   - Calculates fields like discounts, sales prices, and profits.  
   - Drops unnecessary columns and aligns the dataset with the database schema.  

3. **Loads Data into MySQL**  
   - Uses batch processing to efficiently insert the data into a MySQL table.  
   - Ensures duplicate entries are skipped using `INSERT IGNORE` for seamless reruns.

---

## **Technologies Used**  
- **Python**: Programming Language  
- **pandas**: Used for data manipulation and transformation.  
- **MySQL**: A relational database to store cleaned and structured data.   



