-- =============================================
-- MEGAMIND WORKOUT SCHEMA
-- File: megamind_workout_schema.sql
-- Run order: 3rd — run after megamind_learning_schema.sql
-- =============================================
-- Creates all workout tables:
--   Reference     — BodyRegion, SetProtocol, ExerciseIntent,
--                   MeasurementType, ProgressionRule
--   Exercise      — Exercise, ExerciseBodyRegion
--   Program       — Quarter, CycleDay, DayExercise
--   Logging       — WorkoutSession, ExerciseEntry, SetEntry, ClusterRepEntry
--   Intelligence  — FatigueLog, ProgressionLog
-- =============================================
-- NOTE: Table definitions only. No data inserts.
-- Run megamind_workout_population.sql after this for all data.
-- =============================================

USE Megamind;
GO

-- =============================================
-- REFERENCE TABLES
-- =============================================

CREATE TABLE BodyRegion (
    RegionID        INT IDENTITY(1,1) PRIMARY KEY,
    RegionName      NVARCHAR(100) NOT NULL,
    RegionType      NVARCHAR(20)  NOT NULL,   -- 'Muscle', 'Tendon', 'CNS', 'Joint', 'Mobility'
    IsSystemic      BIT DEFAULT 0,            -- 1 = affects whole body (CNS), 0 = localized
    RecoveryHours   INT NOT NULL
);

CREATE TABLE SetProtocol (
    ProtocolID      INT IDENTITY(1,1) PRIMARY KEY,
    ProtocolName    NVARCHAR(50) NOT NULL,
    Description     NVARCHAR(300)
);

CREATE TABLE ExerciseIntent (
    IntentID          INT IDENTITY(1,1) PRIMARY KEY,
    IntentName        NVARCHAR(50) NOT NULL,
    FatigueMultiplier DECIMAL(3,2) DEFAULT 1.00
);

CREATE TABLE MeasurementType (
    MeasurementTypeID   INT IDENTITY(1,1) PRIMARY KEY,
    TypeName            NVARCHAR(20) NOT NULL,  -- 'Reps', 'Time'
    Unit                NVARCHAR(20)
);

CREATE TABLE ProgressionRule (
    RuleID          INT IDENTITY(1,1) PRIMARY KEY,
    RuleName        NVARCHAR(100) NOT NULL,
    Description     NVARCHAR(500)
);

-- =============================================
-- EXERCISE LIBRARY
-- =============================================

CREATE TABLE Exercise (
    ExerciseID          INT IDENTITY(1,1) PRIMARY KEY,
    ExerciseName        NVARCHAR(200) NOT NULL,
    Purpose             NVARCHAR(300),
    IntentID            INT FOREIGN KEY REFERENCES ExerciseIntent(IntentID),
    MeasurementTypeID   INT FOREIGN KEY REFERENCES MeasurementType(MeasurementTypeID),
    ProtocolID          INT FOREIGN KEY REFERENCES SetProtocol(ProtocolID),
    ProgressionRuleID   INT FOREIGN KEY REFERENCES ProgressionRule(RuleID),
    IsUnilateral        BIT DEFAULT 0,
    HasGripVariation    BIT DEFAULT 0,
    Notes               NVARCHAR(500)
);

-- Many-to-many: Exercise affects multiple body regions
CREATE TABLE ExerciseBodyRegion (
    ExerciseID      INT FOREIGN KEY REFERENCES Exercise(ExerciseID),
    RegionID        INT FOREIGN KEY REFERENCES BodyRegion(RegionID),
    IsPrimary       BIT DEFAULT 1,
    PRIMARY KEY (ExerciseID, RegionID)
);

-- =============================================
-- PROGRAM STRUCTURE
-- =============================================

CREATE TABLE Quarter (
    QuarterID       INT IDENTITY(1,1) PRIMARY KEY,
    QuarterName     NVARCHAR(100) NOT NULL,
    Focus           NVARCHAR(200),
    CycleLengthDays INT NOT NULL,
    StartDate       DATE,
    EndDate         DATE
);

CREATE TABLE CycleDay (
    CycleDayID      INT IDENTITY(1,1) PRIMARY KEY,
    QuarterID       INT FOREIGN KEY REFERENCES Quarter(QuarterID),
    DayNumber       INT NOT NULL,
    DayName         NVARCHAR(100) NOT NULL,
    DayType         NVARCHAR(50)  NOT NULL,   -- 'Training', 'CNS Recovery', 'Full Rest', 'Optional Regen'
    IsRestDay       BIT DEFAULT 0
);

CREATE TABLE DayExercise (
    DayExerciseID   INT IDENTITY(1,1) PRIMARY KEY,
    CycleDayID      INT FOREIGN KEY REFERENCES CycleDay(CycleDayID),
    ExerciseID      INT FOREIGN KEY REFERENCES Exercise(ExerciseID),
    OrderLetter     NVARCHAR(5) NOT NULL,
    PrescribedSets  INT,
    PrescribedReps  INT,
    PrescribedSecs  INT,
    RepRangeMin     INT,
    RepRangeMax     INT,
    TimeRangeMin    INT,
    TimeRangeMax    INT,
    LoadKg          DECIMAL(6,2),
    LoadType        NVARCHAR(50),
    RestSeconds     INT,
    RestSecMax      INT,
    GripSequence    NVARCHAR(200),
    IsClusterSet    BIT DEFAULT 0,
    ClusterReps     INT,
    ClusterRestSecs INT,
    Notes           NVARCHAR(500)
);

-- =============================================
-- WORKOUT LOGGING
-- =============================================

CREATE TABLE WorkoutSession (
    SessionID       INT IDENTITY(1,1) PRIMARY KEY,
    SessionDate     DATE NOT NULL,
    QuarterID       INT FOREIGN KEY REFERENCES Quarter(QuarterID),
    CycleDayID      INT FOREIGN KEY REFERENCES CycleDay(CycleDayID),
    CycleNumber     INT NOT NULL DEFAULT 1,
    StartTime       TIME,
    EndTime         TIME,
    OverallFeeling  TINYINT CHECK (OverallFeeling BETWEEN 1 AND 5),
    Notes           NVARCHAR(500),
    CreatedAt       DATETIME DEFAULT GETDATE()
);

CREATE TABLE ExerciseEntry (
    EntryID         INT IDENTITY(1,1) PRIMARY KEY,
    SessionID       INT FOREIGN KEY REFERENCES WorkoutSession(SessionID),
    DayExerciseID   INT FOREIGN KEY REFERENCES DayExercise(DayExerciseID),
    OrderLetter     NVARCHAR(5),
    Skipped         BIT DEFAULT 0,
    SkipReason      NVARCHAR(200),
    Notes           NVARCHAR(300)
);

CREATE TABLE SetEntry (
    SetEntryID          INT IDENTITY(1,1) PRIMARY KEY,
    EntryID             INT FOREIGN KEY REFERENCES ExerciseEntry(EntryID),
    SetNumber           INT NOT NULL,
    GripUsed            NVARCHAR(50),
    LoadKgUsed          DECIMAL(6,2),
    RepsCompleted       INT,
    SecsCompleted       INT,
    Side                NVARCHAR(10),         -- 'Left', 'Right', 'Both'
    PerformanceRating   TINYINT CHECK (PerformanceRating BETWEEN 1 AND 4),
    -- 1 = Failed
    -- 2 = Completed but degraded
    -- 3 = Completed as prescribed
    -- 4 = Completed clean — ready to progress
    SpeedMaintained     BIT,
    Notes               NVARCHAR(200)
);

CREATE TABLE ClusterRepEntry (
    ClusterRepID    INT IDENTITY(1,1) PRIMARY KEY,
    SetEntryID      INT FOREIGN KEY REFERENCES SetEntry(SetEntryID),
    ClusterNumber   INT NOT NULL,
    RepNumber       INT NOT NULL,
    Completed       BIT DEFAULT 1,
    Notes           NVARCHAR(200)
);

-- =============================================
-- FATIGUE TRACKING
-- =============================================

CREATE TABLE FatigueLog (
    FatigueID               INT IDENTITY(1,1) PRIMARY KEY,
    LogDate                 DATE NOT NULL,
    RegionID                INT FOREIGN KEY REFERENCES BodyRegion(RegionID),
    SessionID               INT FOREIGN KEY REFERENCES WorkoutSession(SessionID),
    FatigueScore            DECIMAL(4,2),
    EstimatedRecoveryDate   DATE,
    Notes                   NVARCHAR(300)
);

-- =============================================
-- PROGRESSION TRACKING
-- =============================================

CREATE TABLE ProgressionLog (
    ProgressionID   INT IDENTITY(1,1) PRIMARY KEY,
    ExerciseID      INT FOREIGN KEY REFERENCES Exercise(ExerciseID),
    SessionID       INT FOREIGN KEY REFERENCES WorkoutSession(SessionID),
    LogDate         DATE NOT NULL,
    PreviousLoad    DECIMAL(6,2),
    NewLoad         DECIMAL(6,2),
    PreviousReps    INT,
    NewReps         INT,
    PreviousSecs    INT,
    NewSecs         INT,
    ProgressionType NVARCHAR(100),
    TriggerRating   TINYINT,
    Notes           NVARCHAR(300)
);
GO

-- =============================================
-- VERIFY
-- =============================================

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO
