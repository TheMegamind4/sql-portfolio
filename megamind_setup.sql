-- =============================================
-- MEGAMIND DATABASE SETUP SCRIPT
-- Run this in SSMS first before any other script
-- =============================================
-- Creates:
--   Learning System  — ConversationLog, LearningTopics
--   Job Search       — JobApplications, InterviewLog
--   Finance          — Transactions, FinanceGoals
--
-- NOTE: Health/Workout tables are NOT here.
-- The full workout system lives in megamind_workout_schema_v2.sql
-- Run that script second after this one.
-- =============================================

CREATE DATABASE Megamind;
GO

USE Megamind;
GO

-- =============================================
-- LEARNING SYSTEM
-- Tracks every Claude session and concept learned
-- Most important module — feeds AI context system
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

CREATE TABLE LearningTopics (
    TopicID         INT IDENTITY(1,1) PRIMARY KEY,
    SessionID       INT FOREIGN KEY REFERENCES ConversationLog(SessionID),
    TopicName       NVARCHAR(200) NOT NULL,
    Category        NVARCHAR(100),
    NeedsRevision   BIT DEFAULT 0,
    InterviewReady  BIT DEFAULT 0,
    Notes           NVARCHAR(1000),
    CreatedAt       DATETIME DEFAULT GETDATE()
);

-- =============================================
-- JOB SEARCH SYSTEM
-- Built early — actively job hunting right now
-- =============================================

CREATE TABLE JobApplications (
    ApplicationID   INT IDENTITY(1,1) PRIMARY KEY,
    AppliedDate     DATE NOT NULL,
    CompanyName     NVARCHAR(200) NOT NULL,
    RoleTitle       NVARCHAR(200) NOT NULL,
    Platform        NVARCHAR(100),   -- 'LinkedIn', 'Naukri' etc
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
    Round           NVARCHAR(100),   -- 'HR Screening', 'Technical Round 1' etc
    Outcome         NVARCHAR(50),    -- 'Passed', 'Failed', 'Pending'
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
    Category        NVARCHAR(100),   -- 'Food', 'Transport', 'Salary' etc
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
-- VERIFY: Show all created tables
-- Expected: 6 tables
-- ConversationLog, LearningTopics,
-- JobApplications, InterviewLog,
-- Transactions, FinanceGoals
-- =============================================

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
