# Megamind — Session Log
> Append a new entry after every session.
> When starting a new chat, paste the last 3-5 entries into Claude along with context.md and db_state.md.
> Keep entries factual and brief. What was done, what changed, what is next.

---

## Session 001 — 13 March 2026

**Phase:** Phase 1 Setup + Phase 2 Week 1 start
**SessionTitle:** Environment Setup and Megamind Architecture

### What Was Done
- Installed SQL Server Developer Edition 2025 (instance: MSSQLSERVER, startup set to Manual)
- Installed SSMS 22, connected successfully using server name: localhost
- Installed VS Code with MSSQL extension and Python extension
- Installed Python 3.13.1, Git 2.53
- Created GitHub repo: sql-portfolio (public) under TheMegamind4
- Cloned repo to Documents/sql-portfolio
- Created LearningDB in SSMS — created Employees, Departments, Locations tables, inserted data, ran a 3-table JOIN successfully
- Designed full Megamind database architecture across 4 modules
- Wrote megamind_setup.sql and megamind_workout_schema_v2.sql
- Pushed all files to GitHub

### Decisions Made
- Database name: Megamind
- Q1 = Tendon Conditioning (8 day cycle), Q2 = Neural Strength (9 day cycle) — non-negotiable order
- 30% performance claim on resume to be removed
- All SQL learning done against Megamind directly — no generic dummy exercises

### Mood / State
High energy. Good foundation built. Watch for overambition.

---

## Session 002 — 14 March 2026

**Phase:** Phase 2 Week 1 — Database Execution and Context System
**SessionTitle:** Context System Design and Database Execution

### What Was Done
- Designed 3-file context system: context.md, session_log.md, db_state.md
- Ran megamind_setup.sql — Megamind database created successfully
- Ran megamind_workout_schema_v2.sql — all workout tables created
- Inserted Session 001 and 002 rows into ConversationLog
- Ran first real JOIN query against Megamind

### Decisions Made
- session_log.md and db_state.md added as mandatory context files
- Multiple log entries per day allowed — SessionNumber independent of SessionDate

### Mood / State
Steady and methodical.

---

## Session 003 — 15 March 2026

**Phase:** Phase 2 Week 1 — Database Population and First Real Queries
**SessionTitle:** Workout Database Population and First Real Queries

### What Was Done
- Generated and ran workout_population.sql — ExerciseBodyRegion (264 rows) and DayExercise (86 rows)
- Wrote first real 5-table INNER JOIN against Megamind
- Learned STRING_AGG, WHERE vs HAVING, debugged join fan-out problem
- Created usp_GetWorkoutPrescription stored procedure

### Decisions Made
- Priority for next sessions — CTEs and Window Functions

### Mood / State
Solid. Abhiram wrote queries independently. Watch for: CTEs keep getting pushed.

---

## Session 004 — 17 March 2026

**Phase:** Phase 2 Week 1 — CTEs, Window Functions, Learning Schema Design
**SessionTitle:** CTEs, Window Functions and Learning Schema Design

### What Was Done
- CTEs completed — all 7 concepts from basic syntax through recursive CTEs
- Window Functions completed — OVER, PARTITION BY, ROW_NUMBER, RANK, DENSE_RANK, LAG, LEAD
- 7 hands-on problems written independently against workout tables
- Designed full new Learning System schema — 8 tables replacing LearningTopics
- Reorganized all scripts into 5 clean files with clear run order
- Generated learning_population.sql — 3 Topics, 16 SubTopics, 121 Concepts, 45 prerequisites
- ConceptProgress initialized for all 121 concepts at Not Started

### Decisions Made
- LearningTopics retired — replaced by normalized learning system
- Teaching style: brief theory then straight into problems

### What Changed
- Megamind table count: 22 → 30

### Mood / State
Strong session. Abhiram wrote all queries independently.

---

## Session 005 — 17 March 2026

**Phase:** Phase 2 Week 1 — SUM OVER, QuestionBank System, Script Cleanup
**SessionTitle:** SUM OVER Running Totals, QuestionBank Workflow and Script Reorganization

### What Was Done

**SQL Learning — ConceptID 29 (SUM OVER and AVG OVER):**
- SUM OVER basic running total — practiced and correct
- Multiple window functions in same SELECT — practiced and correct
- PARTITION BY to reset running total per group — practiced and correct
- AVG OVER running average — practiced and correct
- Integer division trap discovered independently — CAST to DECIMAL fix learned
- CTE wrapping window result for CASE comparison — practiced and correct
- Assessment completed — 4 of 5 questions answered correctly
- Question 5 deferred — requires ROWS BETWEEN (ConceptID 30), not yet taught

**QuestionBank System Redesign:**
- ProblemBank renamed to QuestionBank
- Column names updated: ProblemID → QuestionID, ProblemDescription → QuestionDescription, ProblemType → QuestionType
- New per-concept generation workflow established
- PracticeLog updated to reference QuestionBank(QuestionID)
- 5 questions generated and inserted for ConceptID 29

**Script and Folder Reorganization:**
- Full gap analysis performed against live DB snapshot
- learning_schema.sql fixed — QuestionBank replaces ProblemBank, PracticeLog column fixed
- LearningTopics ghost table dropped
- DEV folder structure cleaned and finalized

**Session closed cleanly:**
- ConversationLog — 5 rows ✅
- SessionConcept — 12 rows ✅
- PracticeLog — 4 rows ✅
- QuestionBank — 5 rows ✅
- ConceptProgress In Progress — 12 ✅

### Decisions Made
- ProblemBank → QuestionBank everywhere
- Questions generated per concept per session — not in bulk
- PracticeLog entries only for assessment phase
- Session learning flow locked in: theory → practice → generate questions → assess → log
- File naming: drop megamind_ prefix, use clean short names

### What Changed
- QuestionBank created — 5 rows for ConceptID 29
- PracticeLog: ProblemID → QuestionID, FK updated
- learning_schema.sql regenerated
- LearningTopics dropped
- DEV folder structure reorganized

### What Was NOT Done
- ConceptID 29 Question 5 — deferred to ConceptID 30 session
- ConceptID 30 — ROWS BETWEEN frame clause — not started
- ConceptID 23 — Recursive CTEs — not started
- ConceptPrerequisite discrepancy — 45 in script vs 46 in live DB — not investigated

### Next Session Must Start With
1. ConceptID 29 Question 5 — complete before moving on
2. ConceptID 30 — ROWS BETWEEN frame clause — theory, practice, questions, assessment
3. ConceptID 23 — Recursive CTEs

### Mood / State
Long session — lots of system work alongside learning. System is now clean and repeatable.
All state files accurate. DB and repo in sync.
