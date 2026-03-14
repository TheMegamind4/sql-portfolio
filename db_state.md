# Megamind — Database State
> Update this file every time the database structure or data changes.
> Paste this into Claude at the start of any session involving database work.
> Last updated: Session 002 — 14 March 2026

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

Queries run against LearningDB:
- Basic CREATE TABLE, INSERT, SELECT verified working
- 3-table JOIN across Employees, Departments, Locations — working

---

## Megamind (Main Database)
Status: **LIVE on local machine — created Session 002**
Total tables: **22**

---

## Tables from megamind_setup.sql

### ConversationLog
| Column | Type | Notes |
|--------|------|-------|
| SessionID | INT IDENTITY PK | Auto increment |
| SessionDate | DATE NOT NULL | Date of the actual session |
| SessionNumber | INT NOT NULL | Sequential session number |
| SessionTitle | NVARCHAR(200) | Short title — added via ALTER TABLE Session 002 |
| TopicsCovered | NVARCHAR(500) | Comma separated topics |
| Summary | NVARCHAR(2000) | Full session summary |
| KeyConcepts | NVARCHAR(1000) | Concepts covered |
| NextSession | NVARCHAR(500) | What to do next |
| DifficultyLevel | TINYINT | 1-5 check constraint |
| CreatedAt | DATETIME | Default GETDATE() |

**Current data: 2 rows**
- Session 001 — 2026-03-13 — Environment Setup and Megamind Architecture
- Session 002 — 2026-03-14 — Context System Design and Database Execution

### LearningTopics
| Column | Type | Notes |
|--------|------|-------|
| TopicID | INT IDENTITY PK | Auto increment |
| SessionID | INT FK | References ConversationLog |
| TopicName | NVARCHAR(200) NOT NULL | Concept name |
| Category | NVARCHAR(100) | SQL, Python, Tools, Domain etc |
| NeedsRevision | BIT | 0 = no, 1 = yes |
| InterviewReady | BIT | 0 = no, 1 = yes |
| Notes | NVARCHAR(1000) | Context notes |
| CreatedAt | DATETIME | Default GETDATE() |

**Current data: 11 rows**
- Session 1: SQL Server Installation, SSMS Setup, Git/GitHub Setup, Database Schema Design (NeedsRevision=1), Normalization Concepts (NeedsRevision=1), Periodized Training Science, Fatigue Tracking System Design (NeedsRevision=1)
- Session 2: ALTER TABLE (InterviewReady=1), DROP and RECREATE TABLE (InterviewReady=1), Foreign Key Dependencies (InterviewReady=1), Context Management System

### JobApplications
**Current data: 0 rows** — table exists, ready for entries

| Column | Type | Notes |
|--------|------|-------|
| ApplicationID | INT IDENTITY PK | |
| AppliedDate | DATE NOT NULL | |
| CompanyName | NVARCHAR(200) NOT NULL | |
| RoleTitle | NVARCHAR(200) NOT NULL | |
| Platform | NVARCHAR(100) | LinkedIn, Naukri etc |
| Status | NVARCHAR(50) | Default: Applied. Values: Applied, Shortlisted, Interview, Rejected, Offer |
| SalaryExpected | DECIMAL(10,2) | |
| JobURL | NVARCHAR(500) | |
| Notes | NVARCHAR(500) | |
| CreatedAt | DATETIME | Default GETDATE() |

### InterviewLog
**Current data: 0 rows** — table exists, ready for entries

### Transactions
**Current data: 0 rows** — table exists, ready for entries

### FinanceGoals
**Current data: 0 rows** — table exists, ready for entries

---

## Tables from megamind_workout_schema_v2.sql

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
| Exercise | 60+ | All exercises from Q1 and Q2 programs pre-mapped |
| ExerciseBodyRegion | **0 — NEEDS POPULATION** | Maps exercises to body regions |
| DayExercise | **0 — NEEDS POPULATION** | Full prescription per exercise per cycle day |

### Logging Tables — All Empty
| Table | Rows | Notes |
|-------|------|-------|
| WorkoutSession | 0 | Ready for use once ExerciseBodyRegion and DayExercise populated |
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

## Pending Database Work
- [ ] Populate ExerciseBodyRegion — map every exercise to its body regions
- [ ] Populate DayExercise — full prescription for every exercise in Q1 and Q2
- [ ] Start inserting JobApplications — actively job hunting
- [ ] Insert Session 003 into ConversationLog after next session
