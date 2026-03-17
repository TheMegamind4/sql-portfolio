# Megamind — Database State
> Update this file every time the database structure or data changes.
> Paste this into Claude at the start of any session involving database work.
> Last updated: Session 005 — 17 March 2026

---

## Local SQL Server Details
- **Server:** localhost
- **Instance:** MSSQLSERVER
- **Service startup:** Manual (start before working, stop after)
- **SSMS connection:** localhost with Trust Server Certificate checked

---

## LearningDB (Practice Database)
Status: EXISTS — used for initial learning only, not connected to Megamind

---

## Megamind (Main Database)
Status: **LIVE — updated Session 005**
Total tables: **30** (excluding LearningTopics ghost table — pending DROP)

---

## Script Run Order (fresh setup)
| Order | File | Purpose |
|-------|------|---------|
| 1 | Schema/master_schema.sql | Core DB + ConversationLog, Job, Finance tables |
| 2 | Schema/learning_schema.sql | Learning system tables including QuestionBank |
| 3 | Schema/workout_schema.sql | Workout table definitions |
| 4 | Dimension/Workout/workout_population.sql | Workout dimension and program data |
| 5 | Dimension/Learning/learning_population.sql | Learning dimension data |
| Per session | SessionLogs/session_XXX_log.sql | ConversationLog + SessionConcept + ConceptProgress |
| Per concept | QuestionBank/concept_XXX_questions.sql | QuestionBank inserts after each concept taught |
| Per assessment | SessionLogs/session_XXX_practicelog.sql | PracticeLog inserts after each assessment |

---

## Pending One-Time DB Cleanup
```sql
-- Run once on live DB — ghost table from before Session 004
DROP TABLE LearningTopics;
```

---

## Master Schema Tables

### ConversationLog
**Current data: 4 rows** (Session 005 entry pending session log SQL)
- Session 001 — 2026-03-13 — Environment Setup and Megamind Architecture
- Session 002 — 2026-03-14 — Context System Design and Database Execution
- Session 003 — 2026-03-15 — Workout Database Population and First Real Queries
- Session 004 — 2026-03-17 — CTEs, Window Functions and Learning Schema Design

### JobApplications
**Current data: 0 rows**

### InterviewLog
**Current data: 0 rows**

### Transactions
**Current data: 0 rows**

### FinanceGoals
**Current data: 0 rows**

---

## Learning System Tables

### Topic
**Current data: 3 rows**
- SQL (IsActive = 1)
- Python (IsActive = 0)
- Tools (IsActive = 0)

### SubTopic
**Current data: 16 rows** — all under SQL

### Concept
**Current data: 121 rows** — complete SQL Developer syllabus

### ConceptPrerequisite
**Current data: 46 rows**
⚠️ Script inserts 45 rows — one extra mapping exists in live DB. Investigate next session.

### ConceptProgress
**Current data: 121 rows**
- ConceptID 29 — updated to In Progress, Session 005

### SessionConcept
**Current data: 11 rows** — Session 004 concepts
- Session 005 concepts pending session log SQL

### QuestionBank ← renamed from ProblemBank Session 005
**Current data: 5 rows** — ConceptID 29 questions only
- QuestionIDs 1–5 — SUM OVER and AVG OVER running totals

### PracticeLog
**Current data: 0 rows**
- Column renamed: ProblemID → QuestionID (Session 005)
- FK updated to reference QuestionBank(QuestionID)

---

## Workout System Tables

### Reference Tables — All Populated
| Table | Rows |
|-------|------|
| BodyRegion | 26 |
| SetProtocol | 6 |
| ExerciseIntent | 6 |
| MeasurementType | 2 |
| ProgressionRule | 7 |

### Program Structure Tables
| Table | Rows |
|-------|------|
| Quarter | 4 |
| CycleDay | 17 |
| Exercise | 65 |
| ExerciseBodyRegion | 264 |
| DayExercise | 86 |

### Logging Tables — All Empty
| Table | Rows |
|-------|------|
| WorkoutSession | 0 |
| ExerciseEntry | 0 |
| SetEntry | 0 |
| ClusterRepEntry | 0 |

### Intelligence Tables — All Empty
| Table | Rows |
|-------|------|
| FatigueLog | 0 |
| ProgressionLog | 0 |

---

## Stored Procedures
| Procedure | Purpose |
|-----------|---------|
| usp_GetWorkoutPrescription | Takes @CycleDayID INT. Returns full workout prescription for that day. |

---

## Pending Database Work
- [ ] DROP TABLE LearningTopics — ghost table, run manually in SSMS
- [ ] Investigate ConceptPrerequisite count — 45 in script vs 46 in live DB
- [ ] Complete ConceptID 29 assessment — 5 questions ready in QuestionBank
- [ ] ConceptID 30 — ROWS BETWEEN frame clause — not started
- [ ] ConceptID 23 — Recursive CTEs — not started
- [ ] Log Session 005 into ConversationLog — pending session log SQL script
- [ ] First real workout session — WorkoutSession, ExerciseEntry, SetEntry
- [ ] Start inserting JobApplications — actively job hunting
