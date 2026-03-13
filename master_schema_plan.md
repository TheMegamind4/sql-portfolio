# Megamind Database — Master Schema Plan

## Overview

A unified personal SQL Server database that grows across all projects.
Every module connects into one central database. Python UI sits on top.
Jarvis (AI + voice layer) connects to everything in the future.

---

## Database Name
```
Megamind
```

---

## Full Architecture

```
JARVIS (future — AI + Voice layer)
              |
    Python Desktop Application (UI)
              |
       SQL Server: Megamind
   |          |          |          |
Learning   Workout    Finance     Job
 System    System     Tracker    Tracker
```

---

## Module Build Order

| Priority | Module | Reason |
|----------|--------|--------|
| 1 | Learning System | Needed from day 1 of sessions |
| 2 | Job Tracker | Actively job hunting right now |
| 3 | Workout System | Most complex — deserves its own script |
| 4 | Finance Tracker | Daily use, analytics heavy |

---

## Module 1 — Learning System

Tracks every learning session with Claude and individual concepts learned.

### ConversationLog
```sql
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
```

### LearningTopics
Individual concepts per session, flagged for revision and interview readiness.

```sql
CREATE TABLE LearningTopics (
    TopicID         INT IDENTITY(1,1) PRIMARY KEY,
    SessionID       INT FOREIGN KEY REFERENCES ConversationLog(SessionID),
    TopicName       NVARCHAR(200) NOT NULL,
    Category        NVARCHAR(100),  -- 'SQL', 'Python', 'DE Concepts' etc
    NeedsRevision   BIT DEFAULT 0,
    InterviewReady  BIT DEFAULT 0,
    Notes           NVARCHAR(1000),
    CreatedAt       DATETIME DEFAULT GETDATE()
);
```

---

## Module 2 — Job Search System

Built early because job hunting is active right now.

### JobApplications
```sql
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
```

### InterviewLog
Tracks every interview round per application.

```sql
CREATE TABLE InterviewLog (
    InterviewID     INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationID   INT FOREIGN KEY REFERENCES JobApplications(ApplicationID),
    InterviewDate   DATE,
    Round           NVARCHAR(100),   -- 'HR Screening', 'Technical Round 1' etc
    Outcome         NVARCHAR(50),    -- 'Passed', 'Failed', 'Pending'
    Notes           NVARCHAR(500),
    CreatedAt       DATETIME DEFAULT GETDATE()
);
```

---

## Module 3 — Workout System

This is NOT a standard workout tracker.
It is a periodized strength science system built on physiological principles.
Full schema lives in megamind_workout_schema_v2.sql.

### The Year Plan — Correct Order (non-negotiable for injury prevention)
```
Q1 — Tendon Conditioning          (8 day cycle)
Q2 — Neural Strength & Explosive  (9 day cycle)
Q3 — Type 2x + Neural Mix         (paired — similar training style)
Q4 — Hypertrophy                  (CSA growth on full foundation)
```

Tendon foundation must be built before neural and explosive loading.
Reversing this order causes injury.

### Fatigue Types Tracked
| Type | Scope | Recovery Window |
|------|-------|----------------|
| CNS | Systemic — affects all explosive work | 72 hours |
| Muscle | Localized per region | 48 hours |
| Tendon | Localized, accumulates silently | 96 hours |

### Performance Rating System (objective — not subjective feeling)
```
1 = Failed
2 = Completed but degraded — form broke or speed dropped
3 = Completed as prescribed
4 = Completed clean — ready to progress
```

### Progression Logic
```
Rating 4 for 2 consecutive sessions → suggest progression
Rating 1 or 2 → flag for deload or hold
Rating 3 → maintain current load
Neural and Explosive exercises → Speed Must Maintain rule
```

### Reference Tables
| Table | Purpose |
|-------|---------|
| BodyRegion | 26 body regions with recovery hours per type |
| SetProtocol | Normal, Cluster, Isometric, Eccentric, Drop Set, Mobility |
| ExerciseIntent | Explosive, Eccentric, Isometric, Strength, Activation, Mobility |
| MeasurementType | Reps or Time based |
| ProgressionRule | 7 rules covering all exercise progression types |

### Program Structure Tables
| Table | Purpose |
|-------|---------|
| Quarter | Q1 through Q4 with cycle length and focus |
| CycleDay | Each day in the cycle with type — Training, CNS Recovery, Full Rest, Optional Regen |
| Exercise | Complete exercise library — 60+ exercises pre-mapped from Q1 and Q2 programs |
| ExerciseBodyRegion | Many-to-many — each exercise mapped to its affected body regions |
| DayExercise | Full prescription per exercise per cycle day — sets, reps, time, load, rest, grip |

### Logging Tables
| Table | Purpose |
|-------|---------|
| WorkoutSession | Each actual session with date, cycle number, quarter |
| ExerciseEntry | Each exercise within a session — includes skip tracking |
| SetEntry | Each set — actual load, reps or time, performance rating, speed maintained flag |
| ClusterRepEntry | Individual rep tracking inside cluster sets |

### Intelligence Tables
| Table | Purpose |
|-------|---------|
| FatigueLog | Calculated fatigue score per body region per date — inferred from performance |
| ProgressionLog | Full history of every progression made with trigger rating |

### Special Schema Decisions
- Cluster sets — intra-rep rest tracked separately in ClusterRepEntry
- Grip variation — logged per set in SetEntry
- Unilateral exercises — left and right tracked as separate rows with Side column
- Range prescriptions — min and max stored for reps (RepRangeMin, RepRangeMax) and time (TimeRangeMin, TimeRangeMax)
- Rest ranges — RestSeconds and RestSecMax stored
- Date is mandatory for fatigue calculation — fatigue decays based on hours elapsed since session

---

## Module 4 — Finance System

### Transactions
Every income and expense with category tagging.

```sql
CREATE TABLE Transactions (
    TransactionID   INT IDENTITY(1,1) PRIMARY KEY,
    TransactionDate DATE NOT NULL,
    Amount          DECIMAL(10,2) NOT NULL,
    Type            NVARCHAR(10) CHECK (Type IN ('Income','Expense')),
    Category        NVARCHAR(100),  -- 'Food', 'Transport', 'Salary' etc
    Description     NVARCHAR(300),
    CreatedAt       DATETIME DEFAULT GETDATE()
);
```

### FinanceGoals
Savings and financial goals with progress tracking.

```sql
CREATE TABLE FinanceGoals (
    GoalID          INT IDENTITY(1,1) PRIMARY KEY,
    GoalName        NVARCHAR(200) NOT NULL,
    TargetAmount    DECIMAL(10,2),
    CurrentAmount   DECIMAL(10,2) DEFAULT 0,
    Deadline        DATE,
    Status          NVARCHAR(20) DEFAULT 'Active',
    CreatedAt       DATETIME DEFAULT GETDATE()
);
```

---

## SQL Files in This Repo

| File | Purpose | Run Order |
|------|---------|-----------|
| megamind_setup.sql | Creates Megamind DB + Learning, Job, Finance tables | First |
| megamind_workout_schema_v2.sql | Full workout module with all reference data | Second |

---

## Future — Jarvis Layer

When Jarvis is built it will sit above the Python UI as an AI and voice interface.
It will read from all modules to have a full picture of Abhiram's life:

- ConversationLog — learning progress, what was studied, what needs revision
- JobApplications and InterviewLog — job search status, upcoming interviews
- WorkoutSession and FatigueLog — training state, recovery status, next recommended session
- Transactions and FinanceGoals — financial awareness, goal progress

The Megamind database being built now is not just a tracker.
It is the long-term memory that will power Jarvis.
Every table designed today is designed with that future use in mind.
