-- Create the database
CREATE DATABASE BankingSystem;
GO

-- Use the new database
USE BankingSystem;
GO

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    DateOfBirth DATE,
    Address NVARCHAR(255),
    PhoneNumber NVARCHAR(15),
    Email NVARCHAR(100)
);
GO

-- Create the Accounts table
CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY IDENTITY,
    CustomerID INT,
    AccountType NVARCHAR(50),
    Balance DECIMAL(18, 2),
    CONSTRAINT FK_Accounts_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
GO

-- Create the Transactions table
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY IDENTITY,
    AccountID INT,
    TransactionType NVARCHAR(50),
    Amount DECIMAL(18, 2),
    TransactionDate DATETIME,
    CONSTRAINT FK_Transactions_Accounts FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);
GO

-- Stored procedure to create a customer
CREATE PROCEDURE CreateCustomer
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @DateOfBirth DATE,
    @Address NVARCHAR(255),
    @PhoneNumber NVARCHAR(15),
    @Email NVARCHAR(100)
AS
BEGIN
    INSERT INTO Customers (FirstName, LastName, DateOfBirth, Address, PhoneNumber, Email)
    VALUES (@FirstName, @LastName, @DateOfBirth, @Address, @PhoneNumber, @Email);
END;
GO

-- Stored procedure to open an account
CREATE PROCEDURE OpenAccount
    @CustomerID INT,
    @AccountType NVARCHAR(50),
    @InitialBalance DECIMAL(18, 2)
AS
BEGIN
    INSERT INTO Accounts (CustomerID, AccountType, Balance)
    VALUES (@CustomerID, @AccountType, @InitialBalance);
END;
GO

-- Stored procedure to deposit money
CREATE PROCEDURE DepositMoney
    @AccountID INT,
    @Amount DECIMAL(18, 2)
AS
BEGIN
    UPDATE Accounts
    SET Balance = Balance + @Amount
    WHERE AccountID = @AccountID;
    
    INSERT INTO Transactions (AccountID, TransactionType, Amount, TransactionDate)
    VALUES (@AccountID, 'Deposit', @Amount, GETDATE());
END;
GO

-- Stored procedure to withdraw money
CREATE PROCEDURE WithdrawMoney
    @AccountID INT,
    @Amount DECIMAL(18, 2)
AS
BEGIN
    UPDATE Accounts
    SET Balance = Balance - @Amount
    WHERE AccountID = @AccountID;
    
    INSERT INTO Transactions (AccountID, TransactionType, Amount, TransactionDate)
    VALUES (@AccountID, 'Withdrawal', @Amount, GETDATE());
END;
GO

-- Stored procedure to transfer money
CREATE PROCEDURE TransferMoney
    @FromAccountID INT,
    @ToAccountID INT,
    @Amount DECIMAL(18, 2)
AS
BEGIN
    BEGIN TRANSACTION;
    
    UPDATE Accounts
    SET Balance = Balance - @Amount
    WHERE AccountID = @FromAccountID;
    
    UPDATE Accounts
    SET Balance = Balance + @Amount
    WHERE AccountID = @ToAccountID;
    
    INSERT INTO Transactions (AccountID, TransactionType, Amount, TransactionDate)
    VALUES (@FromAccountID, 'Transfer Out', @Amount, GETDATE());
    
    INSERT INTO Transactions (AccountID, TransactionType, Amount, TransactionDate)
    VALUES (@ToAccountID, 'Transfer In', @Amount, GETDATE());
    
    COMMIT TRANSACTION;
END;
GO

-- Stored procedure to view transaction history
CREATE PROCEDURE ViewTransactionHistory
    @AccountID INT
AS
BEGIN
    SELECT TransactionID, AccountID, TransactionType, Amount, TransactionDate
    FROM Transactions
    WHERE AccountID = @AccountID
    ORDER BY TransactionDate DESC;
END;
GO

-- Execute stored procedure to create a customer
EXEC CreateCustomer 
    @FirstName = 'John', 
    @LastName = 'Doe', 
    @DateOfBirth = '1980-01-01', 
    @Address = '123 Main St', 
    @PhoneNumber = '1234567890', 
    @Email = 'john.doe@example.com';
GO

-- Execute stored procedure to open an account
EXEC OpenAccount 
    @CustomerID = 1, 
    @AccountType = 'Savings', 
    @InitialBalance = 1000.00;
GO

-- Execute stored procedure to deposit money
EXEC DepositMoney 
    @AccountID = 1, 
    @Amount = 500.00;
GO

-- Execute stored procedure to withdraw money
EXEC WithdrawMoney 
    @AccountID = 1, 
    @Amount = 200.00;
GO

-- Execute stored procedure to transfer money
EXEC TransferMoney 
    @FromAccountID = 1, 
    @ToAccountID = 2, 
    @Amount = 100.00;
GO

-- Execute stored procedure to view transaction history
EXEC ViewTransactionHistory 
    @AccountID = 1;
GO

SELECT * FROM Transactions;
GO 

                                      -- THIS PROJECT IS DONE BY DHANANJAY PALIWAL..FROM ARYA COLLEGE OF ENGINEERING AND IT..