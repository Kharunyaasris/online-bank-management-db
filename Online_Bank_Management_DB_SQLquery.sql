-- =====================================================
-- BANK MANAGEMENT SYSTEM 
-- Course: XBCS1183N Database Management & Security
-- =====================================================
-- STEP 1: CREATE DATABASE
-- =====================================================

CREATE DATABASE IF NOT EXISTS bank_management_db;

-- STEP 2: USE THE DATABASE
-- Always run USE before creating tables 
USE bank_management_db;

-- =====================================================
-- STEP 3: CREATE TABLES (DDL )
-- =====================================================

-- -----------------------------------------------------
-- Table 1: Bank (Parent Table - Top Level)
-- -----------------------------------------------------
CREATE TABLE Bank (
    bank_id INT PRIMARY KEY,
    bank_code VARCHAR(50) NOT NULL UNIQUE,
    bank_address VARCHAR(255) NOT NULL
);

-- Verify table creation
DESCRIBE Bank;

-- -----------------------------------------------------
-- Table 2: Branch (Each Branch belongs to 1 Bank)
-- -----------------------------------------------------
CREATE TABLE Branch (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    branch_address VARCHAR(255) NOT NULL,
    bank_id INT NOT NULL,
    FOREIGN KEY (bank_id) REFERENCES Bank(bank_id)
);

-- Verify structure
DESCRIBE Branch;

-- -----------------------------------------------------
-- Table 3: Customer
-- -----------------------------------------------------
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    customer_address VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE
);

-- Verify structure
DESCRIBE Customer;

-- -----------------------------------------------------
-- Table 4: CustomerPhoneNumber (Multivalued Attribute)
-- -----------------------------------------------------
CREATE TABLE CustomerPhoneNumber (
    customer_id INT,
    phone_number VARCHAR(20),
    PRIMARY KEY (customer_id, phone_number),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- Verify structure
DESCRIBE CustomerPhoneNumber;

-- -----------------------------------------------------
-- Table 5: AccountType (Lookup Table)
-- -----------------------------------------------------
CREATE TABLE AccountType (
    account_type VARCHAR(50) PRIMARY KEY,
    description VARCHAR(255)
);

-- Verify structure
DESCRIBE AccountType;

-- -----------------------------------------------------
-- Table 6: Account (Each Account belongs to 1 Branch)
-- -----------------------------------------------------
CREATE TABLE Account (
    account_id INT PRIMARY KEY,
    account_number VARCHAR(50) NOT NULL UNIQUE,
    balance DECIMAL(12,2) DEFAULT 0.00,
    account_type VARCHAR(50) NOT NULL,
    branch_id INT NOT NULL,
    status VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (account_type) REFERENCES AccountType(account_type),
    FOREIGN KEY (branch_id) REFERENCES Branch(branch_id)
);

-- Verify structure
DESCRIBE Account;

-- -----------------------------------------------------
-- Table 7: CustomerAccount (M:N Junction Table)
-- -----------------------------------------------------
CREATE TABLE CustomerAccount (
    customer_id INT,
    account_id INT,
    PRIMARY KEY (customer_id, account_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (account_id) REFERENCES Account(account_id)
);

-- Verify structure
DESCRIBE CustomerAccount;

-- -----------------------------------------------------
-- Table 8: LoanType (Lookup Table)
-- -----------------------------------------------------
CREATE TABLE LoanType (
    loan_type VARCHAR(50) PRIMARY KEY,
    description VARCHAR(255),
    default_interest_rate DECIMAL(5,2)
);

-- Verify structure
DESCRIBE LoanType;

-- -----------------------------------------------------
-- Table 9: Loan (Each Loan belongs to 1 Branch)
-- -----------------------------------------------------
CREATE TABLE Loan (
    loan_id INT PRIMARY KEY,
    amount DECIMAL(12,2) NOT NULL,
    loan_type VARCHAR(50) NOT NULL,
    branch_id INT NOT NULL,
    issue_date DATE,
    due_date DATE,
    status VARCHAR(20) DEFAULT 'Active',
    interest_rate DECIMAL(5,2),
    FOREIGN KEY (branch_id) REFERENCES Branch(branch_id),
    FOREIGN KEY (loan_type) REFERENCES LoanType(loan_type)
);

-- Verify structure
DESCRIBE Loan;

-- -----------------------------------------------------
-- Table 10: CustomerLoan (M:N Junction Table)
-- -----------------------------------------------------
CREATE TABLE CustomerLoan (
    customer_id INT,
    loan_id INT,
    PRIMARY KEY (customer_id, loan_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (loan_id) REFERENCES Loan(loan_id)
);

-- Verify structure
DESCRIBE CustomerLoan;

-- =====================================================
-- STEP 4: VIEW ALL TABLES 
-- =====================================================
SHOW TABLES;

-- View full DDL with constraints
SHOW CREATE TABLE Branch;
SHOW CREATE TABLE CustomerAccount;

-- =====================================================
-- STEP 5: CREATE INDEXES 
-- =====================================================
CREATE INDEX idx_branch_bank ON Branch(bank_id);
CREATE INDEX idx_account_branch ON Account(branch_id);
CREATE INDEX idx_loan_branch ON Loan(branch_id);

-- =====================================================
-- =====================================================
-- SECTION 2: DML - DATA MANIPULATION LANGUAGEs
-- =====================================================
-- =====================================================

-- =====================================================
-- CRUD OPERATION 1: CREATE (INSERT)
-- =====================================================

-- -----------------------------------------------------
-- INSERT 1: Insert Bank Records
-- -----------------------------------------------------
INSERT INTO Bank (bank_id, bank_code, bank_address) VALUES 
(1, 'MAYBANK', '123 Finance Street, Kuala Lumpur'),
(2, 'CIMB', '456 Banking Plaza, Petaling Jaya');

-- Verify insertion
SELECT * FROM Bank;

-- -----------------------------------------------------
-- INSERT 2: Insert Branch Records
-- -----------------------------------------------------
INSERT INTO Branch (branch_id, branch_name, branch_address, bank_id) VALUES 
(1, 'Maybank Pavilion', '168 Bukit Bintang, Kuala Lumpur', 1),
(2, 'Maybank KLCC', '88 KLCC, Kuala Lumpur', 1),
(3, 'CIMB Mid Valley', '223 Mid Valley City, Kuala Lumpur', 2);

-- Verify insertion
SELECT * FROM Branch;

-- -----------------------------------------------------
-- INSERT 3: Insert Customer Records
-- -----------------------------------------------------
INSERT INTO Customer (customer_id, customer_name, customer_address, email) VALUES 
(1, 'Azhar bin Mohamed', '456 Residential Lane, Kuala Lumpur', 'azhar@email.com'),
(2, 'Siti Nur Aisyah', '789 Apartment Complex, Selangor', 'siti@email.com'),
(3, 'Raj Kumar', '123 Residential Tower, Kuala Lumpur', 'raj@email.com'),
(4, 'Mei Ling Tan', '567 Condo Heights, Penang', 'meiling@email.com');

-- Verify insertion
SELECT * FROM Customer;

-- -----------------------------------------------------
-- INSERT 4: Insert Customer Phone Numbers (Multiple)
-- Handling multivalued attributes as taught in  5
-- -----------------------------------------------------
INSERT INTO CustomerPhoneNumber (customer_id, phone_number) VALUES 
(1, '0123456789'),
(1, '0187654321'),
(2, '0167890123'),
(3, '0198765432'),
(4, '0145678901');

-- Verify insertion
SELECT * FROM CustomerPhoneNumber;

-- -----------------------------------------------------
-- INSERT 5: Insert AccountType (Lookup Data)
-- -----------------------------------------------------
INSERT INTO AccountType (account_type, description) VALUES 
('Savings', 'Regular savings account for personal use'),
('Checking', 'Current checking account for transactions'),
('Fixed Deposit', 'Fixed term deposit with higher interest');

-- Verify insertion
SELECT * FROM AccountType;

-- -----------------------------------------------------
-- INSERT 6: Insert Account Records
-- -----------------------------------------------------
INSERT INTO Account (account_id, account_number, balance, account_type, branch_id, status) VALUES 
(1, 'ACC001001', 5000.00, 'Savings', 1, 'Active'),
(2, 'ACC001002', 15000.00, 'Checking', 1, 'Active'),
(3, 'ACC002001', 8500.00, 'Savings', 2, 'Active'),
(4, 'ACC003001', 25000.00, 'Fixed Deposit', 3, 'Active'),
(5, 'ACC003002', 3200.00, 'Checking', 3, 'Active');

-- Verify insertion
SELECT * FROM Account;

-- -----------------------------------------------------
-- INSERT 7: Link Customers to Accounts (M:N)
-- -----------------------------------------------------
INSERT INTO CustomerAccount (customer_id, account_id) VALUES 
(1, 1),
(1, 2),
(2, 3),
(3, 4),
(4, 5);

-- Verify insertion
SELECT * FROM CustomerAccount;

-- -----------------------------------------------------
-- INSERT 8: Insert LoanType (Lookup Data)
-- -----------------------------------------------------
INSERT INTO LoanType (loan_type, description, default_interest_rate) VALUES 
('Personal Loan', 'Unsecured personal loan', 8.50),
('Home Loan', 'Mortgage for property purchase', 3.50),
('Auto Loan', 'Vehicle financing', 5.50);

-- Verify insertion
SELECT * FROM LoanType;

-- -----------------------------------------------------
-- INSERT 9: Insert Loan Records
-- -----------------------------------------------------
INSERT INTO Loan (loan_id, amount, loan_type, branch_id, issue_date, due_date, status, interest_rate) VALUES 
(1, 50000.00, 'Personal Loan', 1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 5 YEAR), 'Active', 8.50),
(2, 500000.00, 'Home Loan', 1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 20 YEAR), 'Active', 3.50),
(3, 35000.00, 'Auto Loan', 3, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 5 YEAR), 'Active', 5.50);

-- Verify insertion
SELECT * FROM Loan;

-- -----------------------------------------------------
-- INSERT 10: Link Customers to Loans (M:N)
-- -----------------------------------------------------
INSERT INTO CustomerLoan (customer_id, loan_id) VALUES 
(1, 1),
(1, 2),
(3, 3);

-- Verify insertion
SELECT * FROM CustomerLoan;

-- =====================================================
-- CRUD OPERATION 2: READ (SELECT)
-- SELECT with WHERE, ORDER BY, JOIN
-- =====================================================

-- -----------------------------------------------------
-- SELECT 1: SELECT with AND Condition
-- Multiple Conditions
-- -----------------------------------------------------
SELECT * FROM Account
WHERE account_type = 'Savings' AND balance > 5000;

-- -----------------------------------------------------
-- SELECT 2: SELECT with JOIN (Multiple Tables)
-- SELECT with JOIN
-- Reading from Multiple Tables
-- -----------------------------------------------------
-- Show customer accounts with branch name
SELECT c.customer_id, c.customer_name, a.account_number, a.balance, b.branch_name
FROM Customer c
JOIN CustomerAccount ca ON c.customer_id = ca.customer_id
JOIN Account a ON ca.account_id = a.account_id
JOIN Branch b ON a.branch_id = b.branch_id;

-- -----------------------------------------------------
-- SELECT 3: Complex JOIN - Customer with Loans
-- -----------------------------------------------------
SELECT c.customer_name, l.loan_id, l.amount, l.loan_type, l.interest_rate, l.status
FROM Customer c
JOIN CustomerLoan cl ON c.customer_id = cl.customer_id
JOIN Loan l ON cl.loan_id = l.loan_id;

-- -----------------------------------------------------
-- SELECT 4: Using GROUP Functions 
-- SUM, AVG, COUNT, MAX, MIN
-- -----------------------------------------------------

-- Count of accounts per branch
SELECT b.branch_name, COUNT(a.account_id) AS total_accounts
FROM Branch b
LEFT JOIN Account a ON b.branch_id = a.branch_id
GROUP BY b.branch_name;

-- -----------------------------------------------------
-- SELECT 5: GROUP BY with HAVING 
-- Filter grouped results
-- -----------------------------------------------------
SELECT account_type, COUNT(*) AS count, AVG(balance) AS avg_balance
FROM Account
GROUP BY account_type
HAVING AVG(balance) > 5000;

-- =====================================================
-- CRUD OPERATION 3: UPDATE
--  UPDATE ... SET ... WHERE
-- =====================================================

-- -----------------------------------------------------
-- UPDATE 1: Update Customer Address
-- -----------------------------------------------------
UPDATE Customer
SET customer_address = '789 New Residential Complex, Petaling Jaya'
WHERE customer_id = 1;

-- Verify update
SELECT * FROM Customer WHERE customer_id = 1;

-- -----------------------------------------------------
-- UPDATE 2: Update Account Balance (Deposit)
-- -----------------------------------------------------
UPDATE Account
SET balance = balance + 1000.00
WHERE account_id = 1;

-- Verify update
SELECT * FROM Account WHERE account_id = 1;

-- -----------------------------------------------------
-- UPDATE 3: Update Multiple Columns
-- UPDATE Multiple Columns
-- -----------------------------------------------------
UPDATE Customer
SET email = 'azhar_updated@email.com',
    customer_address = '999 Premium Residency, Kuala Lumpur'
WHERE customer_id = 1;

-- Verify update
SELECT * FROM Customer WHERE customer_id = 1;

-- -----------------------------------------------------
-- UPDATE 4: Update Loan Status
-- -----------------------------------------------------
UPDATE Loan
SET status = 'Under Review'
WHERE loan_id = 1;

-- Verify update
SELECT * FROM Loan WHERE loan_id = 1;

-- Reset for demonstration
UPDATE Loan SET status = 'Active' WHERE loan_id = 1;

-- =====================================================
-- CRUD OPERATION 4: DELETE
-- DELETE FROM ... WHERE
-- =====================================================

-- First, insert test data for deletion
INSERT INTO Customer (customer_id, customer_name, customer_address, email) 
VALUES (99, 'Test Customer', 'Test Address', 'test@email.com');

-- Verify insertion
SELECT * FROM Customer WHERE customer_id = 99;

-- -----------------------------------------------------
-- DELETE 1: Delete Specific Record
-- Basic DELETE 
-- -----------------------------------------------------
DELETE FROM Customer
WHERE customer_id = 99;

-- Verify deletion
SELECT * FROM Customer WHERE customer_id = 99;

-- -----------------------------------------------------
-- DELETE 2: Delete with Multiple Conditions (AND)
-- DELETE with Multiple Conditions
-- -----------------------------------------------------
-- Insert test data first
INSERT INTO CustomerPhoneNumber (customer_id, phone_number) 
VALUES (4, '0199998888');

-- Verify
SELECT * FROM CustomerPhoneNumber WHERE customer_id = 4;

-- Delete specific phone number
DELETE FROM CustomerPhoneNumber
WHERE customer_id = 4 AND phone_number = '0199998888';

-- Verify deletion
SELECT * FROM CustomerPhoneNumber WHERE customer_id = 4;

-- =====================================================
-- =====================================================
-- SECTION 3: ADVANCED SQL OBJECTS
-- VIEW, STORED PROCEDURE, TRIGGER, FUNCTION
-- =====================================================
-- =====================================================

-- =====================================================
-- ADVANCED OBJECT 1: VIEW
--  8: Views - Virtual tables based on SELECT
-- NO DELIMITER needed for VIEW
-- =====================================================

-- -----------------------------------------------------
-- VIEW 1: Customer Account Summary View
-- Use Case: Show simplified customer list with accounts
-- -----------------------------------------------------
CREATE VIEW vw_CustomerAccountSummary AS
SELECT 
    c.customer_id,
    c.customer_name,
    c.email,
    COUNT(ca.account_id) AS account_count,
    SUM(a.balance) AS total_balance
FROM Customer c
LEFT JOIN CustomerAccount ca ON c.customer_id = ca.customer_id
LEFT JOIN Account a ON ca.account_id = a.account_id
WHERE a.status = 'Active' OR a.status IS NULL
GROUP BY c.customer_id, c.customer_name, c.email;

-- Use the view
SELECT * FROM vw_CustomerAccountSummary;

-- -----------------------------------------------------
-- VIEW 2: Branch Performance View
-- Use Case: Management reporting
-- -----------------------------------------------------
CREATE VIEW vw_BranchPerformance AS
SELECT 
    b.branch_id,
    b.branch_name,
    bk.bank_code,
    COUNT(DISTINCT a.account_id) AS total_accounts,
    COUNT(DISTINCT l.loan_id) AS total_loans,
    COALESCE(SUM(a.balance), 0) AS total_deposits,
    COALESCE(SUM(l.amount), 0) AS total_loans_issued
FROM Branch b
LEFT JOIN Bank bk ON b.bank_id = bk.bank_id
LEFT JOIN Account a ON b.branch_id = a.branch_id
LEFT JOIN Loan l ON b.branch_id = l.branch_id
GROUP BY b.branch_id, b.branch_name, bk.bank_code;

-- Use the view
SELECT * FROM vw_BranchPerformance;

-- =====================================================
-- ADVANCED OBJECT 2: STORED PROCEDURE
--  8: Stored Procedure with DELIMITER
-- =====================================================

-- -----------------------------------------------------
-- STORED PROCEDURE 1: Transfer Funds
-- Use Case: Safe inter-account fund transfers
-- -----------------------------------------------------
DELIMITER //

CREATE PROCEDURE sp_TransferFunds(
    IN p_from_account_id INT,
    IN p_to_account_id INT,
    IN p_amount DECIMAL(12,2),
    OUT p_status VARCHAR(100)
)
BEGIN
    DECLARE v_from_balance DECIMAL(12,2);
    
    -- Get current balance
    SELECT balance INTO v_from_balance
    FROM Account
    WHERE account_id = p_from_account_id;
    
    -- Check sufficient balance
    IF v_from_balance < p_amount THEN
        SET p_status = 'ERROR: Insufficient funds';
    ELSE
        -- Deduct from source account
        UPDATE Account 
        SET balance = balance - p_amount 
        WHERE account_id = p_from_account_id;
        
        -- Add to destination account
        UPDATE Account 
        SET balance = balance + p_amount 
        WHERE account_id = p_to_account_id;
        
        SET p_status = 'SUCCESS: Transfer completed';
    END IF;
END//

DELIMITER ;

-- Test the stored procedure
-- Check balances before
SELECT account_id, account_number, balance FROM Account WHERE account_id IN (1, 2);

-- Call the procedure
CALL sp_TransferFunds(1, 2, 500.00, @transfer_status);
SELECT @transfer_status AS result;

-- Check balances after
SELECT account_id, account_number, balance FROM Account WHERE account_id IN (1, 2);

-- -----------------------------------------------------
-- STORED PROCEDURE 2: Add New Customer
-- Use Case: Insert customer with minimal inputs
-- Based on  8 example (AddStudent)
-- -----------------------------------------------------
DELIMITER //

CREATE PROCEDURE sp_AddCustomer(
    IN p_customer_id INT,
    IN p_customer_name VARCHAR(100),
    IN p_customer_address VARCHAR(255),
    IN p_email VARCHAR(100)
)
BEGIN
    INSERT INTO Customer (customer_id, customer_name, customer_address, email)
    VALUES (p_customer_id, p_customer_name, p_customer_address, p_email);
END//

DELIMITER ;

-- Test the stored procedure
CALL sp_AddCustomer(5, 'Ahmad Faiz', '888 New Town, Shah Alam', 'faiz@email.com');

-- Verify
SELECT * FROM Customer WHERE customer_id = 5;

-- =====================================================
-- ADVANCED OBJECT 3: TRIGGER
-- Trigger with DELIMITER
-- Automatic action on DML events
-- =====================================================

-- First create audit table for logging
CREATE TABLE AccountBalanceAudit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT,
    old_balance DECIMAL(12,2),
    new_balance DECIMAL(12,2),
    change_amount DECIMAL(12,2),
    change_type VARCHAR(20),
    change_date DATETIME DEFAULT NOW()
);

-- -----------------------------------------------------
-- TRIGGER 1: Log Account Balance Changes
-- Use Case: Maintain audit trail for compliance
-- -----------------------------------------------------
DELIMITER //

CREATE TRIGGER tr_LogAccountBalanceChange
AFTER UPDATE ON Account
FOR EACH ROW
BEGIN
    IF OLD.balance <> NEW.balance THEN
        INSERT INTO AccountBalanceAudit 
            (account_id, old_balance, new_balance, change_amount, change_type)
        VALUES 
            (NEW.account_id, 
             OLD.balance, 
             NEW.balance, 
             NEW.balance - OLD.balance,
             IF(NEW.balance > OLD.balance, 'DEPOSIT', 'WITHDRAWAL'));
    END IF;
END//

DELIMITER ;

-- Test the trigger
-- Make a deposit
UPDATE Account SET balance = balance + 2000.00 WHERE account_id = 3;

-- Check audit log
SELECT * FROM AccountBalanceAudit;

-- Make a withdrawal
UPDATE Account SET balance = balance - 500.00 WHERE account_id = 3;

-- Check audit log again
SELECT * FROM AccountBalanceAudit;

-- -----------------------------------------------------
-- TRIGGER 2: Prevent Overdraft (Negative Balance)
-- Use Case: Enforce business rule
-- Based on  8 - BEFORE UPDATE trigger
-- -----------------------------------------------------
DELIMITER //

CREATE TRIGGER tr_PreventOverdraft
BEFORE UPDATE ON Account
FOR EACH ROW
BEGIN
    IF NEW.balance < 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'ERROR: Insufficient balance. Overdraft not allowed.';
    END IF;
END//

DELIMITER ;

-- Test: This should FAIL (overdraft attempt)
-- Uncomment to test:
-- UPDATE Account SET balance = balance - 999999.00 WHERE account_id = 1;

-- =====================================================
-- ADVANCED OBJECT 4: FUNCTION
--  8: Function with DELIMITER
-- Returns a computed value
-- =====================================================

-- -----------------------------------------------------
-- FUNCTION 1: Calculate Monthly Interest
-- Use Case: Interest calculation for savings accounts
-- Based on  8 syntax (GetStudentAge)
-- -----------------------------------------------------
DELIMITER //

CREATE FUNCTION fn_CalculateMonthlyInterest(
    p_balance DECIMAL(12,2),
    p_annual_rate DECIMAL(5,2)
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE v_monthly_interest DECIMAL(12,2);
    SET v_monthly_interest = (p_balance * p_annual_rate / 100) / 12;
    RETURN v_monthly_interest;
END//

DELIMITER ;

-- Test the function
SELECT 
    account_id,
    account_number,
    balance,
    fn_CalculateMonthlyInterest(balance, 2.5) AS monthly_interest
FROM Account
WHERE account_type = 'Savings';

-- -----------------------------------------------------
-- FUNCTION 2: Get Customer Total Balance
-- Use Case: Calculate total balance across all accounts
-- -----------------------------------------------------
DELIMITER //

CREATE FUNCTION fn_GetCustomerTotalBalance(
    p_customer_id INT
)
RETURNS DECIMAL(12,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(12,2);
    
    SELECT COALESCE(SUM(a.balance), 0)
    INTO v_total
    FROM Account a
    JOIN CustomerAccount ca ON a.account_id = ca.account_id
    WHERE ca.customer_id = p_customer_id AND a.status = 'Active';
    
    RETURN v_total;
END//

DELIMITER ;

-- Test the function
SELECT 
    customer_id,
    customer_name,
    fn_GetCustomerTotalBalance(customer_id) AS total_balance
FROM Customer;

-- =====================================================
-- SECTION 4: VERIFICATION QUERIES
-- Demonstrate all features working together
-- =====================================================

-- Show all tables created
SHOW TABLES;

-- Show all views
SELECT TABLE_NAME 
FROM information_schema.TABLES 
WHERE TABLE_TYPE = 'VIEW' AND TABLE_SCHEMA = 'bank_management_db';

-- Show all stored procedures
SHOW PROCEDURE STATUS WHERE Db = 'bank_management_db';

-- Show all functions
SHOW FUNCTION STATUS WHERE Db = 'bank_management_db';

-- Show all triggers
SHOW TRIGGERS;

-- =====================================================
-- FINAL SUMMARY QUERIES
-- =====================================================

-- 1. Complete Customer Overview
SELECT 
    c.customer_id,
    c.customer_name,
    c.email,
    fn_GetCustomerTotalBalance(c.customer_id) AS total_balance
FROM Customer c;

-- 2. View all customer accounts with details
SELECT * FROM vw_CustomerAccountSummary;

-- 3. View branch performance
SELECT * FROM vw_BranchPerformance;

-- 4. View audit trail
SELECT * FROM AccountBalanceAudit;

-- =====================================================
-- END OF IMPLEMENTATION
-- =====================================================
-- Summary:
-- - 10 Tables Created (Bank, Branch, Customer, CustomerPhoneNumber,
--   AccountType, Account, CustomerAccount, LoanType, Loan, CustomerLoan)
-- - Plus 1 Audit Table (AccountBalanceAudit)
-- 
-- CRUD Operations:
-- - CREATE: 10 INSERT examples
-- - READ: 5 SELECT examples (with WHERE, JOIN, GROUP BY, HAVING)
-- - UPDATE: 4 UPDATE examples
-- - DELETE: 2 DELETE examples
--
-- Advanced SQL Objects:
-- - 2 VIEWS (vw_CustomerAccountSummary, vw_BranchPerformance)
-- - 2 STORED PROCEDURES (sp_TransferFunds, sp_AddCustomer)
-- - 2 TRIGGERS (tr_LogAccountBalanceChange, tr_PreventOverdraft)
-- - 2 FUNCTIONS (fn_CalculateMonthlyInterest, fn_GetCustomerTotalBalance)
-- =====================================================