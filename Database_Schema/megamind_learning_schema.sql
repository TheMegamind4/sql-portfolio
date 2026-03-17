-- =============================================
-- MEGAMIND LEARNING SCHEMA
-- File: megamind_learning_schema.sql
-- Run order: 2nd — run after megamind_master_schema.sql
-- =============================================
-- Drops:
--   LearningTopics  — retired, replaced by new system
-- Creates:
--   Topic, SubTopic, Concept, ConceptPrerequisite
--   ProblemBank, ConceptProgress, PracticeLog, SessionConcept
-- =============================================

USE Megamind;
GO


-- =============================================
-- DIMENSION TABLES
-- =============================================

-- Top level subject area
-- e.g. SQL, Python, Tools, Domain Knowledge
CREATE TABLE Topic (
    TopicID         INT IDENTITY(1,1) PRIMARY KEY,
    TopicName       NVARCHAR(100) NOT NULL,
    Category        NVARCHAR(50) NOT NULL,        -- 'Technical', 'Domain', 'Tools'
    Description     NVARCHAR(300),
    IsActive        BIT DEFAULT 1,                -- 0 = future scope, not currently studying
    CreatedAt       DATETIME DEFAULT GETDATE()
);

-- Grouping layer between Topic and Concept
-- e.g. Window Functions, CTEs, Indexes under SQL
CREATE TABLE SubTopic (
    SubTopicID      INT IDENTITY(1,1) PRIMARY KEY,
    TopicID         INT NOT NULL FOREIGN KEY REFERENCES Topic(TopicID),
    SubTopicName    NVARCHAR(100) NOT NULL,
    OrderSequence   INT NOT NULL,                 -- recommended learning order within topic
    CreatedAt       DATETIME DEFAULT GETDATE()
);

-- Individual learnable unit — the core of the system
-- e.g. LAG and LEAD, ROW_NUMBER, Recursive CTEs
CREATE TABLE Concept (
    ConceptID           INT IDENTITY(1,1) PRIMARY KEY,
    SubTopicID          INT NOT NULL FOREIGN KEY REFERENCES SubTopic(SubTopicID),
    ConceptName         NVARCHAR(200) NOT NULL,
    Difficulty          NVARCHAR(20) NOT NULL
                        CHECK (Difficulty IN ('Basic', 'Intermediate', 'Advanced')),
    LearningType        NVARCHAR(20) NOT NULL
                        CHECK (LearningType IN ('Theory', 'Practice', 'Experience')),
    InterviewImportance TINYINT NOT NULL
                        CHECK (InterviewImportance BETWEEN 1 AND 5),
    EstimatedSessions   INT,
    Notes               NVARCHAR(1000),
    CreatedAt           DATETIME DEFAULT GETDATE()
);

-- Self-referencing bridge — concept prerequisites
-- One concept can have multiple prerequisites
CREATE TABLE ConceptPrerequisite (
    ConceptID               INT NOT NULL FOREIGN KEY REFERENCES Concept(ConceptID),
    PrerequisiteConceptID   INT NOT NULL FOREIGN KEY REFERENCES Concept(ConceptID),
    PRIMARY KEY (ConceptID, PrerequisiteConceptID)
);

-- All problems and interview questions in one place
CREATE TABLE ProblemBank (
    ProblemID           INT IDENTITY(1,1) PRIMARY KEY,
    ConceptID           INT NOT NULL FOREIGN KEY REFERENCES Concept(ConceptID),
    ProblemDescription  NVARCHAR(2000) NOT NULL,
    Difficulty          NVARCHAR(20) NOT NULL
                        CHECK (Difficulty IN ('Basic', 'Intermediate', 'Advanced')),
    ProblemType         NVARCHAR(20) NOT NULL
                        CHECK (ProblemType IN ('Practice', 'Interview')),
    ExpectedOutput      NVARCHAR(1000),
    Notes               NVARCHAR(500),
    CreatedAt           DATETIME DEFAULT GETDATE()
);

-- =============================================
-- TRACKING / FACT TABLES
-- =============================================

-- One row per concept — current learning state
-- Auto updated when SessionConcept or PracticeLog entries are added
CREATE TABLE ConceptProgress (
    ProgressID          INT IDENTITY(1,1) PRIMARY KEY,
    ConceptID           INT NOT NULL UNIQUE FOREIGN KEY REFERENCES Concept(ConceptID),
    Status              NVARCHAR(30) NOT NULL DEFAULT 'Not Started'
                        CHECK (Status IN ('Not Started', 'In Progress', 'Needs Revision', 'Interview Ready')),
    TimesPracticed      INT DEFAULT 0,
    LastPracticed       DATE,
    RevisionDueDate     DATE,
    CreatedAt           DATETIME DEFAULT GETDATE(),
    UpdatedAt           DATETIME DEFAULT GETDATE()
);

-- Every individual problem attempt
-- Tied to both the problem and the session it happened in
CREATE TABLE PracticeLog (
    PracticeID          INT IDENTITY(1,1) PRIMARY KEY,
    ProblemID           INT NOT NULL FOREIGN KEY REFERENCES ProblemBank(ProblemID),
    SessionID           INT NOT NULL FOREIGN KEY REFERENCES ConversationLog(SessionID),
    SolvedIndependently BIT NOT NULL DEFAULT 0,
    TimeTakenMins       INT,
    Notes               NVARCHAR(500),
    CreatedAt           DATETIME DEFAULT GETDATE()
);

-- Bridge between sessions and concepts
-- Records full history of what was covered when and how deep
CREATE TABLE SessionConcept (
    SessionConceptID        INT IDENTITY(1,1) PRIMARY KEY,
    SessionID               INT NOT NULL FOREIGN KEY REFERENCES ConversationLog(SessionID),
    ConceptID               INT NOT NULL FOREIGN KEY REFERENCES Concept(ConceptID),
    DepthReached            TINYINT NOT NULL
                            CHECK (DepthReached BETWEEN 1 AND 5),
    InterviewReadinessAfter TINYINT NOT NULL
                            CHECK (InterviewReadinessAfter BETWEEN 1 AND 5),
    Notes                   NVARCHAR(500),
    CreatedAt               DATETIME DEFAULT GETDATE()
);
GO

-- =============================================
-- INDEXES
-- =============================================

CREATE INDEX IX_SubTopic_TopicID ON SubTopic(TopicID);
CREATE INDEX IX_Concept_SubTopicID ON Concept(SubTopicID);
CREATE INDEX IX_ConceptProgress_Status ON ConceptProgress(Status);
CREATE INDEX IX_ConceptProgress_RevisionDueDate ON ConceptProgress(RevisionDueDate);
CREATE INDEX IX_ProblemBank_ConceptID ON ProblemBank(ConceptID);
CREATE INDEX IX_PracticeLog_SessionID ON PracticeLog(SessionID);
CREATE INDEX IX_SessionConcept_SessionID ON SessionConcept(SessionID);
CREATE INDEX IX_SessionConcept_ConceptID ON SessionConcept(ConceptID);
GO

-- =============================================
-- VERIFY
-- =============================================

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO
