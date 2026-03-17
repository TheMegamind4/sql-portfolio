-- =============================================
-- MEGAMIND MASTER SCHEMA
-- File: megamind_master_schema.sql
-- Run order: 1st — run this before any other script
-- =============================================
-- Creates:
--   Core DB         — Megamind database
--   Job Search      — JobApplications, InterviewLog
--   Finance         — Transactions, FinanceGoals
--   Session Core    — ConversationLog (shared by learning and workout systems)
-- =============================================

CREATE DATABASE Megamind;
GO

USE Megamind;
GO

-- =============================================
-- SESSION CORE
-- ConversationLog is shared across all modules
-- Learning system and workout system both reference it
-- =============================================

CREATE TABLE ConversationLog (
    SessionID       INT IDENTITY(1,1) PRIMARY KEY,
    SessionDate     DATE NOT NULL,
    SessionNumber   INT NOT NULL,
    SessionTitle    NVARCHAR(200),
    TopicsCovered   NVARCHAR(500),
    Summary         NVARCHAR(2000),
    KeyConcepts     NVARCHAR(1000),
    NextSession     NVARCHAR(500),
    DifficultyLevel TINYINT CHECK (DifficultyLevel BETWEEN 1 AND 5),
    CreatedAt       DATETIME DEFAULT GETDATE()
);

-- =============================================
-- JOB SEARCH SYSTEM
-- =============================================

CREATE TABLE JobApplications (
    ApplicationID   INT IDENTITY(1,1) PRIMARY KEY,
    AppliedDate     DATE NOT NULL,
    CompanyName     NVARCHAR(200) NOT NULL,
    RoleTitle       NVARCHAR(200) NOT NULL,
    Platform        NVARCHAR(100),
    Status          NVARCHAR(50) DEFAULT 'Applied',
    -- Status values: Applied, Shortlisted, Interview, Rejected, Offer
    SalaryExpected  DECIMAL(10,2),
    JobURL          NVARCHAR(500),
    Notes           NVARCHAR(500),
    CreatedAt       DATETIME DEFAULT GETDATE()
);

CREATE TABLE InterviewLog (
    InterviewID     INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationID   INT FOREIGN KEY REFERENCES JobApplications(ApplicationID),
    InterviewDate   DATE,
    Round           NVARCHAR(100),
    Outcome         NVARCHAR(50),
    Notes           NVARCHAR(500),
    CreatedAt       DATETIME DEFAULT GETDATE()
);

-- =============================================
-- FINANCE SYSTEM
-- =============================================

CREATE TABLE Transactions (
    TransactionID   INT IDENTITY(1,1) PRIMARY KEY,
    TransactionDate DATE NOT NULL,
    Amount          DECIMAL(10,2) NOT NULL,
    Type            NVARCHAR(10) CHECK (Type IN ('Income','Expense')),
    Category        NVARCHAR(100),
    Description     NVARCHAR(300),
    CreatedAt       DATETIME DEFAULT GETDATE()
);

CREATE TABLE FinanceGoals (
    GoalID          INT IDENTITY(1,1) PRIMARY KEY,
    GoalName        NVARCHAR(200) NOT NULL,
    TargetAmount    DECIMAL(10,2),
    CurrentAmount   DECIMAL(10,2) DEFAULT 0,
    Deadline        DATE,
    Status          NVARCHAR(20) DEFAULT 'Active',
    CreatedAt       DATETIME DEFAULT GETDATE()
);

-- =============================================
-- VERIFY
-- =============================================

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO
