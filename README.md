Online Bank Management Database System
A relational database designed for an online banking platform, focusing on secure transactions, data integrity, and analytics-friendly structure. The system models real-world banking entities such as banks, branches, customers, accounts, and loans, and embeds core business rules directly in the database layer.
​

1. Project Overview
Implements a MySQL database for an online bank management system.
​

Supports core banking operations: account management, loan management, and customer–bank interactions.
​

Emphasizes data integrity, security controls, and reporting via views, procedures, triggers, and functions.
​

Key Objectives
Provide a clean, normalized schema for banking data.
​

Enforce business rules at the database level (no overdrafts, audit trails, consistent balances).
​

Enable management reporting and analytics (branch performance, customer portfolios).
​

2. Database Design
Core Entities
Bank: Stores bank-level information (BankID, BankCode, BankAddress).
​

Branch: Represents individual branches linked to a bank (BranchID, BranchName, BranchAddress, BankID).
​

Customer: Holds customer details (CustomerID, CustomerName, Email, PhoneNumber, CustomerAddress).
​

Account: Represents bank accounts (AccountID, AccountNumber, Balance, AccountType, BranchID, Status).
​

Loan: Represents loans issued to customers (LoanID, Amount, IssueDate, DueDate, LoanType, InterestRate, BranchID, Status).
​

Relationship Tables
CustomerAccount: Junction table between Customer and Account, allowing customers to hold multiple accounts and accounts to be joint.
​

CustomerLoan: Junction table between Customer and Loan, allowing customers to take multiple loans and loans to be shared if required.
​

Lookup Tables
AccountType: Defines categories of accounts (e.g., Savings, Current) with descriptions.
​

LoanType: Defines loan categories (e.g., Personal, Home, Education) with descriptions.
​

ERD
The ERD uses both Chen and Crow’s Foot notation to represent:
​

One‑to‑many: Bank → Branch, Branch → Account, Branch → Loan.

Many‑to‑many: Customer ↔ Account, Customer ↔ Loan (resolved via junction tables).

Add docs/ERD_online_bank_management.png and reference it here.

3. Features
Data Integrity & Constraints
Primary keys on all base tables (e.g., BankID, BranchID, CustomerID, AccountID, LoanID).
​

Foreign keys to maintain referential integrity between banks, branches, customers, accounts, and loans.
​

Unique constraints on fields such as BankCode and, where applicable, AccountNumber.
​

Default values for fields such as status (e.g., default “Active” for accounts).
​

Indexing & Performance
Indexes on key foreign key columns to speed up joins, such as:
​

idx_branch_bank on Branch.BankID

idx_account_branch on Account.BranchID

idx_loan_branch on Loan.BranchID

Demonstrated performance improvement by comparing indexed vs non-indexed queries (up to ~900x faster in example).
​

Views
vwCustomerAccountSummary:
​

Shows each customer’s total number of accounts and summed balance.

Useful for dashboards, customer profiling, and portfolio overviews.

vwBranchPerformance:
​

Aggregates total accounts, total loans, total deposits, and total loan amounts per branch.

Used for branch performance monitoring and management KPIs.

Stored Procedures
spTransferFunds:
​

Transfers funds between two accounts.

Checks if the source account has sufficient balance.

Updates both accounts and returns a status message (e.g., success or insufficient funds).

spAddCustomer:
​

Inserts a new customer into the Customer table.

Useful for encapsulating customer creation logic.

Triggers
trLogAccountBalanceChange (AFTER UPDATE on Account):
​

Logs every balance change into AccountBalanceAudit with old balance, new balance, change amount, type (DEPOSIT/WITHDRAWAL), and timestamp.

Provides a complete audit trail for compliance and fraud detection.

trPreventOverdraft (BEFORE UPDATE on Account):
​

Prevents updates that would result in a negative balance.

Raises an error if an overdraft is attempted, enforcing no‑overdraft policy.

Functions
fnCalculateMonthlyInterest:
​

Calculates monthly interest based on account balance and annual interest rate.

Ensures consistent interest calculations across queries.

fnGetCustomerTotalBalance:
​

Returns the total active balance across all accounts for a given CustomerID.

Supports portfolio summaries, risk analysis, and wealth management views.

4. Tech Stack
Database: MySQL.
​

Language: SQL (DDL, DML, DCL-style constructs with procedures, triggers, functions).
​

Modeling: ERD using Chen and Crow’s Foot notations.
​

5. Repository Structure
Suggested structure for this project:

text
.
├── schema
│   ├── 01_create_database.sql
│   ├── 02_tables.sql
│   ├── 03_constraints_indexes.sql
├── data
│   └── sample_inserts.sql
├── logic
│   ├── views.sql
│   ├── stored_procedures.sql
│   ├── triggers.sql
│   └── functions.sql
├── docs
│   ├── ERD_online_bank_management.png
│   └── high_level_architecture.md
└── README.md
schema/: Database creation and table definitions with constraints and indexes.
​

data/: Sample data for testing scenarios.
​

logic/: Advanced SQL objects (views, stored procedures, triggers, functions).
​

docs/: ERD diagram and any additional documentation or design notes.
​

6. Setup & Usage
Prerequisites
MySQL server installed and running.
​

Access to a MySQL client (CLI or GUI tools like MySQL Workbench).
​

Installation Steps
Create the database and tables

Run scripts in the following order:
​

schema/01_create_database.sql

schema/02_tables.sql

schema/03_constraints_indexes.sql

Insert sample data

Execute data/sample_inserts.sql to populate base tables (banks, branches, customers, account types, loan types, accounts, loans, junction tables).
​

Create advanced SQL objects

Run scripts in logic/ in any logical order (views → functions → procedures → triggers).
​

7. Example Queries
7.1 Customer Portfolio Summary
sql
SELECT *
FROM vwCustomerAccountSummary;
Retrieves each customer’s total number of accounts and aggregated balance.
​

7.2 Branch Performance
sql
SELECT *
FROM vwBranchPerformance;
Returns branch-level metrics including total accounts, total loans, and total deposit and loan amounts.
​

7.3 Accounts with High Balances
sql
SELECT *
FROM Account
WHERE accounttype = 'Savings'
  AND balance > 5000;
Lists savings accounts with balance greater than 5000 for segmentation and analysis.
​

7.4 Transfer Funds Between Accounts
sql
SET @status_msg = '';

CALL spTransferFunds(1, 2, 500.00, @status_msg);

SELECT @status_msg AS transfer_status;
Initiates a fund transfer from account 1 to account 2 and returns the operation status.
​

7.5 Get Customer Total Balance
sql
SELECT
    c.customerid,
    c.customername,
    fnGetCustomerTotalBalance(c.customerid) AS totalbalance
FROM Customer c;
Shows each customer’s total active balance across all accounts.
​

8. Design Decisions
Normalized schema to reduce redundancy and ensure consistency, particularly for customers, accounts, and loans.
​

Junction tables (CustomerAccount, CustomerLoan) to properly handle many‑to‑many relationships.
​

Database-enforced rules (triggers and constraints) so business logic like overdraft prevention and audit logging cannot be bypassed by the application.
​

Indexes on high-traffic join columns to ensure scalable performance under analytical and transactional workloads.
​

9. Possible Extensions
Add role-based access models (e.g., bank staff vs customers) and related permission tables.
​

Integrate more detailed transaction history tables for each account operation.
​

Expand analytics views for credit risk scoring or delinquent loan detection.
​

Connect this database to a frontend or API layer for a full-stack online banking prototype.
