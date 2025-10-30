# Library-Management-PLSQL
Library Management System: SQL & PL/SQL Automation

🌟 Project Goal

To design and implement a robust relational database (RDBMS) for a library system, demonstrating advanced SQL, complex data modeling, and transaction control using PL/SQL.

✨ Key Technical Features (What This Project Showcases)

This project fully automates the lending process, proving expertise in:

PL/SQL Triggers:

  Audit Logging (TRG_LOAN_AUDIT): Automatically tracks all updates (returns) and deletions on the sensitive LOAN table, logging old and new values to the AUDIT_LOG for compliance.

PL/SQL Procedures & Functions:

  Transaction Control (PRC_CHECKOUT_BOOK): Implements complex business logic in a single atomic transaction, finding the first available copy by book_id (title) and updating inventory status (status='O').

  Cursor Handling (PRC_OVERDUE_REMINDER): Uses an Explicit Cursor and %ROWTYPE to iterate through all active, overdue loans, retrieve member contact details, and generate a formatted report.

  Business Logic (FNC_CALCULATE_FINE): Calculates fines based on late days using date arithmetic (TRUNC), ensuring precise billing logic.

Advanced SQL & Integrity:

  Data Integrity: Enforces rules like unique ISBNs, composite primary keys (BOOK_AUTHOR), and mandatory 10-digit phone numbers (VARCHAR + REGEXP_LIKE).

Reporting: Uses Conditional Aggregation (SUM(CASE WHEN...)) to produce real-time inventory counts and financial reports.

📁 File Structure & Execution Order

To run this project, execute the files in sequence:

| Order | File Name | Description | 
| ----- | ----- | ----- | 
| **1** | `library_mamangement_system_create_table_01.sql` | **SETUP:** Creates all tables, constraints, and sequences. | 
| **2** | `insert_sample_data_02.sql` | **DATA:** Populates the system with books, members, and initial loan scenarios. | 
| **3** | `04_plsql_automation.sql` | **LOGIC:** Compiles all Functions, Procedures, Triggers, and Cursors. | 
| **4** | `basic_querues_and_reporting_views_03.sql` | **REPORTS:** Runs basic `JOIN`s, `GROUP BY`, and creates reporting views. | 
| **5** | `test_cases_05.sql` | **TESTS:** Executes procedures to demonstrate automation (e.g., calling `PRC_RETURN_BOOK` to trigger fine calculations and the audit log). |

TESTS: Executes procedures to demonstrate automation (e.g., calling PRC_RETURN_BOOK to trigger fine calculations and the audit log).

⚙️ Technology Stack

Database: Oracle (PL/SQL)

Tools: SQL Developer / Any SQL Client
