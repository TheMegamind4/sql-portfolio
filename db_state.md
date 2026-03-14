# Megamind — Database State
> Update this file every time the database structure or data changes.
> Paste this into Claude at the start of any session involving database work.
> Last updated: Session 001 — 14 March 2026

---

## Local SQL Server Details
- **Server:** localhost
- **Instance:** MSSQLSERVER
- **Service startup:** Manual (start before working, stop after)
- **SSMS connection:** localhost with Trust Server Certificate checked

---

## LearningDB (Practice Database)
Status: EXISTS on local machine — used for initial learning only

| Table | Status | Data |
|-------|--------|------|
| Employees | Created | 10 rows inserted |
| Departments | Created | 5 rows inserted |
| Locations | Created | 4 rows inserted |

Queries run against LearningDB so far:
- Basic CREATE TABLE, INSERT, SELECT verified working
- 3-table JOIN across Employees, Departments, Locations — working

---

## Megamind (Main Database)
Status: **DOES NOT EXIST YET on local machine**
Scripts are written and in the repo but have NOT been run in SSMS.

### Scripts ready to run
| Script | Status | Run Order |
|--------|--------|-----------|
| megamind_setup.sql | Ready — not run yet | 1st |
| megamind_workout_schema_v2.sql | Ready — not run yet | 2nd |

---

## What megamind_setup.sql will create

### Learning Module
| Table | Columns | Notes |
|-------|---------|-------|
| ConversationLog | SessionID, SessionDate, SessionNumber, TopicsCovered, Summary, KeyConcepts, NextSession, DifficultyLevel, CreatedAt | Tracks every Claude learning session |
| LearningTopics | TopicID, SessionID(FK), TopicName, Category, NeedsRevision, InterviewReady, Notes, CreatedAt | Individual concepts per session |

### Job Search Module
| Table | Columns | Notes |
|-------|---------|-------|
| JobApplications | ApplicationID, AppliedDate, CompanyName, RoleTitle, Platform, Status, SalaryExpected, JobURL, Notes, CreatedAt | Status values: Applied, Shortlisted, Interview, Rejected, Offer |
| InterviewLog | InterviewID, ApplicationID(FK), InterviewDate, Round, Outcome, Notes, CreatedAt | Tracks each interview round |

### Finance Module
| Table | Columns | Notes |
|-------|---------|-------|
| Transactions | TransactionID, TransactionDate, Amount, Type, Category, Description, CreatedAt | Type: Income or Expense |
| FinanceGoals | GoalID, GoalName, TargetAmount, CurrentAmount, Deadline, Status, CreatedAt | Default status: Active |

### Placeholder Health Tables (simple — real workout system is in v2 script)
| Table | Columns | Notes |
|-------|---------|-------|
| WorkoutLog | WorkoutID, WorkoutDate, WorkoutType, DurationMinutes, Notes, CreatedAt | Basic placeholder only |
| ExerciseLog | ExerciseID, WorkoutID(FK), ExerciseName, Sets, Reps, WeightKg, Notes | Basic placeholder only |
| BodyMetrics | MetricID, RecordDate, WeightKg, Notes, CreatedAt | Weight tracking |

---

## What megamind_workout_schema_v2.sql will create

### Reference Tables (definitions — populated with data by the script)
| Table | Status after script runs | Row count |
|-------|--------------------------|-----------|
| BodyRegion | Populated | 26 rows |
| SetProtocol | Populated | 6 rows |
| ExerciseIntent | Populated | 6 rows |
| MeasurementType | Populated | 2 rows |
| ProgressionRule | Populated | 7 rows |

### Program Structure Tables
| Table | Status after script runs | Row count |
|-------|--------------------------|-----------|
| Quarter | Populated | 4 rows (Q1 Tendon, Q2 Neural, Q3 placeholder, Q4 placeholder) |
| CycleDay | Populated | 17 rows (8 for Q1 + 9 for Q2) |
| Exercise | Populated | 60+ rows — all exercises from Q1 and Q2 programs |
| ExerciseBodyRegion | **EMPTY — needs manual population** | 0 rows |
| DayExercise | **EMPTY — needs manual population** | 0 rows |

### Logging Tables (all empty until workouts are logged)
| Table | Status after script runs |
|-------|--------------------------|
| WorkoutSession | Empty |
| ExerciseEntry | Empty |
| SetEntry | Empty |
| ClusterRepEntry | Empty |

### Intelligence Tables (all empty until data exists to calculate from)
| Table | Status after script runs |
|-------|--------------------------|
| FatigueLog | Empty |
| ProgressionLog | Empty |

---

## Quarter Structure

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
- [ ] Run megamind_setup.sql in SSMS
- [ ] Run megamind_workout_schema_v2.sql in SSMS
- [ ] Populate ExerciseBodyRegion — map every exercise to its body regions
- [ ] Populate DayExercise — full prescription for every exercise in Q1 and Q2 cycle days
- [ ] Insert first ConversationLog row for Session 001
