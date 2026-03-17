-- ============================================================
-- QuestionBank Population — ConceptID 29
-- SUM OVER and AVG OVER — running totals
-- Session 005 — 17 March 2026
-- 5 questions — InterviewImportance 5
-- All questions run against ConversationLog and Concept
-- ============================================================

USE Megamind;
GO

INSERT INTO QuestionBank
    (ConceptID, QuestionDescription, Difficulty, QuestionType, ExpectedOutput, Notes)
VALUES

(29,
'Using ConversationLog, write a query showing each session in date order with a running total of DifficultyLevel.
Output columns: SessionDate, DifficultyLevel, RunningTotal.
No PARTITION BY. Running total accumulates across all rows ordered by SessionDate.
Hint: SUM(DifficultyLevel) OVER (ORDER BY SessionDate).',
'Basic',
'Practice',
'4 rows. RunningTotal increases with each row — 4, 7, 11, 14 with current data.',
'Most fundamental running total pattern. SUM OVER with ORDER BY only. No partition, no frame clause. First window function every SQL Developer must write cleanly.'),

(29,
'Using ConversationLog, show each session with both a running count of sessions and a running sum of DifficultyLevel — both accumulating from the first session to the current row.
Output columns: SessionDate, SessionTitle, DifficultyLevel, RunningSessionCount, RunningDifficultyTotal.
Both window functions in the same SELECT. No CTE needed.
Hint: COUNT(*) OVER (ORDER BY SessionDate) and SUM(DifficultyLevel) OVER (ORDER BY SessionDate) — each is an independent window expression.',
'Basic',
'Interview',
'4 rows. RunningSessionCount goes 1,2,3,4. RunningDifficultyTotal accumulates DifficultyLevel values in date order.',
'Two independent window functions in one SELECT. Tests that the student knows each OVER clause is evaluated separately. Common mistake: trying to reference one window result inside another OVER clause.'),

(29,
'Using ConversationLog, show each session with a running total of DifficultyLevel that resets for each calendar month.
Output columns: SessionDate, SessionTitle, DifficultyLevel, MonthlyRunningTotal.
Hint: PARTITION BY FORMAT(SessionDate, ''yyyy-MM'') ORDER BY SessionDate inside SUM OVER. The partition key is derived from the date — not a raw column.',
'Intermediate',
'Interview',
'MonthlyRunningTotal resets to the session''s own DifficultyLevel at the start of each new month. Sessions in the same month accumulate together.',
'Partitioned running total with a date-derived partition key. Tests whether the student knows PARTITION BY can use an expression, not just a raw column. Common in monthly reporting patterns.'),

(29,
'Using ConversationLog, show each session with a running average of DifficultyLevel up to that point. Then flag each session as Above, Below, or Equal compared to the running average at that point.
Output columns: SessionDate, DifficultyLevel, RunningAvgDifficulty, AboveOrBelow.
Use CAST to avoid integer division. Wrap the window function in a CTE — compute once, reference twice in the CASE expression.
Hint: CTE computes AVG(CAST(DifficultyLevel AS DECIMAL(5,2))) OVER (ORDER BY SessionDate). Outer SELECT uses CASE WHEN DifficultyLevel > RunningAvgDifficulty THEN ''Above'' pattern.',
'Intermediate',
'Interview',
'4 rows. RunningAvgDifficulty shows true decimal averages — not integer truncated. AboveOrBelow correctly labels each session relative to the running average at that point.',
'Two key lessons: CAST for accurate AVG on integer columns, and CTE wrapping to avoid repeating the window expression inside CASE. Integer division trap is a known interview gotcha — a candidate who catches it proactively stands out.'),

(29,
'Using Concept, show a 3-row moving average of InterviewImportance ordered by ConceptID — current row plus the 2 rows immediately before it. Use CAST to avoid integer division.
Output columns: ConceptID, ConceptName, InterviewImportance, MovingAvg3.
First row averages only itself. Second row averages 2 rows. From the third row onward averages 3 rows.
Hint: AVG(CAST(InterviewImportance AS DECIMAL(5,2))) OVER (ORDER BY ConceptID ROWS BETWEEN 2 PRECEDING AND CURRENT ROW). This requires an explicit frame clause.',
'Advanced',
'Interview',
'121 rows. MovingAvg3 for first row equals its own value. Second row averages 2 concepts. From ConceptID 3 onward the window is fully 3 rows wide.',
'Moving average requires ROWS BETWEEN — this bridges ConceptID 29 and 30 naturally. A student who writes this correctly is ready for the full ROWS BETWEEN concept. Tests explicit frame clause syntax for the first time.');


Select * From QuestionBank Where ConceptID = 29;