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
- **DEV Repo:** E:\Projects\Megamind\DEV

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
- Query optimization and performance tuning — NOT done intentionally. Need to learn properly.
- Indexing strategies — understand the concept, need hands-on depth
- Window functions, CTEs — building fluency now (Sessions 004-005)

### Python DE projects (done approximately 1 year ago, now rusty)
- Air Quality Data Pipeline — REST API → Python → CSV/Parquet output
- Sales Analytics Dashboard — Python pipeline → Streamlit dashboard
- Both are in private GitHub repos under TheMegamind4

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
- Risk areas being actively closed:
  - "Query optimization and performance tuning" — learn in Week 2-3
  - "Execution plan analysis" — learn in Week 2
  - Performance improvement claim — rewritten as "analyzed and refactored T-SQL queries, implementing non-clustered and covering indexes to reduce execution overhead"
- Projects section weak — no SQL-specific projects yet

### Data Engineer Resume
- More aggressively positioned
- Applying selectively — not the main focus right now

---

## The Full Action Plan

### Phase 1 — Setup ✅ COMPLETE

### Phase 2 — SQL Depth ← CURRENTLY HERE (Weeks 1–4)

**Core principle:** Every SQL concept learned by writing real queries against Megamind.
No generic dummy exercises. Every query has a real purpose.

**Week 1 — Complex Queries (in progress)**
- Multi-table JOINs ✅ Done Session 003
- CTEs — all 7 concepts ✅ Done Session 004
- Window Functions — OVER, PARTITION BY, ROW_NUMBER, RANK, DENSE_RANK, LAG, LEAD ✅ Done Session 004
- SUM OVER and AVG OVER running totals ✅ Done Session 005
- ROWS BETWEEN frame clause — next
- Recursive CTEs — next

**Week 2 — Indexes and Execution Plans**
**Week 3 — Query Optimization and Performance Tuning**
**Week 4 — Stored Procedures, Views, Functions Done Properly**

### Phase 3 — Projects (Weeks 5–8)
### Phase 4 — SSIS + Light DE Exposure (Weeks 9–11)
### Phase 5 — Resume Update + Apply Properly (Week 12)

---

## The Megamind Database

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

---

## DEV Folder Structure

```
E:\Projects\Megamind\DEV
├───Dimension
│   ├───Learning
│   │       learning_population.sql
│   └───Workout
│           workout_population.sql
├───QuestionBank
│       Concept_29_Assessment.sql
├───Schema
│       learning_schema.sql
│       master_schema.sql
│       workout_schema.sql
├───SessionLogs
│       session_005_log.sql
└───State_Files
        context.md
        db_state.md
        master_schema_plan.md
        QuestionBank_Context.md
        session_log.md
```

**Run order for fresh setup:**
1. Schema/master_schema.sql
2. Schema/learning_schema.sql
3. Schema/workout_schema.sql
4. Dimension/Workout/workout_population.sql
5. Dimension/Learning/learning_population.sql

---

## Session Learning Flow — Per Concept

1. **Theory** — brief, just enough context
2. **Practice problems** — live in chat, increasing difficulty, until concept is solid
3. **QuestionBank generation** — INSERT script generated after practice. Student runs it in SSMS.
4. **Assessment** — questions pulled from QuestionBank exactly as stored, one by one
5. **PracticeLog script** — generated after assessment. Student runs it.
6. **Move to next concept**

**Logging rules:**
- Practice phase → noted in SessionConcept/ConversationLog notes only
- Assessment phase → full PracticeLog entry (QuestionID, SessionID, SolvedIndependently, TimeTakenMins)

**End of session:**
- Session log SQL script — ConversationLog + SessionConcept + ConceptProgress
- State file updates — context.md, db_state.md, session_log.md, master_schema_plan.md
- Git push reminder

---

## QuestionBank System

- Table: QuestionBank (renamed from ProblemBank — Session 005)
- Columns: QuestionID, ConceptID, QuestionDescription, Difficulty, QuestionType, ExpectedOutput, Notes, CreatedAt
- Questions generated per concept per session — not in bulk
- Generation rules documented in: State_Files/QuestionBank_Context.md
- Current population: 5 questions for ConceptID 29 (assessment complete — 4/5 logged)

**Question count rules:**
| InterviewImportance | Difficulty | Questions |
|---------------------|-----------|---------|
| 5 | Any | 5 |
| 4 | Advanced | 4 |
| 4 | Basic/Intermediate | 3 |
| 3 | Any | 2 |
| 2 | Any | 2 |

---

## Workout System — Important Details

This is NOT a standard workout tracker. It is a periodized strength science system.

### The Year Plan — CORRECT ORDER
```
Q1 — Tendon Conditioning          (8 day cycle)
Q2 — Neural Strength & Explosive  (9 day cycle)
Q3 — Type 2x + Neural Mix
Q4 — Hypertrophy
```
This order is non-negotiable. Tendon foundation must come before neural loading.

### Performance Rating System
```
1 = Failed
2 = Completed but degraded
3 = Completed as prescribed
4 = Completed clean — ready to progress
```

---

## Session Protocol — Claude Must Follow This Every Session

### How to open every session
1. Read all pasted files completely before responding
2. Give a warm, familiar greeting — continuation, not a new relationship
3. Confirm current state in 3-4 bullet points
4. Check session_log for pending tasks and mention them
5. Propose what to do today with a clear reason
6. Never ask where we left off — the files have the answer

### How to teach every concept
- Always start with the objective — what real problem does this solve
- Connect every concept to the bigger picture before diving into syntax
- Give the problem first, let Abhiram attempt before showing solution
- After a query is written, explain what was done well and what could be better
- Always show the interview angle

### How to close every session
1. Summarise what was covered
2. Generate complete session log SQL script
3. List files that need updating
4. Remind to git push

### Tone and character rules
- Warm and familiar — senior colleague, not a tutor
- Direct and honest — never soften bad news
- Collaborative — build together
- Call out overambition early
- Call out perfectionism when it becomes a blocker
- Every session must move one concrete step closer to Jarvis

---

## Important Preferences

- No sugar coating — always tell the hard truth
- Interview-first mindset — every SQL concept tied to how it appears in interviews
- One unified system — nothing is throwaway, everything connects
- Known weakness: overambitious at the start — call it out if needed
- Known trait: perfectionist — flag when it becomes a blocker
- Problems and learning: more hands-on problems, less conversation
- Teaching style: brief theory then straight into problems

---

## The North Star — Jarvis

Every single thing built in this journey exists to become the foundation Jarvis runs on.

Jarvis is a personal AI assistant that:
- Knows complete learning history from ConversationLog and SessionConcept
- Knows job search status from JobApplications
- Knows training state and recovery from WorkoutSession and FatigueLog
- Knows financial position from Transactions
- Knows what needs revision via ConceptProgress and RevisionDueDate
- Uses all of this as context via Claude API
- Eventually has voice input and output
- Runs as a Python desktop application connected to Megamind

Every query written today is a query Jarvis will run tomorrow.
