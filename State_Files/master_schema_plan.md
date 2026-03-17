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

## Script Run Order

| Order | File | Purpose |
|-------|------|---------|
| 1 | megamind_master_schema.sql | Core DB + ConversationLog, Job, Finance tables |
| 2 | megamind_learning_schema.sql | Learning system — drops LearningTopics, creates 8 new tables |
| 3 | megamind_workout_schema.sql | All workout table definitions |
| 4 | megamind_workout_population.sql | Workout dimension and program data |
| 5 | megamind_learning_population.sql | Learning dimension data — topics, subtopics, concepts |
| Per session | session_XXX_log.sql | ConversationLog + SessionConcept + ConceptProgress |

---

## Module 1 — Learning System

Fully redesigned in Session 004. Replaces the old flat LearningTopics table with a properly normalized system.
Goal: reduce dependency on context.md — all learning progress queryable directly from Megamind.

### Table Architecture

```
Topic
  └── SubTopic
        └── Concept ──── ConceptPrerequisite (self-referencing bridge)
              |
              ├── ConceptProgress  (one row per concept, current state)
              └── ProblemBank      (practice problems and interview questions)
                        |
                        └── PracticeLog (attempts against problems)

ConversationLog
  └── SessionConcept (bridge — what was covered in each session)
        └── PracticeLog (also references SessionID)
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
Top level subject area.

| Column | Type | Notes |
|--------|------|-------|
| TopicID | INT IDENTITY PK | |
| TopicName | NVARCHAR(100) | e.g. SQL, Python, Tools |
| Category | NVARCHAR(50) | Technical, Domain, Tools |
| Description | NVARCHAR(300) | One line about the topic |
| IsActive | BIT | 1 = currently studying |
| CreatedAt | DATETIME | |

### SubTopic
Grouping layer between Topic and Concept.

| Column | Type | Notes |
|--------|------|-------|
| SubTopicID | INT IDENTITY PK | |
| TopicID | INT FK | References Topic |
| SubTopicName | NVARCHAR(100) | e.g. Window Functions, CTEs |
| OrderSequence | INT | Recommended learning order |
| CreatedAt | DATETIME | |

### Concept
Individual learnable unit — the core of the system.

| Column | Type | Notes |
|--------|------|-------|
| ConceptID | INT IDENTITY PK | |
| SubTopicID | INT FK | References SubTopic |
| ConceptName | NVARCHAR(200) | |
| Difficulty | NVARCHAR(20) | Basic / Intermediate / Advanced |
| LearningType | NVARCHAR(20) | Theory / Practice / Experience |
| InterviewImportance | TINYINT | 1-5 |
| EstimatedSessions | INT | Sessions to reach Interview Ready |
| Notes | NVARCHAR(1000) | Key context about this concept |
| CreatedAt | DATETIME | |

### ConceptPrerequisite
Self-referencing bridge — one concept can have multiple prerequisites.

| Column | Type | Notes |
|--------|------|-------|
| ConceptID | INT FK PK | References Concept |
| PrerequisiteConceptID | INT FK PK | References Concept |

### ProblemBank
All practice problems and interview questions in one place.

| Column | Type | Notes |
|--------|------|-------|
| ProblemID | INT IDENTITY PK | |
| ConceptID | INT FK | References Concept |
| ProblemDescription | NVARCHAR(2000) | The problem |
| Difficulty | NVARCHAR(20) | Basic / Intermediate / Advanced |
| ProblemType | NVARCHAR(20) | Practice / Interview |
| ExpectedOutput | NVARCHAR(1000) | What a good answer looks like |
| Notes | NVARCHAR(500) | |
| CreatedAt | DATETIME | |

### ConceptProgress
One row per concept — current learning state. Auto-updated each session.

| Column | Type | Notes |
|--------|------|-------|
| ProgressID | INT IDENTITY PK | |
| ConceptID | INT FK UNIQUE | References Concept |
| Status | NVARCHAR(30) | Not Started / In Progress / Needs Revision / Interview Ready |
| TimesPracticed | INT | Increments each session |
| LastPracticed | DATE | |
| RevisionDueDate | DATE | Spaced repetition — when to revise |
| CreatedAt | DATETIME | |
| UpdatedAt | DATETIME | |

### PracticeLog
Every individual problem attempt — tied to problem and session.

| Column | Type | Notes |
|--------|------|-------|
| PracticeID | INT IDENTITY PK | |
| ProblemID | INT FK | References ProblemBank |
| SessionID | INT FK | References ConversationLog |
| SolvedIndependently | BIT | 1 = no hints needed |
| TimeTakenMins | INT | |
| Notes | NVARCHAR(500) | |
| CreatedAt | DATETIME | |

### SessionConcept
Bridge between sessions and concepts — full history of what was covered when.

| Column | Type | Notes |
|--------|------|-------|
| SessionConceptID | INT IDENTITY PK | |
| SessionID | INT FK | References ConversationLog |
| ConceptID | INT FK | References Concept |
| DepthReached | TINYINT | 1 = surface, 5 = deep |
| InterviewReadinessAfter | TINYINT | 1-5 readiness score after this session |
| Notes | NVARCHAR(500) | |
| CreatedAt | DATETIME | |

### Current Learning Data
- 3 Topics (SQL active, Python and Tools future scope)
- 16 SubTopics under SQL
- 121 Concepts — complete SQL Developer syllabus
- 45 prerequisite mappings
- 121 ConceptProgress rows initialized at Not Started
- 11 concepts updated to In Progress after Session 004

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

Full schema in megamind_workout_schema.sql. Population in megamind_workout_population.sql.

### The Year Plan — Correct Order
```
Q1 — Tendon Conditioning          (8 day cycle)
Q2 — Neural Strength & Explosive  (9 day cycle)
Q3 — Type 2x + Neural Mix
Q4 — Hypertrophy
```

### Reference Tables
| Table | Rows | Purpose |
|-------|------|---------|
| BodyRegion | 26 | Body regions with recovery hours |
| SetProtocol | 6 | Normal, Cluster, Isometric, Eccentric, Drop, Mobility |
| ExerciseIntent | 6 | Explosive, Eccentric, Isometric, Strength, Activation, Mobility |
| MeasurementType | 2 | Reps, Time |
| ProgressionRule | 7 | All progression types including Speed Must Maintain |

### Program Structure Tables
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
| Category | NVARCHAR(100) | Food, Transport, Salary etc |
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

When Jarvis is built it will sit above the Python UI as an AI and voice interface.
It will read from all modules:

- ConversationLog + SessionConcept — learning progress and history
- ConceptProgress — what needs revision today (RevisionDueDate)
- JobApplications and InterviewLog — job search status
- WorkoutSession and FatigueLog — training state and recovery
- Transactions and FinanceGoals — financial awareness

The Megamind database is the long-term memory that powers Jarvis.
Every table designed today is designed with that future use in mind.
