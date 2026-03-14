# Abhiram's Master Context File
> Paste this at the start of every new chat session with Claude.
> This file is the single source of truth. Update it after every major decision.

---

## Who I Am

- **Name:** Abhiram Krishna S
- **Location:** Kottayam, Kerala, India
- **Current Role:** Software Engineer at Xerox Technology Services India LLP, Kochi
- **Official Job Title:** Software Engineer (not data-specific — general SE title)
- **Experience:** 3 years (Aug 2022 – Present)
- **Education:** B.Tech Mechanical Engineering, College of Engineering Trivandrum, CGPA 7.09
- **GitHub:** TheMegamind4
- **Portfolio Repo:** sql-portfolio (cloned at Documents/sql-portfolio)

---

## My Situation — Honest Assessment

I am a software engineer who lost interest in web development after 3 years. I want to pivot into data roles. My two targets are:

1. **SQL Developer** — immediate goal, actively applying right now
2. **Data Engineer** — longer term goal, 1-2 years away realistically

### What I actually know from Xerox work
- Basic to intermediate T-SQL — SELECT, INSERT, UPDATE, DELETE (real, daily use)
- Stored procedures, views, triggers (real experience, 40+ written)
- ETL pipelines from Excel and JSON sources (real experience)
- XML and XSLT transformations (real experience)
- Schema design and normalization (real experience)
- Query optimization and performance tuning — **NOT done intentionally. Need to learn properly.**
- Indexing strategies — **understand the concept, need hands-on depth**
- Window functions, CTEs — **know they exist, need to build fluency**

### Python DE projects (done approximately 1 year ago, now rusty)
- Air Quality Data Pipeline — REST API → Python → CSV/Parquet output
- Sales Analytics Dashboard — Python pipeline → Streamlit dashboard
- Both are in **private** GitHub repos under TheMegamind4

### What I do NOT have yet
- Dedicated SQL portfolio projects (actively building)
- Measurable performance tuning proof (plan to generate via projects)
- Cloud experience — Azure, AWS (future goal)
- Spark, Airflow, dbt experience (future DE path tools)

---

## Resume Status

Two resumes exist. Both slightly boosted beyond current proven level.
Strategy: get callbacks first, close the skill gap fast before interviews arrive.

### SQL Developer Resume
- Boosted but mostly defensible
- Risk areas that must be learned before interviews:
  - "Query optimization and performance tuning" — learn this in Week 2-3
  - "Execution plan analysis" — learn this in Week 2
  - "30% performance improvement" claim — must be removed or replaced
  - Decision: rewrite as "analyzed and refactored T-SQL queries, implementing non-clustered and covering indexes to reduce execution overhead" — no made-up number
- Projects section is weak — no SQL-specific projects yet
- Everything else (stored procedures, ETL, schema design, 40+ objects, 20+ projects) is real and defensible

### Data Engineer Resume
- More aggressively positioned
- Risk: two Python projects from 1 year ago, significant gap since then
- Applying selectively — not the main focus right now
- Will become honest and strong after SQL Developer role plus 1-2 years experience

---

## The Full Action Plan

### Phase 1 — Setup ✅ COMPLETE
- SQL Server Developer Edition 2025 installed (service: MSSQLSERVER, set to Manual startup)
- SSMS 22 installed and connected successfully (server: localhost)
- VS Code installed with MSSQL extension and Python extension
- Python 3.13.1 installed
- Git 2.53 installed
- GitHub account: TheMegamind4
- sql-portfolio repo created (public) and cloned to Documents/sql-portfolio
- LearningDB created and tested in SSMS — basic CREATE/INSERT/SELECT verified working
- Megamind database fully designed — schema scripts in repo

### Phase 2 — SQL Depth ← CURRENTLY HERE (Weeks 1–4)

**Core principle for all learning in this phase:**
Every SQL concept is learned by writing real queries against the Megamind database.
No generic dummy exercises. Every query has a real purpose tied to a real module.
CTEs against ConversationLog and JobApplications.
Window Functions against WorkoutSession and ProgressionLog.
Indexes and optimization against actual Megamind tables with generated data.
This way learning and building happen simultaneously.

**Week 1 — Complex Queries (in progress)**
- Multi-table JOINs across 3+ tables — started Day 1
- CTEs (Common Table Expressions) — applied to Megamind Learning and Job modules
- Window Functions — ROW_NUMBER, RANK, LAG, LEAD — applied to Megamind Workout and Job modules
- Subqueries vs CTEs — when to use which
- LearningDB has Employees, Departments, Locations tables populated and working

**Week 2 — Indexes and Execution Plans**
- Clustered vs non-clustered vs covering indexes
- Reading execution plans in SSMS
- Table scan vs index seek — what they mean and why they matter
- Applied directly to Megamind tables
- This is the gap that separates junior from mid-level SQL Developer

**Week 3 — Query Optimization and Performance Tuning**
- SARGability — why some WHERE conditions cannot use indexes
- Set-based vs row-based operations
- 50,000 to 100,000 rows generated via Python into Megamind tables
- Real before/after timing measured — this becomes the portfolio proof and the resume metric

**Week 4 — Stored Procedures, Views, Functions Done Properly**
- Error handling with TRY/CATCH
- Transaction management inside procedures
- Scalar vs table-valued functions — why scalar functions destroy performance
- When to use views vs CTEs
- All built as real objects inside Megamind — not throwaway examples

### Phase 3 — Projects (Weeks 5–8)
Megamind modules built out fully.
By this point the schema exists, the learning queries exist, the optimization proof exists.
Phase 3 is completing the Python integration layer on top.
Everything goes into sql-portfolio GitHub repo.

### Phase 4 — SSIS + Light DE Exposure (Weeks 9–11)
- SSIS basics — packages, control flow, data flow, simple ETL
- dbt introduction — SQL-based, modern, DE-relevant
- Do not go deep on SSIS — it is aging technology

### Phase 5 — Resume Update + Apply Properly (Week 12)
- Update resume with real provable project metrics
- Every claim on the resume must have a 60-second story behind it
- Reapply with full confidence

---

## The Megamind Database

A unified personal SQL Server database that is the foundation of everything.
Database name: **Megamind**

### Full Architecture Vision
```
JARVIS (future — AI + Voice interface)
              |
    Python Desktop Application (UI)
              |
       SQL Server: Megamind
   |          |          |          |
Learning   Workout    Finance     Job
 System    System     Tracker    Tracker
```

### Module Build Order
| Priority | Module | Reason |
|----------|--------|--------|
| 1 | Learning System | Needed from day 1 of sessions |
| 2 | Job Tracker | Actively job hunting right now |
| 3 | Workout System | Most complex — build properly |
| 4 | Finance Tracker | Daily use, analytics heavy |

---

## Workout System — Important Details

This is NOT a standard workout tracker.
It is a periodized strength science system based on physiological principles.

### The Year Plan — CORRECT ORDER (injury prevention depends on this)
```
Q1 — Tendon Conditioning          (8 day cycle)
Q2 — Neural Strength & Explosive  (9 day cycle)
Q3 — Type 2x + Neural Mix         (similar training style to Q2, paired)
Q4 — Hypertrophy                  (CSA growth on full foundation)
```

**Why this order is non-negotiable:**
Tendon foundation must be built before neural and explosive loading.
Doing Q2 before Q1 is a direct path to injury.

### Fatigue Types Tracked
| Type | Scope | Recovery Window |
|------|-------|----------------|
| CNS Fatigue | Systemic — affects ALL explosive work | 72 hours |
| Muscle Fatigue | Localized per region | 48 hours |
| Tendon Fatigue | Localized, accumulates silently | 96 hours |

### Performance Rating System (objective — not subjective feeling)
```
1 = Failed — could not complete prescribed reps or time
2 = Completed but degraded — form broke or speed dropped
3 = Completed as prescribed
4 = Completed clean — ready to progress
```
Fatigue is INFERRED from performance patterns across sessions.
It is never logged directly as a feeling.

### Progression Logic
```
Rating 4 for 2 consecutive sessions → suggest progression
Rating 1 or 2 → flag for deload or hold
Rating 3 → maintain current load
Neural and Explosive exercises → Speed Must Maintain rule
Only increase weight if speed is unchanged
```

### Special Schema Requirements
- Cluster sets — intra-rep rest tracked (e.g. (1+1+1) × 3 with 15 sec intra-rep rest)
- Grip variation — logged per set
- Unilateral exercises — left and right tracked separately
- Range prescriptions — min and max stored (e.g. 25-30 sec, 6-8 reps)
- Date is mandatory for fatigue calculation

---

## SQL Files in the Repo

| File | Purpose |
|------|---------|
| megamind_setup.sql | Creates Megamind DB + Learning, Finance, Job tables — run this first |
| megamind_workout_schema_v2.sql | Complete workout module — Q1=Tendon, Q2=Neural — run this second |
| context.md | This file — paste at start of every Claude session |
| master_schema_plan.md | Full database blueprint and design decisions |

### Run Order in SSMS
1. Run megamind_setup.sql first
2. Run megamind_workout_schema_v2.sql second

### What Needs to Be Done in Next Session
- Populate ExerciseBodyRegion table — maps every exercise to its affected body regions
- Populate DayExercise table — full prescription for every exercise in every cycle day for Q1 and Q2

---

## Projects Decided

1. **Workout Tracker** — first real project, personally meaningful, complex schema
2. **Job Application Tracker** — needed immediately during job search
3. **Personal Finance Tracker** — daily use, strong analytics angle
4. **Personal Assistant — Jarvis** — dream project, future phase after SQL and Python are solid

All four feed into the single Megamind database.
Python UI sits on top of everything.
Jarvis becomes the AI and voice layer on top of the Python UI eventually.

---

## Daily Learning Format

- Each day = one focused chat session with Claude
- Start every session by pasting the full text of context.md
- If the session involves schema or SQL script work, also upload the relevant SQL files
- All SQL concepts are learned by applying them directly to the Megamind database and its modules
- No generic practice — every query has a real purpose tied to a real module
- Learning is interview-focused — every concept covered the way an interviewer tests it
- Session summary stored in ConversationLog table in Megamind database
- All code and scripts committed to sql-portfolio GitHub repo at end of each session

---

## Important Preferences — Read Every Session

- No sugar coating — always tell the hard truth even if uncomfortable
- Bold thinking encouraged — correct when wrong, support when right
- Interview-first mindset — every SQL concept tied to how it appears in interviews
- One unified system — nothing is a throwaway project, everything connects
- Collaborative building — we design and build together, not just lecture and learn
- Known weakness: overambitious and hyperactive at the start of new things — call it out if needed
- Known trait: perfectionist — use it as a strength but flag when it becomes a blocker
- If asked where we left off — the answer is always in this file, do not ask back, read it and confirm
