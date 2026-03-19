# Megamind — QuestionBank Generation Context
> Paste this file into any future Claude session when you need to generate QuestionBank questions.
> This is a prompt context file — not a schema file. It tells Claude exactly how to generate questions.
> Last updated: Session 005 — 17 March 2026

---

## What This File Is

This file gives Claude the rules, logic, standards, and database context needed to generate
QuestionBank INSERT scripts that are consistent with all previously generated questions.

Every question generated must feel like it came from the same session as the ones already in the bank.
Same style. Same structure. Same table references. Same quality bar.

---

## When Questions Are Generated

Questions are generated per concept, per session — NOT in bulk upfront.

**The correct workflow:**
1. Concept is taught — theory + practice problems live in chat
2. After practice is complete, Claude generates QuestionBank INSERT script for that concept
3. Student runs the script in SSMS
4. Assessment begins — questions pulled from QuestionBank exactly as stored
5. PracticeLog entries generated after assessment

**Never generate questions for a concept before it has been taught in a session.**
Questions must reflect what was actually practiced — same tables, same patterns, same depth.

---

## The QuestionBank Table — Schema Reference

```sql
QuestionBank (
    QuestionID          INT IDENTITY PK,
    ConceptID           INT FK → Concept.ConceptID,
    QuestionDescription NVARCHAR(2000),  -- full question with output columns and hint
    Difficulty          NVARCHAR(20),    -- Basic / Intermediate / Advanced
    QuestionType        NVARCHAR(20),    -- Practice / Interview
    ExpectedOutput      NVARCHAR(1000),  -- result shape and row count
    Notes               NVARCHAR(500),  -- teaching note, interview context, common mistakes
    CreatedAt           DATETIME         -- default GETDATE(), NOT NULL
)
```

**INSERT template:**
```sql
INSERT INTO QuestionBank
    (ConceptID, QuestionDescription, Difficulty, QuestionType, ExpectedOutput, Notes)
VALUES
(ConceptID, 'QuestionDescription', 'Difficulty', 'QuestionType', 'ExpectedOutput', 'Notes');
```

---

## Question Count Rules — Non-Negotiable

Question count per concept is determined by two axes: InterviewImportance and Difficulty.
Both axes matter. Use the higher of the two signals when they conflict.

| InterviewImportance | Difficulty   | Question Count |
|---------------------|--------------|----------------|
| 5                   | Any          | 5              |
| 4                   | Advanced     | 4              |
| 4                   | Intermediate | 3              |
| 4                   | Basic        | 3              |
| 3                   | Any          | 2              |
| 2                   | Any          | 2              |

**Minimum is always 2. Maximum is always 5.**
If a concept is InterviewImportance 5 AND Advanced difficulty — still 5 questions, not 6.

---

## Difficulty Progression Within a Concept

Questions within a single concept must progress in difficulty — never flat.
Even if the concept itself is tagged Basic, the questions should go from easier to harder.

**Standard progression pattern:**
- Question 1 — Pure syntax demonstration. No tricks. Shows the student the basic form.
- Question 2 — Applies the concept to a real Megamind table with a filter or join added.
- Question 3 — Combines this concept with one other concept (e.g. CTE + filter, window + CASE).
- Question 4 — Real interview pattern. Multi-step. Requires understanding of why, not just how.
- Question 5 — Advanced application. Production-quality. Tests edge cases or combinations.

**The Difficulty column on each question row reflects where that specific question sits:**
- Basic = syntax and single-concept application
- Intermediate = multi-step, combined concepts, real analytics patterns
- Advanced = edge cases, performance-aware, interview-level complexity

---

## QuestionType Assignment Rules

| Condition | QuestionType |
|-----------|-------------|
| InterviewImportance >= 4 AND question tests a known interview pattern | Interview |
| Question is a syntax demonstration or single-concept drill | Practice |
| Question involves edge cases, gotchas, or comparison of two approaches | Interview |
| Question is a warm-up or first contact with the concept | Practice |

**Rule of thumb:** If an interviewer would ask this exact question, it is Interview.
If it exists to build fluency before the interview question, it is Practice.

---

## QuestionDescription Writing Rules

Every QuestionDescription must contain four parts in this order:

1. **Goal statement** — one sentence saying what the query must accomplish.
2. **Output columns** — explicit list of every column required in the result set.
   Never leave output columns ambiguous. Always say: "Output columns: X, Y, Z."
3. **Constraints or conditions** — any filtering, ordering, grouping, or business rules.
4. **Hint** — the logical approach to solve it. Not the answer. The thinking direction.
   Format: "Hint: [approach]"

**Example of a correctly written QuestionDescription:**

```
Using ConversationLog, show each session alongside the previous session's DifficultyLevel
and the next session's DifficultyLevel.
Output columns: SessionDate, SessionTitle, DifficultyLevel, PreviousDifficulty, NextDifficulty.
Order by SessionDate ASC.
Hint: LAG(DifficultyLevel) OVER (ORDER BY SessionDate) for previous.
LEAD(DifficultyLevel) OVER (ORDER BY SessionDate) for next.
First row PreviousDifficulty = NULL. Last row NextDifficulty = NULL.
```

**Rules for writing QuestionDescription:**
- Always name the table(s) being used at the start of the description.
- Always list output columns explicitly — never say "show relevant columns."
- Always include a Hint. The hint guides thinking without giving the full answer.
- Hints must mention the key function or clause to use — not the full query.
- Never write the complete SQL solution in the description.
- Single quotes inside NVARCHAR strings must be escaped as two single quotes: '' not '

---

## ExpectedOutput Writing Rules

ExpectedOutput describes what a correct answer looks like — not the SQL, the result shape.

**Must include:**
- Approximate row count (e.g. "121 rows", "one row per SubTopic", "4 rows")
- Column names that appear in the result
- Any key behaviour to verify (e.g. "first row PreviousDifficulty is NULL")
- What makes the answer correct vs wrong

**Must NOT include:**
- The actual SQL query
- Exact data values (data changes as the database grows)
- Vague statements like "correct result set" — be specific about shape and behaviour

---

## Notes Writing Rules

Notes are teaching annotations — they explain the concept behind the question,
common mistakes, and interview context. Not visible to the student during assessment.

**Must include at least one of:**
- The core lesson this question teaches
- The most common mistake students make on this question
- Why an interviewer asks this specific question
- What a correct answer signals to an interviewer

**Length:** 1-3 sentences. Concise and direct. No padding.

---

## Megamind Database — Table Reference

All questions must reference real Megamind tables.
Never use hypothetical tables or generic "Sales" / "Orders" examples.
If a table is currently empty (e.g. Transactions, WorkoutSession), it can still be used —
note in the description that the student should use it once populated, or suggest a proxy table.

### Available Tables and Their Key Columns

**ConversationLog** — session tracking
- SessionID, SessionDate, SessionNumber, SessionTitle, DifficultyLevel (1-5)
- Current data: 4-5 rows. Use for date-based queries, running totals, LAG/LEAD patterns.

**SessionConcept** — bridge between sessions and concepts
- SessionConceptID, SessionID, ConceptID, DepthReached, InterviewReadinessAfter
- Use for session-concept join queries, counting concepts per session.

**Topic** — top level subject (SQL, Python, Tools)
- TopicID, TopicName, IsActive

**SubTopic** — grouping layer
- SubTopicID, TopicID, SubTopicName, OrderSequence
- 16 rows under SQL. Use for grouping and ordering queries.

**Concept** — individual learnable unit — MOST USED TABLE
- ConceptID, SubTopicID, ConceptName, Difficulty, LearningType, InterviewImportance (1-5)
- EstimatedSessions, Notes
- 121 rows. Primary table for ranking, filtering, window function practice.

**ConceptPrerequisite** — self-referencing bridge
- ConceptID, PrerequisiteConceptID
- 46 rows. Use for recursive CTE questions — hierarchy and dependency traversal.

**ConceptProgress** — one row per concept, learning state
- ProgressID, ConceptID, Status, TimesPracticed, LastPracticed, RevisionDueDate

**QuestionBank** — questions per concept
- QuestionID, ConceptID, QuestionDescription, Difficulty, QuestionType, ExpectedOutput, Notes
- Current data: 5 rows for ConceptID 29

**Exercise** — workout exercise library
- ExerciseID, ExerciseName, ExerciseIntentID, MeasurementTypeID
- 65 rows. Use for GROUP BY, window function, ranking questions.

**ExerciseIntent** — intent classification
- IntentID, IntentName (Explosive, Eccentric, Isometric, Strength, Activation, Mobility)
- 6 rows. Use as a dimension for partitioning exercise queries.

**DayExercise** — exercise prescriptions per workout day
- DayExerciseID, CycleDayID, ExerciseID, PrescribedSets, PrescribedReps
- 86 rows. Use for set/rep analytics, ranking exercises by volume.

**CycleDay** — workout days in a cycle
- CycleDayID, QuarterID, DayNumber, DayName, DayType
- 17 rows (8 for Q1, 9 for Q2).

**Quarter** — training quarters
- QuarterID, QuarterName, CycleLength, Focus
- 4 rows: Q1 Tendon, Q2 Neural, Q3, Q4.

**JobApplications** — job search tracking (currently empty)
- ApplicationID, AppliedDate, CompanyName, RoleTitle, Platform, Status, SalaryExpected
- Use Concept as proxy (ConceptID → ApplicationID, InterviewImportance → SalaryExpected).

**Transactions** — personal finance (currently empty)
- TransactionID, TransactionDate, Amount, Type (Income/Expense), Category, Description
- Use ConversationLog as proxy for date-based patterns.

---

## Proxy Table Rules

When a question logically belongs to an empty table (Transactions, JobApplications, WorkoutSession),
use this pattern in the QuestionDescription:

```
Using JobApplications (once populated — use Concept as proxy: ConceptID as ApplicationID,
InterviewImportance as SalaryExpected) write a query that...
```

This keeps the question conceptually correct while remaining executable today.

---

## SQL Style Rules — All Generated SQL in Hints Must Follow These

- T-SQL syntax only — this is SQL Server, not MySQL or PostgreSQL
- Use GETDATE() not NOW()
- Use DATEDIFF(day, date1, date2) not DATEDIFF('day', ...)
- Use FORMAT(date, 'yyyy-MM') for year-month grouping
- Use ISNULL() not COALESCE() for simple two-argument null replacement
- Single quotes for string literals — never double quotes
- Escape single quotes inside NVARCHAR strings as two single quotes: ''
- Window function OVER clause: always write PARTITION BY before ORDER BY
- Always specify ROWS BETWEEN or RANGE BETWEEN explicitly when teaching frame clauses
- MAXRECURSION hint syntax: OPTION (MAXRECURSION N) at the end of the statement

---

## What Already Exists in QuestionBank

As of Session 005, the following ConceptIDs have questions populated:

| ConceptID | Concept | Questions | Session Added |
|-----------|---------|-----------|---------------|
| 29 | SUM OVER and AVG OVER — running totals | 5 | Session 005 |

**Total questions populated: 5**
**All other ConceptIDs: 0 questions — generate after concept is taught**

When generating for a new concept, check this table first to avoid duplicating
questions for concepts that are already populated.

---

## Complete Concept Map — All 121 ConceptIDs

Use this to look up ConceptID, Difficulty, and InterviewImportance before generating.

### SubTopic 1 — Basic Queries (ConceptIDs 1–8)
| ConceptID | ConceptName | Difficulty | InterviewImportance |
|-----------|-------------|------------|-------------------|
| 1 | SELECT and FROM basics | Basic | 1 |
| 2 | WHERE clause filtering | Basic | 2 |
| 3 | ORDER BY and TOP | Basic | 2 |
| 4 | DISTINCT | Basic | 2 |
| 5 | Aggregate functions — COUNT SUM AVG MIN MAX | Basic | 3 |
| 6 | GROUP BY | Basic | 4 |
| 7 | HAVING vs WHERE | Basic | 4 |
| 8 | Aliases — column and table | Basic | 2 |

### SubTopic 2 — Joins (ConceptIDs 9–16)
| ConceptID | ConceptName | Difficulty | InterviewImportance |
|-----------|-------------|------------|-------------------|
| 9 | INNER JOIN | Basic | 4 |
| 10 | LEFT JOIN and RIGHT JOIN | Basic | 5 |
| 11 | FULL OUTER JOIN | Intermediate | 3 |
| 12 | CROSS JOIN | Intermediate | 2 |
| 13 | Self JOIN | Intermediate | 4 |
| 14 | Multi-table JOINs (3+ tables) | Intermediate | 5 |
| 15 | JOIN vs subquery — when to use which | Intermediate | 4 |
| 16 | STRING_AGG — aggregating joined rows | Intermediate | 3 |

### SubTopic 3 — CTEs (ConceptIDs 17–23)
| ConceptID | ConceptName | Difficulty | InterviewImportance |
|-----------|-------------|------------|-------------------|
| 17 | Basic CTE syntax | Basic | 3 |
| 18 | CTE vs subquery | Basic | 3 |
| 19 | Filtering on aggregated aliases using CTE | Basic | 4 |
| 20 | Stacked CTEs | Intermediate | 4 |
| 21 | CTE referencing another CTE | Intermediate | 4 |
| 22 | CTE combined with Window Functions | Intermediate | 5 |
| 23 | Recursive CTEs | Advanced | 4 |

### SubTopic 4 — Window Functions (ConceptIDs 24–32)
| ConceptID | ConceptName | Difficulty | InterviewImportance |
|-----------|-------------|------------|-------------------|
| 24 | OVER clause — the foundation | Basic | 4 |
| 25 | PARTITION BY | Basic | 5 |
| 26 | ROW_NUMBER | Basic | 4 |
| 27 | RANK and DENSE_RANK | Basic | 4 |
| 28 | LAG and LEAD | Intermediate | 5 |
| 29 | SUM OVER and AVG OVER — running totals ✅ | Intermediate | 5 |
| 30 | ROWS BETWEEN frame clause | Advanced | 4 |
| 31 | NTILE | Intermediate | 2 |
| 32 | Window functions vs GROUP BY — key distinction | Intermediate | 5 |

### SubTopic 5 — Indexes (ConceptIDs 33–41)
| ConceptID | ConceptName | Difficulty | InterviewImportance |
|-----------|-------------|------------|-------------------|
| 33 | Clustered vs non-clustered index | Intermediate | 5 |
| 34 | Covering index | Intermediate | 5 |
| 35 | Composite index — column order matters | Intermediate | 4 |
| 36 | Index seek vs index scan vs table scan | Intermediate | 5 |
| 37 | When indexes hurt performance — over-indexing | Intermediate | 4 |
| 38 | Filtered index | Advanced | 3 |
| 39 | Index on computed column | Advanced | 3 |
| 40 | Index fragmentation and rebuild vs reorganize | Advanced | 3 |
| 41 | Statistics and how SQL Server uses them | Advanced | 4 |

### SubTopic 6 — Execution Plans and Statistics (ConceptIDs 42–48)
| ConceptID | ConceptName | Difficulty | InterviewImportance |
|-----------|-------------|------------|-------------------|
| 42 | Reading an execution plan in SSMS | Intermediate | 5 |
| 43 | Table scan vs index seek in execution plans | Intermediate | 5 |
| 44 | Estimated vs actual execution plans | Intermediate | 4 |
| 45 | Cost percentage per operator | Intermediate | 4 |
| 46 | Key lookup and how to eliminate it | Advanced | 4 |
| 47 | SET STATISTICS IO and TIME | Advanced | 4 |
| 48 | Parameter sniffing | Advanced | 4 |

### SubTopic 7 — Query Optimization (ConceptIDs 49–56)
| ConceptID | ConceptName | Difficulty | InterviewImportance |
|-----------|-------------|------------|-------------------|
| 49 | SARGability — what it means and why it matters | Intermediate | 5 |
| 50 | Non-SARGable patterns to avoid | Intermediate | 5 |
| 51 | Set-based vs row-based thinking | Intermediate | 5 |
| 52 | Avoiding functions on columns in WHERE clause | Intermediate | 4 |
| 53 | EXISTS vs IN vs JOIN for filtering | Intermediate | 4 |
| 54 | Implicit type conversion performance cost | Advanced | 4 |
| 55 | Query hints — when and when not to use | Advanced | 3 |
| 56 | Rewriting correlated subqueries as joins | Advanced | 4 |

### SubTopic 8 — Stored Procedures (ConceptIDs 57–64)
| ConceptID | ConceptName | Difficulty | InterviewImportance |
|-----------|-------------|------------|-------------------|
| 57 | CREATE PROCEDURE basic syntax | Basic | 3 |
| 58 | Input and output parameters | Basic | 4 |
| 59 | TRY CATCH error handling in procedures | Intermediate | 5 |
| 60 | Transaction management inside procedures | Intermediate | 5 |
| 61 | NOCOUNT and XACT_ABORT settings | Intermediate | 3 |
| 62 | Procedure recompilation and plan caching | Advanced | 4 |
| 63 | Dynamic SQL inside stored procedures | Advanced | 4 |
| 64 | Procedure vs function — when to use which | Intermediate | 4 |

### SubTopic 9 — Views and Functions (ConceptIDs 65–71)
| ConceptID | ConceptName | Difficulty | InterviewImportance |
|-----------|-------------|------------|-------------------|
| 65 | CREATE VIEW basic syntax and use cases | Basic | 3 |
| 66 | Indexed views | Advanced | 3 |
| 67 | Scalar functions — syntax and performance cost | Intermediate | 4 |
| 68 | Inline table-valued functions | Intermediate | 5 |
| 69 | Multi-statement table-valued functions | Advanced | 4 |
| 70 | View vs CTE vs derived table — when to use which | Intermediate | 4 |
| 71 | Schema binding | Advanced | 3 |

### SubTopic 10 — Transactions and Locking (ConceptIDs 72–79)
| ConceptID | ConceptName | Difficulty | InterviewImportance |
|-----------|-------------|------------|-------------------|
| 72 | BEGIN TRAN COMMIT ROLLBACK basics | Basic | 4 |
| 73 | ACID properties | Basic | 4 |
| 74 | Isolation levels — READ UNCOMMITTED through SERIALIZABLE | Intermediate | 5 |
| 75 | Deadlocks — causes and prevention | Advanced | 5 |
| 76 | Shared vs exclusive locks | Intermediate | 4 |
| 77 | Row vs page vs table lock escalation | Advanced | 4 |
| 78 | NOLOCK hint — use and risks | Intermediate | 4 |
| 79 | Optimistic vs pessimistic concurrency | Advanced | 3 |

### SubTopic 11 — Error Handling (ConceptIDs 80–84)
| ConceptID | ConceptName | Difficulty | InterviewImportance |
|-----------|-------------|------------|-------------------|
| 80 | TRY CATCH basic structure | Basic | 4 |
| 81 | ERROR_MESSAGE, ERROR_NUMBER, ERROR_LINE | Basic | 3 |
| 82 | RAISERROR vs THROW | Intermediate | 4 |
| 83 | Nested TRY CATCH | Advanced | 3 |
| 84 | Error handling inside transactions | Advanced | 5 |

### SubTopic 12 — Dynamic SQL (ConceptIDs 85–90)
| ConceptID | ConceptName | Difficulty | InterviewImportance |
|-----------|-------------|------------|-------------------|
| 85 | EXEC and sp_executesql basics | Intermediate | 4 |
| 86 | Parameterised dynamic SQL | Intermediate | 5 |
| 87 | SQL injection risk in dynamic SQL | Intermediate | 5 |
| 88 | Dynamic pivot tables | Advanced | 4 |
| 89 | Dynamic ORDER BY and column selection | Advanced | 4 |
| 90 | When to use dynamic SQL vs alternatives | Intermediate | 3 |

### SubTopic 13 — Triggers (ConceptIDs 91–96)
| ConceptID | ConceptName | Difficulty | InterviewImportance |
|-----------|-------------|------------|-------------------|
| 91 | AFTER trigger basics | Basic | 3 |
| 92 | INSTEAD OF trigger | Intermediate | 3 |
| 93 | Inserted and Deleted virtual tables | Basic | 4 |
| 94 | Trigger performance considerations | Advanced | 3 |
| 95 | DDL triggers | Advanced | 2 |
| 96 | Triggers vs constraints vs stored procedures | Intermediate | 4 |

### SubTopic 14 — Schema Design and Normalization (ConceptIDs 97–105)
| ConceptID | ConceptName | Difficulty | InterviewImportance |
|-----------|-------------|------------|-------------------|
| 97 | First, Second, Third Normal Form | Basic | 4 |
| 98 | Denormalization — when and why | Intermediate | 4 |
| 99 | Primary keys — surrogate vs natural | Basic | 3 |
| 100 | Foreign keys and referential integrity | Basic | 4 |
| 101 | Composite keys | Basic | 3 |
| 102 | Identity columns and sequences | Basic | 3 |
| 103 | Computed columns | Intermediate | 3 |
| 104 | Temporal tables | Advanced | 3 |
| 105 | Schema design for analytics vs OLTP | Advanced | 4 |

### SubTopic 15 — Looping and Cursors (ConceptIDs 106–111)
| ConceptID | ConceptName | Difficulty | InterviewImportance |
|-----------|-------------|------------|-------------------|
| 106 | WHILE loop basics | Basic | 3 |
| 107 | Cursor — DECLARE OPEN FETCH CLOSE | Intermediate | 3 |
| 108 | Cursor types — FAST_FORWARD, STATIC, DYNAMIC | Advanced | 2 |
| 109 | Why cursors are slow — set-based alternative | Intermediate | 5 |
| 110 | Replacing cursor logic with window functions | Advanced | 5 |
| 111 | When loops are acceptable | Intermediate | 3 |

### SubTopic 16 — T-SQL Miscellaneous (ConceptIDs 112–121)
| ConceptID | ConceptName | Difficulty | InterviewImportance |
|-----------|-------------|------------|-------------------|
| 112 | CASE expression — simple and searched | Basic | 4 |
| 113 | ISNULL and COALESCE | Basic | 3 |
| 114 | PIVOT and UNPIVOT | Advanced | 3 |
| 115 | MERGE statement | Advanced | 4 |
| 116 | IIF and CHOOSE | Basic | 2 |
| 117 | String functions — LEN REPLACE SUBSTRING CHARINDEX | Basic | 3 |
| 118 | Date functions — DATEADD DATEDIFF DATEPART FORMAT | Basic | 4 |
| 119 | CAST and CONVERT | Basic | 3 |
| 120 | System functions — NEWID SCOPE_IDENTITY @@ROWCOUNT | Intermediate | 3 |
| 121 | Common table expressions vs temp tables vs table variables | Advanced | 5 |

---

## Generation Instructions for Future Claude Sessions

When generating QuestionBank questions, follow this exact process:

**Step 1 — Confirm concept was taught this session**
Only generate questions for concepts that were covered in the current session.
Check the "What Already Exists" table above — do not regenerate for already-populated concepts.

**Step 2 — Look up concept metadata**
For each ConceptID in scope, note Difficulty and InterviewImportance from the concept map above.
Apply the question count rules to determine how many questions per concept.

**Step 3 — Plan the progression**
Before writing any question, plan the difficulty arc:
Question 1 = syntax. Question 2 = applied. Question 3+ = combined/interview/edge case.

**Step 4 — Write questions following all rules above**
Every question must have: goal, output columns, constraints, hint.
Every question must reference a real Megamind table.
Every question must have a correctly written ExpectedOutput and Notes.

**Step 5 — Generate as a single INSERT script**
One INSERT INTO QuestionBank (...) VALUES (...), (...), ... statement.
All questions for the concept in one script.
File naming: concept_XXX_questions.sql (zero-padded ConceptID, e.g. concept_029_questions.sql)
Add section header as SQL comment: -- ConceptID X — ConceptName (Difficulty, ImportanceN)

**Step 6 — Verify counts**
After generating, confirm the total question count matches the rules.
State the count per concept clearly before handing over the script.

---

## Quality Bar — Every Question Must Pass This Check

Before including any question, verify:

- [ ] Goal statement is clear and unambiguous
- [ ] Output columns are explicitly named — no "relevant columns"
- [ ] Hint gives thinking direction without giving the full SQL
- [ ] References a real Megamind table by name
- [ ] ExpectedOutput describes result shape and row count
- [ ] Notes contain at least one teaching point or interview context
- [ ] Difficulty column reflects this specific question's complexity
- [ ] QuestionType is correctly assigned (Interview vs Practice)
- [ ] No SQL injection in string values — single quotes escaped as ''
- [ ] T-SQL syntax only — no MySQL or PostgreSQL functions
- [ ] Reflects what was actually practiced in the session — same tables, same patterns
