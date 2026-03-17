# Megamind Database — Master Schema Plan
> Last updated: Session 005 — 17 March 2026

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

## Script Run Order (fresh setup)

| Order | File | Purpose |
|-------|------|---------|
| 1 | Schema/master_schema.sql | Core DB + ConversationLog, Job, Finance tables |
| 2 | Schema/learning_schema.sql | Learning system — all 8 tables including QuestionBank |
| 3 | Schema/workout_schema.sql | All workout table definitions |
| 4 | Dimension/Workout/workout_population.sql | Workout dimension and program data |
| 5 | Dimension/Learning/learning_population.sql | Learning dimension data |
| Per session | SessionLogs/session_XXX_log.sql | ConversationLog + SessionConcept + ConceptProgress |
| Per concept | QuestionBank/concept_XXX_questions.sql | QuestionBank inserts after each concept taught |
| Per assessment | SessionLogs/session_XXX_practicelog.sql | PracticeLog inserts after each assessment |

---

## Module 1 — Learning System

Designed Session 004. QuestionBank naming finalized Session 005.
Goal: reduce dependency on context.md — all learning progress queryable directly from Megamind.

### Table Architecture

```
Topic
  └── SubTopic
        └── Concept ──── ConceptPrerequisite (self-referencing bridge)
              |
              ├── ConceptProgress  (one row per concept, current state)
              └── QuestionBank     (questions generated per concept per session)
                        |
                        └── PracticeLog (assessment attempts — one row per question attempt)

ConversationLog
  └── SessionConcept (bridge — what was covered in each session)
```

### ConversationLog
Core session tracking. Shared by learning and workout systems.

| Column | Type | Notes |
|--------|------|-------|
| SessionID | INT IDENTITY PK | Auto increment |
| SessionDate | DATE NOT NULL | Date of the session |
| SessionNumber | INT NOT NULL | Sequential session number |
| SessionTitle | NVARCHAR(200) | Short title |
| TopicsCovered | NVARCHAR(500) | Comma separated topics |
| Summary | NVARCHAR(2000) | Full session summary |
| KeyConcepts | NVARCHAR(1000) | Concepts covered |
| NextSession | NVARCHAR(500) | What to do next |
| DifficultyLevel | TINYINT | 1-5 check constraint |
| CreatedAt | DATETIME | Default GETDATE() |

### Topic
| Column | Type | Notes |
|--------|------|-------|
| TopicID | INT IDENTITY PK | |
| TopicName | NVARCHAR(100) | e.g. SQL, Python, Tools |
| Category | NVARCHAR(50) | Technical, Domain, Tools |
| Description | NVARCHAR(300) | |
| IsActive | BIT | 1 = currently studying |
| CreatedAt | DATETIME | |

### SubTopic
| Column | Type | Notes |
|--------|------|-------|
| SubTopicID | INT IDENTITY PK | |
| TopicID | INT FK | References Topic |
| SubTopicName | NVARCHAR(100) | e.g. Window Functions, CTEs |
| OrderSequence | INT | Recommended learning order |
| CreatedAt | DATETIME | |

### Concept
| Column | Type | Notes |
|--------|------|-------|
| ConceptID | INT IDENTITY PK | |
| SubTopicID | INT FK | References SubTopic |
| ConceptName | NVARCHAR(200) | |
| Difficulty | NVARCHAR(20) | Basic / Intermediate / Advanced |
| LearningType | NVARCHAR(20) | Theory / Practice / Experience |
| InterviewImportance | TINYINT | 1-5 |
| EstimatedSessions | INT | Sessions to reach Interview Ready |
| Notes | NVARCHAR(1000) | |
| CreatedAt | DATETIME | |

### ConceptPrerequisite
| Column | Type | Notes |
|--------|------|-------|
| ConceptID | INT FK PK | References Concept |
| PrerequisiteConceptID | INT FK PK | References Concept |

### QuestionBank
Questions generated per concept after each teaching session.
Generation rules documented in State_Files/QuestionBank_Context.md.

| Column | Type | Notes |
|--------|------|-------|
| QuestionID | INT IDENTITY PK | |
| ConceptID | INT FK | References Concept |
| QuestionDescription | NVARCHAR(2000) | Full question with output columns and hint |
| Difficulty | NVARCHAR(20) | Basic / Intermediate / Advanced |
| QuestionType | NVARCHAR(20) | Practice / Interview |
| ExpectedOutput | NVARCHAR(1000) | Result shape and row count |
| Notes | NVARCHAR(500) | Teaching note and interview context |
| CreatedAt | DATETIME | Default GETDATE() |

### ConceptProgress
One row per concept — current learning state.

| Column | Type | Notes |
|--------|------|-------|
| ProgressID | INT IDENTITY PK | |
| ConceptID | INT FK UNIQUE | References Concept |
| Status | NVARCHAR(30) | Not Started / In Progress / Needs Revision / Interview Ready |
| TimesPracticed | INT | Increments each session |
| LastPracticed | DATE | |
| RevisionDueDate | DATE | Spaced repetition |
| CreatedAt | DATETIME | |
| UpdatedAt | DATETIME | |

### PracticeLog
Every individual assessment attempt — tied to question and session.

| Column | Type | Notes |
|--------|------|-------|
| PracticeID | INT IDENTITY PK | |
| QuestionID | INT FK | References QuestionBank |
| SessionID | INT FK | References ConversationLog |
| SolvedIndependently | BIT | 1 = no hints needed |
| TimeTakenMins | INT | |
| Notes | NVARCHAR(1000) | |
| CreatedAt | DATETIME | |

### SessionConcept
Bridge between sessions and concepts — full coverage history.

| Column | Type | Notes |
|--------|------|-------|
| SessionConceptID | INT IDENTITY PK | |
| SessionID | INT FK | References ConversationLog |
| ConceptID | INT FK | References Concept |
| DepthReached | TINYINT | 1 = surface, 5 = deep |
| InterviewReadinessAfter | TINYINT | 1-5 readiness score |
| Notes | NVARCHAR(1000) | |
| CreatedAt | DATETIME | |

### Current Learning Data
- 3 Topics (SQL active, Python and Tools future scope)
- 16 SubTopics under SQL
- 121 Concepts — complete SQL Developer syllabus
- 46 prerequisite mappings (1 discrepancy vs script — investigate)
- 121 ConceptProgress rows — ConceptID 29 In Progress, rest Not Started
- 5 QuestionBank rows — ConceptID 29

---

## Module 2 — Job Search System

### JobApplications
| Column | Type | Notes |
|--------|------|-------|
| ApplicationID | INT IDENTITY PK | |
| AppliedDate | DATE NOT NULL | |
| CompanyName | NVARCHAR(200) NOT NULL | |
| RoleTitle | NVARCHAR(200) NOT NULL | |
| Platform | NVARCHAR(100) | LinkedIn, Naukri etc |
| Status | NVARCHAR(50) | Applied, Shortlisted, Interview, Rejected, Offer |
| SalaryExpected | DECIMAL(10,2) | |
| JobURL | NVARCHAR(500) | |
| Notes | NVARCHAR(500) | |
| CreatedAt | DATETIME | |

### InterviewLog
| Column | Type | Notes |
|--------|------|-------|
| InterviewID | INT IDENTITY PK | |
| ApplicationID | INT FK | References JobApplications |
| InterviewDate | DATE | |
| Round | NVARCHAR(100) | HR Screening, Technical Round 1 etc |
| Outcome | NVARCHAR(50) | Passed, Failed, Pending |
| Notes | NVARCHAR(500) | |
| CreatedAt | DATETIME | |

---

## Module 3 — Workout System

Full schema in Schema/workout_schema.sql.
Population in Dimension/Workout/workout_population.sql.

### The Year Plan — Correct Order
```
Q1 — Tendon Conditioning          (8 day cycle)
Q2 — Neural Strength & Explosive  (9 day cycle)
Q3 — Type 2x + Neural Mix
Q4 — Hypertrophy
```

### Reference Tables (all populated)
| Table | Rows | Purpose |
|-------|------|---------|
| BodyRegion | 26 | Body regions with recovery hours |
| SetProtocol | 6 | Normal, Cluster, Isometric, Eccentric, Drop, Mobility |
| ExerciseIntent | 6 | Explosive, Eccentric, Isometric, Strength, Activation, Mobility |
| MeasurementType | 2 | Reps, Time |
| ProgressionRule | 7 | All progression types including Speed Must Maintain |

### Program Structure Tables (all populated)
| Table | Rows | Purpose |
|-------|------|---------|
| Quarter | 4 | Q1-Q4 with cycle length and focus |
| CycleDay | 17 | 8 for Q1 + 9 for Q2 |
| Exercise | 65 | Complete exercise library |
| ExerciseBodyRegion | 264 | Exercise to body region mapping |
| DayExercise | 86 | Full prescription per exercise per day |

### Logging Tables (all empty — pending first session log)
- WorkoutSession, ExerciseEntry, SetEntry, ClusterRepEntry

### Intelligence Tables (all empty)
- FatigueLog, ProgressionLog

---

## Module 4 — Finance System

### Transactions
| Column | Type | Notes |
|--------|------|-------|
| TransactionID | INT IDENTITY PK | |
| TransactionDate | DATE NOT NULL | |
| Amount | DECIMAL(10,2) NOT NULL | |
| Type | NVARCHAR(10) | Income / Expense |
| Category | NVARCHAR(100) | |
| Description | NVARCHAR(300) | |
| CreatedAt | DATETIME | |

### FinanceGoals
| Column | Type | Notes |
|--------|------|-------|
| GoalID | INT IDENTITY PK | |
| GoalName | NVARCHAR(200) NOT NULL | |
| TargetAmount | DECIMAL(10,2) | |
| CurrentAmount | DECIMAL(10,2) | Default 0 |
| Deadline | DATE | |
| Status | NVARCHAR(20) | Default Active |
| CreatedAt | DATETIME | |

---

## Future — Jarvis Layer

Jarvis will read from all modules:
- ConversationLog + SessionConcept — learning progress and history
- ConceptProgress — what needs revision today (RevisionDueDate)
- QuestionBank + PracticeLog — assessment history and weak areas
- JobApplications and InterviewLog — job search status
- WorkoutSession and FatigueLog — training state and recovery
- Transactions and FinanceGoals — financial awareness

The Megamind database is the long-term memory that powers Jarvis.
Every table designed today is designed with that future use in mind.
