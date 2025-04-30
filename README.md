**📊 Nashville Housing Data Cleaning with MySQL 🏡**

Welcome to this SQL-based data cleaning project! Here, I worked with real-world housing data using MySQL Workbench, performing cleaning operations such as handling nulls, standardizing formats, splitting columns, and removing duplicates.

---

**🧰 Tools Used**

💾 MySQL Workbench

🏷️ CSV Dataset: Nashville Housing Data

🧹 SQL Queries for Data Cleaning

💡 GitHub for version control

---

**🗂️ Dataset Overview**

The dataset includes records of property sales with the following columns:

Parcel ID

Property Address

Owner Address

Sale Price

Sale Date

Legal Reference

And more...

---

**🔧 Data Cleaning Steps**

✅ Standardized Date Format

🔍 Populated Missing Property Addresses using self-joins

🧠 Split PropertyAddress and OwnerAddress into street, city, and state

🔄 Normalized SoldAsVacant column (Y/N → Yes/No)

🧽 Removed Duplicate Records using ROW_NUMBER()

🗑️ Dropped Unnecessary Columns

---

**💡 How to Use**

Clone or download this repository.

Place the CSV in the data/ folder.

Import the CSV into MySQL using Workbench.

Run the SQL queries in the sql/data_cleaning.sql script.

Analyze the cleaned table or export it for further use.

---

**🧠 What I Learned**

Using SQL for professional-grade data cleaning

String manipulation and date conversion in MySQL

Data backup and safety best practices

---

**💬 Feedback & Contributions**

Feel free to fork, star ⭐, or submit a pull request.
Let’s grow our data skills together!
Feel free to fork, star ⭐, or submit a pull request.
Let’s grow our data skills together!
