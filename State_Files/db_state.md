# Megamind — Database State
> Update this file every time the database structure or data changes.
> Paste this into Claude at the start of any session involving database work.
> Last updated: Session 004 — 17 March 2026

---

## Local SQL Server Details
- **Server:** localhost
- **Instance:** MSSQLSERVER
- **Service startup:** Manual (start before working, stop after)
- **SSMS connection:** localhost with Trust Server Certificate checked

---

## LearningDB (Practice Database)
Status: EXISTS — used for initial learning only, not connected to Megamind

| Table | Status | Data |
|-------|--------|------|
| Employees | Created | 10 rows |
| Departments | Created | 5 rows |
| Locations | Created | 4 rows |

---

## Megamind (Main Database)
Status: **LIVE — updated Session 004**
Total tables: **30**

---

## Script Run Order (fresh setup)
| Order | File | Purpose |
|-------|------|---------|
| 1 | megamind_master_schema.sql | Core DB + ConversationLog, Job, Finance tables |
| 2 | megamind_learning_schema.sql | Learning system tables — drops LearningTopics |
| 3 | megamind_workout_schema.sql | Workout table definitions |
| 4 | megamind_workout_population.sql | Workout dimension and program data |
| 5 | megamind_learning_population.sql | Learning dimension data |
| Per session | session_XXX_log.sql | ConversationLog + SessionConcept + ConceptProgress |

---

## Master Schema Tables

### ConversationLog
**Current data: 4 rows**
- Session 001 — 2026-03-13 — Environment Setup and Megamind Architecture
- Session 002 — 2026-03-14 — Context System Design and Database Execution
- Session 003 — 2026-03-15 — Workout Database Population and First Real Queries
- Session 004 — 2026-03-17 — CTEs, Window Functions and Learning Schema Design

### JobApplications
**Current data: 0 rows** — table exists, ready for entries

### InterviewLog
**Current data: 0 rows** — table exists, ready for entries

### Transactions
**Current data: 0 rows** — table exists, ready for entries

### FinanceGoals
**Current data: 0 rows** — table exists, ready for entries

---

## Learning System Tables (new — created Session 004)

### Topic
**Current data: 3 rows**
- SQL (IsActive = 1)
- Python (IsActive = 0)
- Tools (IsActive = 0)

### SubTopic
**Current data: 16 rows** — all under SQL
1. Basic Queries, 2. Joins, 3. CTEs, 4. Window Functions, 5. Indexes,
6. Execution Plans and Statistics, 7. Query Optimization, 8. Stored Procedures,
9. Views and Functions, 10. Transactions and Locking, 11. Error Handling,
12. Dynamic SQL, 13. Triggers, 14. Schema Design and Normalization,
15. Looping and Cursors, 16. T-SQL Miscellaneous

### Concept
**Current data: 121 rows** — complete SQL Developer syllabus
- Basic Queries: 8 concepts
- Joins: 8 concepts
- CTEs: 7 concepts
- Window Functions: 9 concepts
- Indexes: 9 concepts
- Execution Plans and Statistics: 7 concepts
- Query Optimization: 8 concepts
- Stored Procedures: 8 concepts
- Views and Functions: 7 concepts
- Transactions and Locking: 8 concepts
- Error Handling: 5 concepts
- Dynamic SQL: 6 concepts
- Triggers: 6 concepts
- Schema Design and Normalization: 9 concepts
- Looping and Cursors: 6 concepts
- T-SQL Miscellaneous: 10 concepts

### ConceptPrerequisite
**Current data: 45 rows** — prerequisite mappings across all subtopics

### ProblemBank
**Current data: 0 rows** — table exists, population pending

### ConceptProgress
**Current data: 121 rows** — one per concept, initialized at Not Started
- 11 concepts updated to In Progress after Session 004
- RevisionDueDate set to 2026-03-20 for Session 004 concepts

### SessionConcept
**Current data: 11 rows** — Session 004 concepts logged
- Basic CTE syntax, CTE vs subquery, Filtering on aggregated aliases using CTE
- Stacked CTEs, CTE referencing another CTE, CTE combined with Window Functions
- OVER clause, PARTITION BY, ROW_NUMBER, RANK and DENSE_RANK, LAG and LEAD

### PracticeLog
**Current data: 0 rows** — table exists, ready for entries

---

## Workout System Tables

### Reference Tables — All Populated
| Table | Rows | Notes |
|-------|------|-------|
| BodyRegion | 26 | All body regions with recovery hours |
| SetProtocol | 6 | Normal, Cluster, Isometric, Eccentric, Drop, Mobility |
| ExerciseIntent | 6 | Explosive, Eccentric, Isometric, Strength, Activation, Mobility |
| MeasurementType | 2 | Reps, Time |
| ProgressionRule | 7 | All progression types including Speed Must Maintain |

### Program Structure Tables
| Table | Rows | Notes |
|-------|------|-------|
| Quarter | 4 | Q1 Tendon, Q2 Neural, Q3 placeholder, Q4 placeholder |
| CycleDay | 17 | 8 for Q1 + 9 for Q2 |
| Exercise | 65 | All exercises from Q1 and Q2 programs |
| ExerciseBodyRegion | 264 | All exercises mapped to body regions |
| DayExercise | 86 | Full prescription for all training days in Q1 and Q2 |

### Logging Tables — All Empty
| Table | Rows | Notes |
|-------|------|-------|
| WorkoutSession | 0 | Ready for use |
| ExerciseEntry | 0 | |
| SetEntry | 0 | |
| ClusterRepEntry | 0 | |

### Intelligence Tables — All Empty
| Table | Rows | Notes |
|-------|------|-------|
| FatigueLog | 0 | Calculated once workout data exists |
| ProgressionLog | 0 | Populated as progressions happen |

---

## Quarter Structure — Verified Correct

### Q1 — Tendon Conditioning (8 day cycle)
| Day | Name | Type |
|-----|------|------|
| 1 | Pull Structural | Training |
| 2 | Push Structural | Training |
| 3 | Leg Structural | Training |
| 4 | Pull Strength and Transmission | Training |
| 5 | Push Stability | Training |
| 6 | Leg Strength | Training |
| 7 | Rest - Tendon Decompression | Full Rest |
| 8 | Full Rest - Deep Tendon Reset | Full Rest |

### Q2 — Neural Strength (9 day cycle)
| Day | Name | Type |
|-----|------|------|
| 1 | Pull Explosive | Training |
| 2 | Push Strength | Training |
| 3 | Leg Explosive | Training |
| 4 | CNS Recovery | CNS Recovery |
| 5 | Pull Strength | Training |
| 6 | Push Explosive | Training |
| 7 | Leg Strength | Training |
| 8 | Full CNS Reset | Full Rest |
| 9 | Optional Regen | Optional Regen |

---

## Stored Procedures
| Procedure | Purpose |
|-----------|---------|
| usp_GetWorkoutPrescription | Takes @CycleDayID INT. Returns full workout prescription for that day. |

---

## Pending Database Work
- [ ] Populate ProblemBank — practice problems and interview questions per concept
- [ ] Log first real workout session — WorkoutSession, ExerciseEntry, SetEntry
- [ ] Start inserting JobApplications — actively job hunting
- [ ] Build stored procedure for logging a workout session
- [ ] SUM OVER running totals — next SQL learning session
- [ ] Recursive CTEs — next SQL learning session
