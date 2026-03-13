-- =============================================
-- MEGAMIND DATABASE SETUP SCRIPT
-- Run this in SSMS to create the full database
-- =============================================

CREATE DATABASE Megamind;
GO

USE Megamind;
GO

-- =============================================
-- PHASE 1: LEARNING SYSTEM
-- =============================================

CREATE TABLE ConversationLog (
    SessionID       INT IDENTITY(1,1) PRIMARY KEY,
    SessionDate     DATE NOT NULL,
    SessionNumber   INT NOT NULL,
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
-- PHASE 2: HEALTH SYSTEM
-- =============================================

CREATE TABLE WorkoutLog (
    WorkoutID       INT IDENTITY(1,1) PRIMARY KEY,
    WorkoutDate     DATE NOT NULL,
    WorkoutType     NVARCHAR(100),
    DurationMinutes INT,
    Notes           NVARCHAR(500),
    CreatedAt       DATETIME DEFAULT GETDATE()
);

CREATE TABLE ExerciseLog (
    ExerciseID      INT IDENTITY(1,1) PRIMARY KEY,
    WorkoutID       INT FOREIGN KEY REFERENCES WorkoutLog(WorkoutID),
    ExerciseName    NVARCHAR(200) NOT NULL,
    Sets            INT,
    Reps            INT,
    WeightKg        DECIMAL(5,2),
    Notes           NVARCHAR(300)
);

CREATE TABLE BodyMetrics (
    MetricID        INT IDENTITY(1,1) PRIMARY KEY,
    RecordDate      DATE NOT NULL,
    WeightKg        DECIMAL(5,2),
    Notes           NVARCHAR(300),
    CreatedAt       DATETIME DEFAULT GETDATE()
);

-- =============================================
-- PHASE 3: FINANCE SYSTEM
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
-- PHASE 4: JOB SEARCH SYSTEM
-- =============================================

CREATE TABLE JobApplications (
    ApplicationID   INT IDENTITY(1,1) PRIMARY KEY,
    AppliedDate     DATE NOT NULL,
    CompanyName     NVARCHAR(200) NOT NULL,
    RoleTitle       NVARCHAR(200) NOT NULL,
    Platform        NVARCHAR(100),
    Status          NVARCHAR(50) DEFAULT 'Applied',
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
-- VERIFY: Show all created tables
-- =============================================

SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
