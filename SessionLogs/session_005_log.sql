-- ============================================================
-- Session 005 Log
-- Date: 17 March 2026
-- Title: SUM OVER Running Totals, QuestionBank Workflow and Script Reorganization
-- ============================================================
-- Run order:
--   1. ConversationLog entry
--   2. SessionConcept entry
--   3. ConceptProgress update
--   4. PracticeLog entries
-- ============================================================

USE Megamind;
GO

-- ============================================================
-- 1. ConversationLog
-- ============================================================

INSERT INTO ConversationLog
    (SessionDate, SessionNumber, SessionTitle, TopicsCovered, Summary, KeyConcepts, NextSession, DifficultyLevel)
VALUES
(
    '2026-03-17',
    5,
    'SUM OVER Running Totals, QuestionBank Workflow and Script Reorganization',
    'Window Functions, System Design, Script Cleanup',
    'Completed ConceptID 29 — SUM OVER and AVG OVER running totals. Practiced running totals, partitioned running totals, running averages, integer division trap, and CTE wrapping for CASE comparison. Redesigned ProblemBank into QuestionBank with new per-concept generation workflow. Performed full script gap analysis and reorganized DEV folder structure. Updated all state files. Assessment completed — 4 of 5 questions answered. Question 5 deferred to ConceptID 30.',
    'SUM OVER, AVG OVER, PARTITION BY with date expression, CAST for integer division, CTE wrapping window functions',
    'ConceptID 30 ROWS BETWEEN frame clause. Then ConceptID 23 Recursive CTEs.',
    3
);
GO

-- ============================================================
-- 2. SessionConcept
-- ============================================================

INSERT INTO SessionConcept
    (SessionID, ConceptID, DepthReached, InterviewReadinessAfter, Notes)
VALUES
(5, 29, 4, 4, 'All practice problems solved independently. CAST for integer division caught independently. CTE wrapping pattern solid. 4 of 5 assessment questions completed. Question 5 deferred — requires ROWS BETWEEN which is ConceptID 30.');
GO

-- ============================================================
-- 3. ConceptProgress — ConceptID 29
-- ============================================================

UPDATE ConceptProgress
SET
    Status          = 'In Progress',
    TimesPracticed  = TimesPracticed + 1,
    LastPracticed   = '2026-03-17',
    RevisionDueDate = '2026-03-21',
    UpdatedAt       = GETDATE()
WHERE ConceptID = 29;
GO

-- ============================================================
-- 4. PracticeLog — Session 005 assessment
-- QuestionID 5 deferred to ConceptID 30 session — not logged
-- ============================================================

INSERT INTO PracticeLog
    (QuestionID, SessionID, SolvedIndependently, TimeTakenMins, Notes)
VALUES
(1, 5, 1, NULL, 'Clean first attempt. Basic SUM OVER pattern.'),
(2, 5, 1, NULL, 'Two independent window functions in one SELECT. Clean.'),
(3, 5, 1, NULL, 'Used MONTH() instead of FORMAT yyyy-MM — works but not production safe. Noted.'),
(4, 5, 1, NULL, 'CTE + CAST + CASE all correct. Used explicit WHEN for Equal instead of ELSE — minor verbosity.');
GO

-- ============================================================
-- Verify
-- ============================================================

SELECT 'ConversationLog'                AS TableName, COUNT(*) AS Rows FROM ConversationLog
UNION ALL
SELECT 'SessionConcept',                  COUNT(*) FROM SessionConcept
UNION ALL
SELECT 'PracticeLog',                     COUNT(*) FROM PracticeLog
UNION ALL
SELECT 'ConceptProgress In Progress',     COUNT(*) FROM ConceptProgress WHERE Status = 'In Progress';
GO
