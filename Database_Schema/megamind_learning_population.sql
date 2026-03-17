-- =============================================
-- MEGAMIND LEARNING POPULATION
-- File: megamind_learning_population.sql
-- Run order: 5th — run after megamind_workout_population.sql
-- Created: Session 004 — 17 March 2026
-- =============================================
-- Populates:
--   Topic          — SQL (active), Python and Tools (future)
--   SubTopic       — 16 subtopics under SQL
--   Concept        — All concepts per subtopic
--   ConceptPrerequisite — Prerequisite mappings
--   ConceptProgress — Initialized for all concepts
-- =============================================

USE Megamind;
GO

-- =============================================
-- TOPICS
-- =============================================

INSERT INTO Topic (TopicName, Category, Description, IsActive) VALUES
('SQL',     'Technical', 'Structured Query Language — core skill for SQL Developer role. Primary active topic.',    1),
('Python',  'Technical', 'Python scripting for data pipelines, automation and DE path. Future scope.',             0),
('Tools',   'Tools',     'Development tools — SSMS, VS Code, Git, GitHub, SSIS. Future scope.',                   0);

GO

-- =============================================
-- SUBTOPICS — SQL (TopicID = 1)
-- =============================================

INSERT INTO SubTopic (TopicID, SubTopicName, OrderSequence) VALUES
(1, 'Basic Queries',                    1),
(1, 'Joins',                            2),
(1, 'CTEs',                             3),
(1, 'Window Functions',                 4),
(1, 'Indexes',                          5),
(1, 'Execution Plans and Statistics',   6),
(1, 'Query Optimization',               7),
(1, 'Stored Procedures',                8),
(1, 'Views and Functions',              9),
(1, 'Transactions and Locking',         10),
(1, 'Error Handling',                   11),
(1, 'Dynamic SQL',                      12),
(1, 'Triggers',                         13),
(1, 'Schema Design and Normalization',  14),
(1, 'Looping and Cursors',              15),
(1, 'T-SQL Miscellaneous',              16);

GO

-- =============================================
-- CONCEPTS — BASIC QUERIES (SubTopicID = 1)
-- =============================================

INSERT INTO Concept (SubTopicID, ConceptName, Difficulty, LearningType, InterviewImportance, EstimatedSessions, Notes) VALUES
(1, 'SELECT and FROM',
    'Basic', 'Theory', 2, 1,
    'Column selection, wildcard vs explicit columns. Always use explicit columns in production — wildcard is a bad habit interviewers notice.'),
(1, 'WHERE clause and filtering',
    'Basic', 'Practice', 3, 1,
    'Comparison operators, BETWEEN, IN, LIKE, IS NULL. Know that LIKE with leading wildcard kills index usage.'),
(1, 'ORDER BY and TOP',
    'Basic', 'Practice', 2, 1,
    'Sorting results, TOP N, TOP N WITH TIES. ORDER BY without TOP in a subquery is invalid in SQL Server.'),
(1, 'GROUP BY and aggregate functions',
    'Basic', 'Practice', 4, 1,
    'COUNT, SUM, AVG, MIN, MAX. Every non-aggregated column in SELECT must appear in GROUP BY. Common interview trap.'),
(1, 'HAVING clause',
    'Basic', 'Practice', 4, 1,
    'Filtering on aggregated results. Key interview question: difference between WHERE and HAVING. WHERE filters before aggregation, HAVING filters after.'),
(1, 'DISTINCT',
    'Basic', 'Theory', 2, 1,
    'Removing duplicate rows. DISTINCT triggers a sort operation — performance cost. Often a sign of a join problem if used heavily.'),
(1, 'Aliases — column and table',
    'Basic', 'Practice', 2, 1,
    'AS keyword for column and table aliases. Column aliases cannot be referenced in WHERE clause of the same query — common beginner mistake.'),
(1, 'CASE expressions',
    'Intermediate', 'Practice', 4, 1,
    'Simple CASE and searched CASE. CASE is an expression not a statement — returns a value, does not execute code.');

GO

-- =============================================
-- CONCEPTS — JOINS (SubTopicID = 2)
-- =============================================

INSERT INTO Concept (SubTopicID, ConceptName, Difficulty, LearningType, InterviewImportance, EstimatedSessions, Notes) VALUES
(2, 'INNER JOIN',
    'Basic', 'Practice', 4, 1,
    'Returns only matching rows from both tables. Must be able to write multi-table INNER JOINs fluently without thinking.'),
(2, 'LEFT JOIN and RIGHT JOIN',
    'Basic', 'Practice', 5, 1,
    'Returns all rows from one side, NULLs for non-matching rows. Know how to use LEFT JOIN to find unmatched rows: WHERE right.col IS NULL.'),
(2, 'FULL OUTER JOIN',
    'Intermediate', 'Theory', 3, 1,
    'Returns all rows from both tables, NULLs where no match. Rarely used in practice but interviewers test conceptual understanding.'),
(2, 'CROSS JOIN',
    'Intermediate', 'Theory', 2, 1,
    'Cartesian product — every row from left combined with every row from right. No ON clause. Dangerous on large tables.'),
(2, 'SELF JOIN',
    'Intermediate', 'Practice', 4, 1,
    'Joining a table to itself using aliases. Classic interview problem: find employees and their managers from the same Employees table.'),
(2, 'Multi-table JOINs',
    'Intermediate', 'Practice', 5, 1,
    'Chaining 3 or more tables. Order matters for readability, not correctness. Know how to trace join paths without confusion.'),
(2, 'JOIN vs subquery — when to use which',
    'Intermediate', 'Theory', 4, 1,
    'JOINs for combining related data, subqueries for filtering. Correlated subqueries run once per row — performance trap.'),
(2, 'Duplicate rows from JOINs — fan-out problem',
    'Intermediate', 'Practice', 4, 1,
    'Joining one-to-many causes aggregates to multiply. Fix: aggregate inside CTE before joining. Must understand root cause.');

GO

-- =============================================
-- CONCEPTS — CTEs (SubTopicID = 3)
-- =============================================

INSERT INTO Concept (SubTopicID, ConceptName, Difficulty, LearningType, InterviewImportance, EstimatedSessions, Notes) VALUES
(3, 'Basic CTE syntax',
    'Basic', 'Practice', 3, 1,
    'WITH clause, named result set, single query scope. CTE exists only for the duration of one query — gone after execution.'),
(3, 'CTE vs subquery',
    'Basic', 'Theory', 3, 1,
    'CTEs improve readability and allow reuse within the same query. Performance is usually identical — optimizer treats them the same.'),
(3, 'Filtering on aggregated aliases using CTE',
    'Basic', 'Practice', 4, 1,
    'Aggregate alias cannot be used in HAVING in same query. Wrap in CTE then filter with WHERE in outer query.'),
(3, 'Stacked CTEs',
    'Intermediate', 'Practice', 4, 1,
    'Multiple CTEs before a single SELECT, separated by commas. Second CTE can reference first.'),
(3, 'CTE referencing another CTE',
    'Intermediate', 'Practice', 4, 1,
    'Pushing filters upstream — second CTE joins against first CTE directly. Narrows dataset earlier, cleaner logic.'),
(3, 'CTE combined with Window Functions',
    'Intermediate', 'Practice', 5, 1,
    'Window function inside CTE, filtered in outer SELECT. Classic pattern: ROW_NUMBER in CTE, WHERE RowNum = 1 outside.'),
(3, 'Recursive CTEs',
    'Advanced', 'Practice', 4, 2,
    'Self-referencing CTE. Requires anchor member and recursive member with UNION ALL. Used for hierarchical data. Know MAXRECURSION option.');

GO

-- =============================================
-- CONCEPTS — WINDOW FUNCTIONS (SubTopicID = 4)
-- =============================================

INSERT INTO Concept (SubTopicID, ConceptName, Difficulty, LearningType, InterviewImportance, EstimatedSessions, Notes) VALUES
(4, 'OVER clause — the foundation',
    'Basic', 'Theory', 4, 1,
    'OVER() defines the window. Without PARTITION BY operates on entire result set. Must understand OVER before any window function makes sense.'),
(4, 'PARTITION BY',
    'Basic', 'Practice', 5, 1,
    'Resets window function calculation per group — like GROUP BY but rows stay intact. Most important window function concept.'),
(4, 'ROW_NUMBER',
    'Basic', 'Practice', 4, 1,
    'Assigns unique sequential integer per partition. No ties. Classic use: get most recent record per group filtering RowNum = 1.'),
(4, 'RANK and DENSE_RANK',
    'Basic', 'Practice', 4, 1,
    'RANK skips numbers after ties — 1,1,3. DENSE_RANK does not skip — 1,1,2. Know when to use each.'),
(4, 'LAG and LEAD',
    'Intermediate', 'Practice', 5, 1,
    'LAG gets value from previous row, LEAD from next. Params: column, offset, default. PARTITION BY resets boundary per group.'),
(4, 'SUM OVER and AVG OVER — running totals',
    'Intermediate', 'Practice', 5, 2,
    'Most common window function in data role interviews. Without ORDER BY gives partition total. With ORDER BY gives running total.'),
(4, 'ROWS BETWEEN frame clause',
    'Advanced', 'Practice', 4, 2,
    'Defines exact rows in window. UNBOUNDED PRECEDING AND CURRENT ROW = running total. N PRECEDING AND CURRENT ROW = moving average. Separates junior from mid-level.'),
(4, 'NTILE',
    'Intermediate', 'Theory', 2, 1,
    'Divides result set into N equal buckets. NTILE(4) creates quartiles. Less common but worth knowing.'),
(4, 'Window functions vs GROUP BY — key distinction',
    'Intermediate', 'Theory', 5, 1,
    'GROUP BY collapses rows. Window functions preserve all rows while computing across them. Core answer to why you use window functions over subqueries.');

GO

-- =============================================
-- CONCEPTS — INDEXES (SubTopicID = 5)
-- =============================================

INSERT INTO Concept (SubTopicID, ConceptName, Difficulty, LearningType, InterviewImportance, EstimatedSessions, Notes) VALUES
(5, 'What is an index and why it matters',
    'Basic', 'Theory', 4, 1,
    'Separate data structure for faster row lookups. Trade-off: faster reads, slower writes, additional storage.'),
(5, 'Clustered index',
    'Basic', 'Theory', 5, 1,
    'Defines physical order of data in the table. Only one per table. The table IS the clustered index — data pages are leaf nodes. No clustered index = heap table.'),
(5, 'Non-clustered index',
    'Basic', 'Theory', 5, 1,
    'Separate structure from table. Leaf nodes contain index key plus row locator. Multiple allowed per table. Points back to actual data row.'),
(5, 'Covering index',
    'Intermediate', 'Practice', 5, 1,
    'Non-clustered index including all query columns — avoids key lookup. INCLUDE clause adds non-key columns to leaf level. Most impactful index optimization technique.'),
(5, 'Composite index and column order',
    'Intermediate', 'Theory', 4, 1,
    'Index on multiple columns. Leading column must be in WHERE clause. Selectivity should guide order: most selective first.'),
(5, 'Table scan vs index seek vs index scan',
    'Intermediate', 'Theory', 5, 1,
    'Table scan = reads every row. Index seek = jumps directly using B-tree. Index scan = reads entire index. Know when each occurs.'),
(5, 'Heap table',
    'Intermediate', 'Theory', 3, 1,
    'Table with no clustered index. Data in no particular order. Row lookups use RID. Generally slower for range queries.'),
(5, 'Fill factor and fragmentation',
    'Advanced', 'Theory', 3, 1,
    'Fill factor controls page fullness at build time. Fragmentation degrades performance. Rebuild vs reorganize based on fragmentation percentage.'),
(5, 'Index on foreign keys',
    'Intermediate', 'Theory', 3, 1,
    'SQL Server does not auto-index foreign keys. Missing FK indexes cause table scans on joins. Common real-world performance problem.');

GO

-- =============================================
-- CONCEPTS — EXECUTION PLANS AND STATISTICS (SubTopicID = 6)
-- =============================================

INSERT INTO Concept (SubTopicID, ConceptName, Difficulty, LearningType, InterviewImportance, EstimatedSessions, Notes) VALUES
(6, 'Estimated vs actual execution plan',
    'Basic', 'Theory', 4, 1,
    'Estimated uses statistics, no query runs. Actual captured after execution. Discrepancy between estimated and actual rows = stale statistics.'),
(6, 'Reading an execution plan in SSMS',
    'Intermediate', 'Experience', 5, 2,
    'Read right to left, top to bottom. Thick arrows = more rows. Key operators: Index Seek, Table Scan, Hash Match, Nested Loops, Sort. Hover for cost.'),
(6, 'Cost percentage and bottleneck identification',
    'Intermediate', 'Experience', 4, 1,
    'Highest cost operator is the bottleneck. Sort or Hash Match at high cost = missing index or SARGability issue.'),
(6, 'Key Lookup — what it means and how to fix it',
    'Intermediate', 'Practice', 5, 1,
    'Non-clustered index used but query needs columns not in index — second lookup per row to base table. Fix: covering index with INCLUDE.'),
(6, 'Statistics — what they are and why they matter',
    'Intermediate', 'Theory', 4, 1,
    'Histograms about column data distribution. Optimizer uses them to estimate row counts. Stale statistics cause bad plans.'),
(6, 'SET STATISTICS IO and SET STATISTICS TIME',
    'Intermediate', 'Practice', 4, 1,
    'STATISTICS IO shows logical reads per table — most important performance metric. Lower is better. Use for before/after optimization measurement.'),
(6, 'Warnings in execution plans',
    'Intermediate', 'Experience', 4, 1,
    'Yellow triangle = problem. Common: missing index, implicit conversion, no join predicate. Missing index suggestions are starting points not final answers.');

GO

-- =============================================
-- CONCEPTS — QUERY OPTIMIZATION (SubTopicID = 7)
-- =============================================

INSERT INTO Concept (SubTopicID, ConceptName, Difficulty, LearningType, InterviewImportance, EstimatedSessions, Notes) VALUES
(7, 'SARGability — search argument able',
    'Intermediate', 'Practice', 5, 2,
    'WHERE condition is SARGable if SQL Server can use index seek. Functions on columns destroy SARGability. Most important optimization concept.'),
(7, 'Implicit conversion and its cost',
    'Intermediate', 'Theory', 4, 1,
    'Mismatched data types cause SQL Server to convert column — prevents index usage. Always match data types explicitly.'),
(7, 'Set-based vs row-based operations',
    'Intermediate', 'Theory', 5, 1,
    'SQL designed for set operations. Row-by-row is orders of magnitude slower on large datasets. Every cursor should be questioned.'),
(7, 'Avoiding SELECT star in production',
    'Basic', 'Theory', 3, 1,
    'SELECT * retrieves unused columns — unnecessary I/O, wider rows, more memory. Schema changes break dependent code silently.'),
(7, 'EXISTS vs IN vs JOIN for filtering',
    'Intermediate', 'Practice', 4, 1,
    'EXISTS stops at first match. IN materializes full subquery. For large subqueries EXISTS is usually faster. JOIN can duplicate rows.'),
(7, 'Avoiding functions on indexed columns in WHERE',
    'Intermediate', 'Practice', 5, 1,
    'Core SARGability rule. UPPER(Name) = x prevents index seek on Name. Rewrite to keep column bare on one side of the operator.'),
(7, 'Parameter sniffing',
    'Advanced', 'Theory', 4, 1,
    'Plan compiled on first parameter values. Unrepresentative first values cause bad plans for others. Solutions: OPTION RECOMPILE, OPTIMIZE FOR, local variables.'),
(7, 'Generating large datasets for testing',
    'Intermediate', 'Practice', 3, 1,
    'Use Python or recursive CTE to generate 50k-100k rows. Essential for measuring real before/after improvement with STATISTICS IO.');

GO

-- =============================================
-- CONCEPTS — STORED PROCEDURES (SubTopicID = 8)
-- =============================================

INSERT INTO Concept (SubTopicID, ConceptName, Difficulty, LearningType, InterviewImportance, EstimatedSessions, Notes) VALUES
(8, 'CREATE and ALTER PROCEDURE syntax',
    'Basic', 'Practice', 3, 1,
    'CREATE PROCEDURE with GO separator. Best practice: IF OBJECT_ID exists DROP then CREATE. usp_ naming convention.'),
(8, 'Input and output parameters',
    'Basic', 'Practice', 4, 1,
    'Input params with data type and optional DEFAULT. OUTPUT params require OUTPUT keyword in both definition and EXEC call.'),
(8, 'EXEC and sp_executesql for calling procedures',
    'Basic', 'Practice', 3, 1,
    'EXEC ProcedureName @param = value. Named parameter syntax preferred. sp_executesql for dynamic SQL inside procedures.'),
(8, 'Stored procedure vs ad hoc query',
    'Basic', 'Theory', 4, 1,
    'Procedures precompiled — plan cached. Enforce security — users can EXEC without direct table access. Reduces SQL injection surface.'),
(8, 'TRY CATCH in stored procedures',
    'Intermediate', 'Practice', 5, 1,
    'TRY block for logic, CATCH for error handling. ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_LINE() available in CATCH. Always wrap multi-statement procedures.'),
(8, 'Transaction management inside procedures',
    'Intermediate', 'Practice', 5, 1,
    'BEGIN TRANSACTION, COMMIT, ROLLBACK. Check @@TRANCOUNT before committing. ROLLBACK in CATCH to undo partial changes. Never leave open transaction.'),
(8, 'NOCOUNT and its importance',
    'Basic', 'Theory', 3, 1,
    'SET NOCOUNT ON suppresses rows affected messages. Reduces network traffic. Important in procedures called frequently from application code.'),
(8, 'Recompilation and OPTION RECOMPILE',
    'Advanced', 'Theory', 3, 1,
    'OPTION RECOMPILE forces new plan every execution — solves parameter sniffing at CPU cost. Use on procedures with highly variable parameters.');

GO

-- =============================================
-- CONCEPTS — VIEWS AND FUNCTIONS (SubTopicID = 9)
-- =============================================

INSERT INTO Concept (SubTopicID, ConceptName, Difficulty, LearningType, InterviewImportance, EstimatedSessions, Notes) VALUES
(9, 'Views — purpose and syntax',
    'Basic', 'Theory', 3, 1,
    'Stored SELECT accessed like a table. Simplifies complex queries. Security layer — grant view access without exposing base tables. Does NOT store data unless indexed.'),
(9, 'Indexed views',
    'Advanced', 'Theory', 3, 1,
    'View with unique clustered index — materializes result set on disk. Faster for repeated expensive aggregations. Requires SCHEMABINDING, no subqueries or outer joins.'),
(9, 'WITH SCHEMABINDING',
    'Intermediate', 'Theory', 3, 1,
    'Binds view or function to schema of underlying tables. Prevents DROP or ALTER of referenced tables. Required for indexed views.'),
(9, 'Scalar functions and their performance problem',
    'Intermediate', 'Theory', 5, 1,
    'Scalar UDF called once per row — destroys performance. Prevents parallelism, hides cost in execution plans. Replace with inline TVF or CASE expression.'),
(9, 'Inline Table-Valued Functions',
    'Intermediate', 'Practice', 4, 1,
    'Returns table result as single SELECT. Treated as macro by optimizer — inlined into calling query. No per-row overhead. Preferred over scalar UDFs.'),
(9, 'Multi-statement Table-Valued Functions',
    'Intermediate', 'Theory', 3, 1,
    'Returns table variable populated by multiple statements. Optimizer cannot see inside — unknown statistics. Performance similar to scalar UDFs. Use inline TVF instead.'),
(9, 'CTE vs View vs Temp Table — when to use which',
    'Intermediate', 'Theory', 5, 1,
    'CTE: one-time, no storage. View: reusable saved query, no storage unless indexed. Temp table: physical in tempdb, multiple statements, indexable. Classic interview comparison.');

GO

-- =============================================
-- CONCEPTS — TRANSACTIONS AND LOCKING (SubTopicID = 10)
-- =============================================

INSERT INTO Concept (SubTopicID, ConceptName, Difficulty, LearningType, InterviewImportance, EstimatedSessions, Notes) VALUES
(10, 'ACID properties',
    'Basic', 'Theory', 5, 1,
    'Atomicity: all or nothing. Consistency: valid state to valid state. Isolation: concurrent transactions do not interfere. Durability: committed data survives failures. Must explain each with example.'),
(10, 'BEGIN TRANSACTION, COMMIT, ROLLBACK',
    'Basic', 'Practice', 5, 1,
    'BEGIN TRANSACTION starts explicit transaction. COMMIT makes changes permanent. ROLLBACK undoes changes. @@TRANCOUNT tracks nesting level.'),
(10, 'Implicit vs explicit transactions',
    'Basic', 'Theory', 3, 1,
    'Implicit: each DML is auto-committed. Explicit: developer controls BEGIN/COMMIT/ROLLBACK. SET IMPLICIT_TRANSACTIONS ON changes default behavior.'),
(10, 'Isolation levels',
    'Advanced', 'Theory', 4, 2,
    'READ UNCOMMITTED: dirty reads. READ COMMITTED: default. REPEATABLE READ: no phantom reads. SERIALIZABLE: full isolation. SNAPSHOT: row versioning, no blocking. Know trade-offs.'),
(10, 'Locks — shared, exclusive, update',
    'Intermediate', 'Theory', 4, 1,
    'Shared (S): reads, compatible with other shared. Exclusive (X): writes, incompatible with everything. Update (U): prevents deadlock in read-then-update pattern. Granularity: row, page, table.'),
(10, 'Deadlocks — cause and prevention',
    'Intermediate', 'Theory', 4, 1,
    'Circular wait — two transactions each hold a lock the other needs. SQL Server kills the victim. Prevention: consistent lock ordering, short transactions, appropriate isolation level.'),
(10, 'Blocking vs deadlocking',
    'Intermediate', 'Theory', 4, 1,
    'Blocking: waiting for lock release — eventually resolves. Deadlocking: circular wait — never resolves. Blocking is normal; excessive blocking indicates long transactions or missing indexes.'),
(10, 'SAVEPOINT and nested transactions',
    'Advanced', 'Theory', 2, 1,
    'SAVE TRANSACTION name creates savepoint. ROLLBACK TO name rolls back to savepoint without ending transaction. @@TRANCOUNT does not decrease on nested BEGIN.');

GO

-- =============================================
-- CONCEPTS — ERROR HANDLING (SubTopicID = 11)
-- =============================================

INSERT INTO Concept (SubTopicID, ConceptName, Difficulty, LearningType, InterviewImportance, EstimatedSessions, Notes) VALUES
(11, 'TRY CATCH syntax',
    'Basic', 'Practice', 5, 1,
    'BEGIN TRY...END TRY BEGIN CATCH...END CATCH. Errors severity 11+ trigger CATCH. Severity 10 or lower are informational — do not trigger CATCH.'),
(11, 'Error functions inside CATCH',
    'Basic', 'Practice', 4, 1,
    'ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_LINE(), ERROR_PROCEDURE(). All available inside CATCH block only.'),
(11, 'THROW vs RAISERROR',
    'Intermediate', 'Theory', 4, 1,
    'RAISERROR: older syntax, does not re-throw original error cleanly. THROW: newer, re-throws with original number and message. THROW inside CATCH with no params re-throws exactly. Prefer THROW.'),
(11, 'Combining TRY CATCH with transactions',
    'Intermediate', 'Practice', 5, 1,
    'Pattern: BEGIN TRY BEGIN TRAN ... COMMIT END TRY BEGIN CATCH IF @@TRANCOUNT > 0 ROLLBACK THROW END CATCH. Correct production pattern — must know this for any stored procedure interview.'),
(11, 'XACT_STATE inside CATCH',
    'Advanced', 'Theory', 3, 1,
    'XACT_STATE() returns 1 (committable), -1 (uncommittable — must rollback), 0 (no transaction). Check before deciding to commit or rollback inside CATCH.');

GO

-- =============================================
-- CONCEPTS — DYNAMIC SQL (SubTopicID = 12)
-- =============================================

INSERT INTO Concept (SubTopicID, ConceptName, Difficulty, LearningType, InterviewImportance, EstimatedSessions, Notes) VALUES
(12, 'EXEC with string — basic dynamic SQL',
    'Basic', 'Practice', 3, 1,
    'Build SQL string in variable and execute with EXEC(@sql). Simple but vulnerable to SQL injection if user input is concatenated directly.'),
(12, 'sp_executesql — parameterized dynamic SQL',
    'Intermediate', 'Practice', 5, 1,
    'sp_executesql @sql, @paramdef, @param = value. Supports parameters — prevents SQL injection. Plan cached and reused. Always prefer over EXEC for dynamic SQL.'),
(12, 'SQL injection — understanding the risk',
    'Intermediate', 'Theory', 4, 1,
    'String concatenation with user input allows malicious SQL. Classic: OR 1=1 to bypass WHERE. sp_executesql with params prevents this. Know attack pattern and defense.'),
(12, 'Dynamic SQL for dynamic column or table names',
    'Intermediate', 'Practice', 3, 1,
    'Column and table names cannot be parameterized — must be concatenated. Use QUOTENAME() to safely wrap identifiers. Validate input before concatenating.'),
(12, 'QUOTENAME — safe identifier wrapping',
    'Intermediate', 'Practice', 3, 1,
    'QUOTENAME(string) wraps in square brackets and escapes embedded brackets. Prevents identifier injection. Always use when concatenating identifiers into dynamic SQL.'),
(12, 'Scope in dynamic SQL',
    'Intermediate', 'Theory', 3, 1,
    'Dynamic SQL executes in its own scope — cannot see local variables from calling scope unless passed as parameters. #TempTables visible if created in same session before EXEC.');

GO

-- =============================================
-- CONCEPTS — TRIGGERS (SubTopicID = 13)
-- =============================================

INSERT INTO Concept (SubTopicID, ConceptName, Difficulty, LearningType, InterviewImportance, EstimatedSessions, Notes) VALUES
(13, 'DML triggers — AFTER vs INSTEAD OF',
    'Basic', 'Theory', 4, 1,
    'AFTER fires after DML completes. INSTEAD OF fires instead of DML — replaces the operation. INSTEAD OF commonly used on views to make them updatable.'),
(13, 'INSERTED and DELETED virtual tables',
    'Basic', 'Practice', 5, 1,
    'INSERTED holds new rows for INSERT and UPDATE. DELETED holds old rows for DELETE and UPDATE. Must join against these to get affected row data — no direct row access.'),
(13, 'Statement-level not row-level triggers',
    'Basic', 'Theory', 3, 1,
    'SQL Server triggers fire once per statement not once per row. INSERTED and DELETED can contain multiple rows. Common mistake: writing trigger assuming one row at a time.'),
(13, 'INSTEAD OF trigger on views',
    'Intermediate', 'Practice', 3, 1,
    'Views joining multiple tables are not directly updatable. INSTEAD OF intercepts DML and routes to correct base tables. Makes complex views appear updatable.'),
(13, 'Trigger performance and when to avoid them',
    'Intermediate', 'Theory', 4, 1,
    'Triggers add overhead to every DML — hidden cost. Difficult to debug and maintain. Use for audit logging or complex business rule enforcement. Avoid when application code can handle it.'),
(13, 'Recursive and nested triggers',
    'Advanced', 'Theory', 2, 1,
    'Nested: trigger fires DML that fires another trigger. Recursive: trigger fires DML on same table firing itself. Both controlled by server settings. Generally avoided.');

GO

-- =============================================
-- CONCEPTS — SCHEMA DESIGN AND NORMALIZATION (SubTopicID = 14)
-- =============================================

INSERT INTO Concept (SubTopicID, ConceptName, Difficulty, LearningType, InterviewImportance, EstimatedSessions, Notes) VALUES
(14, 'First Normal Form — 1NF',
    'Basic', 'Theory', 4, 1,
    'Atomic values — no repeating groups, no comma-separated lists in one column. Every row uniquely identifiable by primary key.'),
(14, 'Second Normal Form — 2NF',
    'Basic', 'Theory', 4, 1,
    'Must be 1NF. Every non-key column depends on ENTIRE primary key. Only relevant with composite primary keys. Violation: partial dependency.'),
(14, 'Third Normal Form — 3NF',
    'Basic', 'Theory', 4, 1,
    'Must be 2NF. No transitive dependencies — non-key columns depend only on primary key, not on other non-key columns.'),
(14, 'Denormalization — when and why',
    'Intermediate', 'Theory', 4, 1,
    'Intentional redundancy for performance. Reduces expensive joins. Trade-off: faster reads, harder writes, inconsistency risk. Common in data warehouses.'),
(14, 'Primary keys and surrogate vs natural keys',
    'Basic', 'Theory', 3, 1,
    'Natural key: real-world attribute (email). Surrogate key: system-generated (INT IDENTITY). Surrogate keys preferred — natural keys can change.'),
(14, 'Foreign keys and referential integrity',
    'Basic', 'Theory', 4, 1,
    'FK enforces value must exist in referenced table. Prevents orphan records. CASCADE options have unintended consequences — use carefully.'),
(14, 'Fact and dimension tables',
    'Intermediate', 'Theory', 4, 1,
    'Dimension: descriptive, static reference data. Fact: records of events, grows over time, references dimensions via FK. Star schema vs snowflake distinction.'),
(14, 'Bridge tables — many-to-many relationships',
    'Basic', 'Practice', 3, 1,
    'Many-to-many cannot be directly represented. Bridge table has two FKs — one to each side. Composite PK on both FK columns.'),
(14, 'Choosing correct data types',
    'Basic', 'Theory', 3, 1,
    'Use smallest data type that fits. INT vs BIGINT, VARCHAR vs NVARCHAR, DATE vs DATETIME2. NVARCHAR for Unicode. DATETIME2 preferred over DATETIME for precision.');

GO

-- =============================================
-- CONCEPTS — LOOPING AND CURSORS (SubTopicID = 15)
-- =============================================

INSERT INTO Concept (SubTopicID, ConceptName, Difficulty, LearningType, InterviewImportance, EstimatedSessions, Notes) VALUES
(15, 'WHILE loop syntax',
    'Basic', 'Practice', 3, 1,
    'WHILE condition BEGIN...END. Must update condition inside loop. BREAK exits. CONTINUE skips to next iteration. Used when set-based approach is not possible.'),
(15, 'Cursor syntax and lifecycle',
    'Intermediate', 'Practice', 4, 1,
    'DECLARE, OPEN, FETCH NEXT INTO, WHILE @@FETCH_STATUS = 0, CLOSE, DEALLOCATE. Full lifecycle must be known. Forgetting CLOSE or DEALLOCATE leaks resources.'),
(15, 'Cursor types — FAST_FORWARD and others',
    'Intermediate', 'Theory', 3, 1,
    'FAST_FORWARD: forward-only, read-only, fastest. STATIC: snapshot at open. DYNAMIC: reflects changes. KEYSET: compromise. Always use FAST_FORWARD unless you need otherwise.'),
(15, 'Why cursors are bad — the interview answer',
    'Intermediate', 'Theory', 5, 1,
    'Cursors process row by row — each FETCH is a separate operation. 100k rows = 100k operations vs one set-based statement. Can be 10-100x slower. Must have a clear answer to this.'),
(15, 'Replacing cursors with set-based alternatives',
    'Intermediate', 'Practice', 5, 2,
    'Most cursor logic rewrites as UPDATE with CASE, INSERT SELECT, UPDATE with JOIN. Running totals become SUM OVER. Sequential numbering becomes ROW_NUMBER. Core practical skill.'),
(15, 'When cursors are acceptable',
    'Intermediate', 'Theory', 3, 1,
    'Administrative tasks: running a procedure per row, DDL per database, emails per row. When operation itself is not set-based. Small datasets where performance is not a concern.');

GO

-- =============================================
-- CONCEPTS — T-SQL MISCELLANEOUS (SubTopicID = 16)
-- =============================================

INSERT INTO Concept (SubTopicID, ConceptName, Difficulty, LearningType, InterviewImportance, EstimatedSessions, Notes) VALUES
(16, 'String functions',
    'Basic', 'Practice', 3, 1,
    'LEN, LEFT, RIGHT, SUBSTRING, CHARINDEX, PATINDEX, REPLACE, STUFF, STRING_AGG, STRING_SPLIT. STRING_AGG for concatenating rows into one. STRING_SPLIT for splitting delimited strings into rows.'),
(16, 'Date and time functions',
    'Basic', 'Practice', 4, 1,
    'GETDATE, GETUTCDATE, SYSDATETIME. DATEADD, DATEDIFF, DATEPART, DATENAME, FORMAT, EOMONTH, DATEFROMPARTS. Know how to get first and last day of month, year, quarter.'),
(16, 'NULL handling — ISNULL, COALESCE, NULLIF',
    'Basic', 'Practice', 4, 1,
    'ISNULL(col, replacement): SQL Server only, two args. COALESCE: ANSI standard, first non-NULL from list. NULLIF(a,b): returns NULL if a equals b — avoids division by zero.'),
(16, 'Temporary tables vs table variables vs CTEs',
    'Intermediate', 'Theory', 5, 1,
    '#Temp: tempdb, indexable, statistics maintained, visible to called procs. @Table: memory usually, no statistics, batch scope. CTE: no storage, one query. Frequent interview comparison.'),
(16, 'PIVOT and UNPIVOT',
    'Intermediate', 'Practice', 3, 1,
    'PIVOT rotates rows to columns. UNPIVOT reverses. Dynamic PIVOT needed when column values unknown at write time. Verbose syntax — practice it.'),
(16, 'MERGE statement',
    'Intermediate', 'Practice', 4, 1,
    'INSERT, UPDATE, DELETE in one statement. WHEN MATCHED THEN UPDATE, WHEN NOT MATCHED THEN INSERT, WHEN NOT MATCHED BY SOURCE THEN DELETE. Used heavily in ETL. Know edge cases.'),
(16, 'CTE for DELETE and UPDATE',
    'Intermediate', 'Practice', 4, 1,
    'CTEs can be target of UPDATE and DELETE. WITH cte AS (...) DELETE FROM cte. Useful for deleting duplicates keeping one row per group using ROW_NUMBER inside CTE.'),
(16, 'OUTPUT clause',
    'Intermediate', 'Practice', 3, 1,
    'Returns rows affected by INSERT, UPDATE, DELETE, MERGE. INSERTED.col for new values, DELETED.col for old. Can INSERT into table variable using OUTPUT INTO. Useful for audit without trigger.'),
(16, 'System functions and metadata',
    'Basic', 'Theory', 2, 1,
    'OBJECT_ID() to check existence. INFORMATION_SCHEMA views. sys.tables, sys.columns, sys.indexes. @@ROWCOUNT for rows affected by last statement.'),
(16, 'SCOPE_IDENTITY vs IDENTITY vs IDENT_CURRENT',
    'Intermediate', 'Theory', 4, 1,
    'SCOPE_IDENTITY(): last identity in current scope and session — safest. @@IDENTITY: last identity in session across all scopes — can return trigger values. IDENT_CURRENT(table): any session. Always use SCOPE_IDENTITY in application code.');

GO

-- =============================================
-- CONCEPT PREREQUISITES
-- Name-based lookup — no hardcoded IDs
-- =============================================

-- Basic Queries: HAVING requires GROUP BY
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'HAVING clause' AND p.ConceptName = 'GROUP BY and aggregate functions';

-- Joins: Multi-table JOINs requires INNER JOIN
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'Multi-table JOINs' AND p.ConceptName = 'INNER JOIN';

-- Joins: SELF JOIN requires INNER JOIN
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'SELF JOIN' AND p.ConceptName = 'INNER JOIN';

-- Joins: Fan-out problem requires Multi-table JOINs
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'Duplicate rows from JOINs — fan-out problem' AND p.ConceptName = 'Multi-table JOINs';

-- CTEs: Filtering on aggregated aliases requires Basic CTE syntax
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'Filtering on aggregated aliases using CTE' AND p.ConceptName = 'Basic CTE syntax';

-- CTEs: Stacked CTEs requires Basic CTE syntax
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'Stacked CTEs' AND p.ConceptName = 'Basic CTE syntax';

-- CTEs: CTE referencing another CTE requires Stacked CTEs
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'CTE referencing another CTE' AND p.ConceptName = 'Stacked CTEs';

-- CTEs: CTE combined with Window Functions requires both
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'CTE combined with Window Functions' AND p.ConceptName = 'Stacked CTEs';

INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'CTE combined with Window Functions' AND p.ConceptName = 'PARTITION BY';

-- CTEs: Recursive CTEs requires CTE referencing another CTE
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'Recursive CTEs' AND p.ConceptName = 'CTE referencing another CTE';

-- Window Functions: PARTITION BY requires OVER clause
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'PARTITION BY' AND p.ConceptName = 'OVER clause — the foundation';

-- Window Functions: ROW_NUMBER requires PARTITION BY
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'ROW_NUMBER' AND p.ConceptName = 'PARTITION BY';

-- Window Functions: RANK requires ROW_NUMBER
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'RANK and DENSE_RANK' AND p.ConceptName = 'ROW_NUMBER';

-- Window Functions: LAG and LEAD requires PARTITION BY
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'LAG and LEAD' AND p.ConceptName = 'PARTITION BY';

-- Window Functions: SUM OVER requires ROW_NUMBER
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'SUM OVER and AVG OVER — running totals' AND p.ConceptName = 'ROW_NUMBER';

-- Window Functions: ROWS BETWEEN requires SUM OVER
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'ROWS BETWEEN frame clause' AND p.ConceptName = 'SUM OVER and AVG OVER — running totals';

-- Window Functions: NTILE requires PARTITION BY
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'NTILE' AND p.ConceptName = 'PARTITION BY';

-- Indexes: Covering index requires Non-clustered index
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'Covering index' AND p.ConceptName = 'Non-clustered index';

-- Indexes: Composite index requires Non-clustered index
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'Composite index and column order' AND p.ConceptName = 'Non-clustered index';

-- Indexes: Table scan vs seek requires clustered and non-clustered
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'Table scan vs index seek vs index scan' AND p.ConceptName = 'Clustered index';

INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'Table scan vs index seek vs index scan' AND p.ConceptName = 'Non-clustered index';

-- Execution Plans: Reading plans requires Estimated vs Actual
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'Reading an execution plan in SSMS' AND p.ConceptName = 'Estimated vs actual execution plan';

-- Execution Plans: Key Lookup requires covering index and reading plans
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'Key Lookup — what it means and how to fix it' AND p.ConceptName = 'Covering index';

INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'Key Lookup — what it means and how to fix it' AND p.ConceptName = 'Reading an execution plan in SSMS';

-- Query Optimization: SARGability requires table scan vs seek
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'SARGability — search argument able' AND p.ConceptName = 'Table scan vs index seek vs index scan';

-- Query Optimization: Avoiding functions requires SARGability
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'Avoiding functions on indexed columns in WHERE' AND p.ConceptName = 'SARGability — search argument able';

-- Query Optimization: Parameter sniffing requires stored procedures
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'Parameter sniffing' AND p.ConceptName = 'CREATE and ALTER PROCEDURE syntax';

-- Stored Procedures: TRY CATCH requires basic syntax
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'TRY CATCH in stored procedures' AND p.ConceptName = 'CREATE and ALTER PROCEDURE syntax';

-- Stored Procedures: Transaction management requires TRY CATCH and transactions
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'Transaction management inside procedures' AND p.ConceptName = 'TRY CATCH in stored procedures';

INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'Transaction management inside procedures' AND p.ConceptName = 'BEGIN TRANSACTION, COMMIT, ROLLBACK';

-- Views: Indexed views requires SCHEMABINDING
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'Indexed views' AND p.ConceptName = 'WITH SCHEMABINDING';

-- Views: Inline TVF requires scalar function knowledge
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'Inline Table-Valued Functions' AND p.ConceptName = 'Scalar functions and their performance problem';

-- Transactions: Isolation levels requires basic transactions
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'Isolation levels' AND p.ConceptName = 'BEGIN TRANSACTION, COMMIT, ROLLBACK';

-- Transactions: Deadlocks requires locks
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'Deadlocks — cause and prevention' AND p.ConceptName = 'Locks — shared, exclusive, update';

-- Error Handling: THROW requires TRY CATCH
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'THROW vs RAISERROR' AND p.ConceptName = 'TRY CATCH syntax';

-- Error Handling: Combining TRY CATCH with transactions requires both
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'Combining TRY CATCH with transactions' AND p.ConceptName = 'TRY CATCH syntax';

INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'Combining TRY CATCH with transactions' AND p.ConceptName = 'BEGIN TRANSACTION, COMMIT, ROLLBACK';

-- Dynamic SQL: sp_executesql requires basic EXEC
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'sp_executesql — parameterized dynamic SQL' AND p.ConceptName = 'EXEC with string — basic dynamic SQL';

-- Dynamic SQL: QUOTENAME requires dynamic identifiers
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'QUOTENAME — safe identifier wrapping' AND p.ConceptName = 'Dynamic SQL for dynamic column or table names';

-- Schema Design: 2NF requires 1NF
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'Second Normal Form — 2NF' AND p.ConceptName = 'First Normal Form — 1NF';

-- Schema Design: 3NF requires 2NF
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'Third Normal Form — 3NF' AND p.ConceptName = 'Second Normal Form — 2NF';

-- Schema Design: Denormalization requires 3NF
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'Denormalization — when and why' AND p.ConceptName = 'Third Normal Form — 3NF';

-- Cursors: Why cursors are bad requires cursor syntax
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'Why cursors are bad — the interview answer' AND p.ConceptName = 'Cursor syntax and lifecycle';

-- Cursors: Replacing cursors requires understanding why they are bad
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'Replacing cursors with set-based alternatives' AND p.ConceptName = 'Why cursors are bad — the interview answer';

-- Miscellaneous: Temp tables vs table variables requires CTE knowledge
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'Temporary tables vs table variables vs CTEs' AND p.ConceptName = 'Basic CTE syntax';

-- Miscellaneous: CTE for DELETE/UPDATE requires basic CTE
INSERT INTO ConceptPrerequisite (ConceptID, PrerequisiteConceptID)
SELECT c.ConceptID, p.ConceptID FROM Concept c JOIN Concept p
ON c.ConceptName = 'CTE for DELETE and UPDATE' AND p.ConceptName = 'Basic CTE syntax';

GO

-- =============================================
-- CONCEPT PROGRESS — initialize all concepts
-- One row per concept, all start at Not Started
-- =============================================

INSERT INTO ConceptProgress (ConceptID, Status, TimesPracticed)
SELECT ConceptID, 'Not Started', 0
FROM Concept;

GO

-- =============================================
-- VERIFICATION QUERIES
-- =============================================

-- Full syllabus summary by subtopic
SELECT
    st.OrderSequence                                                    AS [Order],
    st.SubTopicName,
    COUNT(c.ConceptID)                                                  AS TotalConcepts,
    SUM(CASE WHEN c.Difficulty = 'Basic'        THEN 1 ELSE 0 END)     AS Basic,
    SUM(CASE WHEN c.Difficulty = 'Intermediate' THEN 1 ELSE 0 END)     AS Intermediate,
    SUM(CASE WHEN c.Difficulty = 'Advanced'     THEN 1 ELSE 0 END)     AS Advanced,
    SUM(c.EstimatedSessions)                                            AS EstSessions
FROM SubTopic st
JOIN Concept c ON st.SubTopicID = c.SubTopicID
GROUP BY st.OrderSequence, st.SubTopicName
ORDER BY st.OrderSequence;

GO

-- Overall totals
SELECT
    COUNT(*)                                                            AS TotalConcepts,
    SUM(CASE WHEN InterviewImportance >= 4  THEN 1 ELSE 0 END)         AS HighImportance,
    SUM(CASE WHEN LearningType = 'Practice'   THEN 1 ELSE 0 END)       AS NeedsPractice,
    SUM(CASE WHEN LearningType = 'Theory'     THEN 1 ELSE 0 END)       AS TheoryOnly,
    SUM(CASE WHEN LearningType = 'Experience' THEN 1 ELSE 0 END)       AS NeedsExperience,
    SUM(EstimatedSessions)                                              AS TotalEstimatedSessions
FROM Concept;

GO
