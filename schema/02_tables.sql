-- =====================================================
--  CREATE TABLES (DDL )
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
