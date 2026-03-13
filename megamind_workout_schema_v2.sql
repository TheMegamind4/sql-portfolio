-- =============================================
-- MEGAMIND DATABASE — WORKOUT MODULE
-- Complete Schema for Q1 (Tendon) + Q2 (Neural)
-- CORRECTED ORDER: Tendon first, Neural second
-- Reason: Tendon foundation must be built before
--         neural/explosive loading to prevent injury
-- =============================================

USE Megamind;
GO

-- =============================================
-- REFERENCE TABLES (The definitions)
-- =============================================

-- Body regions that can accumulate fatigue
CREATE TABLE BodyRegion (
    RegionID        INT IDENTITY(1,1) PRIMARY KEY,
    RegionName      NVARCHAR(100) NOT NULL,
    RegionType      NVARCHAR(20)  NOT NULL,   -- 'Muscle', 'Tendon', 'CNS', 'Joint', 'Mobility'
    IsSystemic      BIT DEFAULT 0,            -- 1 = affects whole body (CNS), 0 = localized
    RecoveryHours   INT NOT NULL              -- baseline recovery window in hours
);

CREATE TABLE SetProtocol (
    ProtocolID      INT IDENTITY(1,1) PRIMARY KEY,
    ProtocolName    NVARCHAR(50) NOT NULL,    -- 'Normal', 'Cluster', 'Isometric', 'Eccentric', 'Drop', 'Mobility'
    Description     NVARCHAR(300)
);

CREATE TABLE ExerciseIntent (
    IntentID        INT IDENTITY(1,1) PRIMARY KEY,
    IntentName      NVARCHAR(50) NOT NULL,
    FatigueMultiplier DECIMAL(3,2) DEFAULT 1.00
);

CREATE TABLE MeasurementType (
    MeasurementTypeID   INT IDENTITY(1,1) PRIMARY KEY,
    TypeName            NVARCHAR(20) NOT NULL,  -- 'Reps', 'Time'
    Unit                NVARCHAR(20)
);

CREATE TABLE ProgressionRule (
    RuleID          INT IDENTITY(1,1) PRIMARY KEY,
    RuleName        NVARCHAR(100) NOT NULL,
    Description     NVARCHAR(500)
);

-- =============================================
-- EXERCISE LIBRARY
-- =============================================

CREATE TABLE Exercise (
    ExerciseID          INT IDENTITY(1,1) PRIMARY KEY,
    ExerciseName        NVARCHAR(200) NOT NULL,
    Purpose             NVARCHAR(300),
    IntentID            INT FOREIGN KEY REFERENCES ExerciseIntent(IntentID),
    MeasurementTypeID   INT FOREIGN KEY REFERENCES MeasurementType(MeasurementTypeID),
    ProtocolID          INT FOREIGN KEY REFERENCES SetProtocol(ProtocolID),
    ProgressionRuleID   INT FOREIGN KEY REFERENCES ProgressionRule(RuleID),
    IsUnilateral        BIT DEFAULT 0,
    HasGripVariation    BIT DEFAULT 0,
    Notes               NVARCHAR(500)
);

-- Many-to-many: Exercise affects multiple body regions
CREATE TABLE ExerciseBodyRegion (
    ExerciseID      INT FOREIGN KEY REFERENCES Exercise(ExerciseID),
    RegionID        INT FOREIGN KEY REFERENCES BodyRegion(RegionID),
    IsPrimary       BIT DEFAULT 1,
    PRIMARY KEY (ExerciseID, RegionID)
);

-- =============================================
-- PROGRAM STRUCTURE
-- =============================================

CREATE TABLE Quarter (
    QuarterID       INT IDENTITY(1,1) PRIMARY KEY,
    QuarterName     NVARCHAR(100) NOT NULL,
    Focus           NVARCHAR(200),
    CycleLengthDays INT NOT NULL,
    StartDate       DATE,
    EndDate         DATE
);

CREATE TABLE CycleDay (
    CycleDayID      INT IDENTITY(1,1) PRIMARY KEY,
    QuarterID       INT FOREIGN KEY REFERENCES Quarter(QuarterID),
    DayNumber       INT NOT NULL,
    DayName         NVARCHAR(100) NOT NULL,
    DayType         NVARCHAR(50)  NOT NULL,   -- 'Training', 'CNS Recovery', 'Full Rest', 'Optional Regen'
    IsRestDay       BIT DEFAULT 0
);

CREATE TABLE DayExercise (
    DayExerciseID   INT IDENTITY(1,1) PRIMARY KEY,
    CycleDayID      INT FOREIGN KEY REFERENCES CycleDay(CycleDayID),
    ExerciseID      INT FOREIGN KEY REFERENCES Exercise(ExerciseID),
    OrderLetter     NVARCHAR(5) NOT NULL,
    PrescribedSets  INT,
    PrescribedReps  INT,
    PrescribedSecs  INT,
    RepRangeMin     INT,
    RepRangeMax     INT,
    TimeRangeMin    INT,
    TimeRangeMax    INT,
    LoadKg          DECIMAL(6,2),
    LoadType        NVARCHAR(50),             -- 'Bodyweight', 'Backpack', 'Dumbbell', 'Goblet'
    RestSeconds     INT,
    RestSecMax      INT,
    GripSequence    NVARCHAR(200),
    IsClusterSet    BIT DEFAULT 0,
    ClusterReps     INT,
    ClusterRestSecs INT,
    Notes           NVARCHAR(500)
);

-- =============================================
-- WORKOUT LOGGING
-- =============================================

CREATE TABLE WorkoutSession (
    SessionID       INT IDENTITY(1,1) PRIMARY KEY,
    SessionDate     DATE NOT NULL,
    QuarterID       INT FOREIGN KEY REFERENCES Quarter(QuarterID),
    CycleDayID      INT FOREIGN KEY REFERENCES CycleDay(CycleDayID),
    CycleNumber     INT NOT NULL DEFAULT 1,   -- which run through the cycle (1st, 2nd, 3rd...)
    StartTime       TIME,
    EndTime         TIME,
    OverallFeeling  TINYINT CHECK (OverallFeeling BETWEEN 1 AND 5),
    Notes           NVARCHAR(500),
    CreatedAt       DATETIME DEFAULT GETDATE()
);

CREATE TABLE ExerciseEntry (
    EntryID         INT IDENTITY(1,1) PRIMARY KEY,
    SessionID       INT FOREIGN KEY REFERENCES WorkoutSession(SessionID),
    DayExerciseID   INT FOREIGN KEY REFERENCES DayExercise(DayExerciseID),
    OrderLetter     NVARCHAR(5),
    Skipped         BIT DEFAULT 0,
    SkipReason      NVARCHAR(200),
    Notes           NVARCHAR(300)
);

CREATE TABLE SetEntry (
    SetEntryID          INT IDENTITY(1,1) PRIMARY KEY,
    EntryID             INT FOREIGN KEY REFERENCES ExerciseEntry(EntryID),
    SetNumber           INT NOT NULL,
    GripUsed            NVARCHAR(50),
    LoadKgUsed          DECIMAL(6,2),
    RepsCompleted       INT,
    SecsCompleted       INT,
    Side                NVARCHAR(10),         -- 'Left', 'Right', 'Both'
    PerformanceRating   TINYINT CHECK (PerformanceRating BETWEEN 1 AND 4),
    -- 1 = Failed
    -- 2 = Completed but degraded (form broke / speed dropped)
    -- 3 = Completed as prescribed
    -- 4 = Completed clean — ready to progress
    SpeedMaintained     BIT,                  -- critical for Neural/Explosive exercises
    Notes               NVARCHAR(200)
);

-- For cluster sets only
CREATE TABLE ClusterRepEntry (
    ClusterRepID    INT IDENTITY(1,1) PRIMARY KEY,
    SetEntryID      INT FOREIGN KEY REFERENCES SetEntry(SetEntryID),
    ClusterNumber   INT NOT NULL,
    RepNumber       INT NOT NULL,
    Completed       BIT DEFAULT 1,
    Notes           NVARCHAR(200)
);

-- =============================================
-- FATIGUE TRACKING
-- =============================================

CREATE TABLE FatigueLog (
    FatigueID               INT IDENTITY(1,1) PRIMARY KEY,
    LogDate                 DATE NOT NULL,
    RegionID                INT FOREIGN KEY REFERENCES BodyRegion(RegionID),
    SessionID               INT FOREIGN KEY REFERENCES WorkoutSession(SessionID),
    FatigueScore            DECIMAL(4,2),     -- calculated 0.00 to 10.00
    EstimatedRecoveryDate   DATE,
    Notes                   NVARCHAR(300)
);

-- =============================================
-- PROGRESSION TRACKING
-- =============================================

CREATE TABLE ProgressionLog (
    ProgressionID   INT IDENTITY(1,1) PRIMARY KEY,
    ExerciseID      INT FOREIGN KEY REFERENCES Exercise(ExerciseID),
    SessionID       INT FOREIGN KEY REFERENCES WorkoutSession(SessionID),
    LogDate         DATE NOT NULL,
    PreviousLoad    DECIMAL(6,2),
    NewLoad         DECIMAL(6,2),
    PreviousReps    INT,
    NewReps         INT,
    PreviousSecs    INT,
    NewSecs         INT,
    ProgressionType NVARCHAR(100),
    TriggerRating   TINYINT,
    Notes           NVARCHAR(300)
);

GO

-- =============================================
-- REFERENCE DATA — Body Regions
-- =============================================

INSERT INTO BodyRegion (RegionName, RegionType, IsSystemic, RecoveryHours) VALUES
('CNS',                     'CNS',      1, 72),
('Lats',                    'Muscle',   0, 48),
('Biceps / Brachialis',     'Muscle',   0, 48),
('Rhomboids / Mid Traps',   'Muscle',   0, 48),
('Rear Deltoids',           'Muscle',   0, 48),
('Elbow Tendons',           'Tendon',   0, 96),
('Shoulder Tendons Pull',   'Tendon',   0, 96),
('Scapular Stabilizers',    'Tendon',   0, 72),
('Chest / Pectorals',       'Muscle',   0, 48),
('Triceps',                 'Muscle',   0, 48),
('Front Deltoids',          'Muscle',   0, 48),
('Serratus / Scapular',     'Muscle',   0, 48),
('Shoulder Tendons Push',   'Tendon',   0, 96),
('Wrist Tendons',           'Tendon',   0, 72),
('Quadriceps',              'Muscle',   0, 48),
('Hamstrings',              'Muscle',   0, 48),
('Glutes',                  'Muscle',   0, 48),
('Calves / Gastrocnemius',  'Muscle',   0, 48),
('Hip Flexors',             'Muscle',   0, 48),
('Adductors',               'Muscle',   0, 48),
('Tibialis Anterior',       'Muscle',   0, 24),
('Patellar Tendon',         'Tendon',   0, 96),
('Achilles Tendon',         'Tendon',   0, 96),
('Hip Tendons',             'Tendon',   0, 72),
('Core / Anterior Chain',   'Muscle',   0, 24),
('Spinal Extensors',        'Muscle',   0, 24);

INSERT INTO SetProtocol (ProtocolName, Description) VALUES
('Normal',      'Standard sets with full rest between'),
('Cluster',     'Intra-rep rest between individual reps within a set'),
('Isometric',   'Static hold for time'),
('Eccentric',   'Slow controlled lowering phase emphasis'),
('Drop Set',    'Reduce weight and continue reps'),
('Mobility',    'Passive or active stretch hold');

INSERT INTO ExerciseIntent (IntentName, FatigueMultiplier) VALUES
('Explosive',   1.80),
('Eccentric',   1.40),
('Isometric',   1.20),
('Strength',    1.30),
('Activation',  0.60),
('Mobility',    0.30);

INSERT INTO MeasurementType (TypeName, Unit) VALUES
('Reps',    'count'),
('Time',    'seconds');

INSERT INTO ProgressionRule (RuleName, Description) VALUES
('Add Weight Same Reps',    'Increase load when performance rating = 4 for 2 consecutive sessions'),
('Add Reps Same Weight',    'Increase reps when performance rating = 4 for 2 consecutive sessions'),
('Add Time Same Load',      'Increase hold duration when performance rating = 4'),
('Add Weight Same Time',    'Increase load on isometric holds when rating = 4'),
('Speed Must Maintain',     'Only increase load if speed/explosiveness is unchanged — neural rule'),
('Progress By Feel',        'Mobility — progress depth/duration when comfortable'),
('No Progression',          'Maintenance exercise — load stays fixed');

GO

-- =============================================
-- EXERCISE LIBRARY
-- Intent:      1=Explosive 2=Eccentric 3=Isometric 4=Strength 5=Activation 6=Mobility
-- Measurement: 1=Reps 2=Time
-- Protocol:    1=Normal 2=Cluster 3=Isometric 4=Eccentric 5=DropSet 6=Mobility
-- Progression: 1=AddWeightSameReps 2=AddRepsSameWeight 3=AddTimeSameLoad
--              4=AddWeightSameTime 5=SpeedMustMaintain 6=ProgressByFeel 7=NoProgression
-- =============================================

INSERT INTO Exercise (ExerciseName, Purpose, IntentID, MeasurementTypeID, ProtocolID, ProgressionRuleID, IsUnilateral, HasGripVariation, Notes) VALUES

-- PULL
('Cluster Explosive Pull-Ups',      'Max motor-unit recruitment and firing rate',          1, 1, 2, 5, 0, 1, 'Cluster (1+1+1) x 3. 15 sec intra-rep rest'),
('Weighted Explosive Pull-Ups',     'High-force neural output',                           1, 1, 1, 5, 0, 1, 'Progress only if speed unchanged'),
('Scapular Pull-Ups',               'Scapular activation and shoulder integrity',          5, 1, 1, 7, 0, 0, 'Controlled elevation/depression'),
('Chin Above Bar Isometric',        'Peak contraction neural control',                    3, 2, 3, 3, 0, 1, 'Wide pronated grip'),
('Passive Dead Hang',               'Joint decompression',                                6, 2, 6, 7, 0, 0, 'Passive — no activation'),
('Weighted Pull-Ups',               'Primary neural strength reinforcement',              4, 1, 1, 5, 0, 1, 'Grip rotates each set'),
('Explosive Pull-Ups',              'Velocity maintenance',                               1, 1, 1, 5, 0, 0, NULL),
('Inverted Rows',                   'Horizontal pulling balance',                         4, 1, 1, 2, 0, 0, 'Slow eccentric'),
('Top Position Hold',               'Mid-range control at ~90 degrees',                   3, 2, 3, 3, 0, 0, NULL),
('Slow Eccentric Pull-Ups',         'Elbow tendon remodeling through long eccentrics',    2, 1, 4, 1, 0, 1, '1 sec up / 5 sec descend / 1 sec pause'),
('Mid-Range Isometric Pull',        'Tendon stiffness at strongest pulling angle',        3, 2, 3, 4, 0, 1, 'At ~90 degrees. Hammer grip'),
('Active Hang',                     'Shoulder joint conditioning',                        5, 2, 3, 3, 0, 0, 'Active — scapulars engaged'),
('Controlled Weighted Pull-Ups',    'Force transmission through full pulling chain',      4, 1, 4, 1, 0, 0, '4 sec eccentric'),
('Top Position Hold Weighted',      'Upper-range strength stabilization',                 3, 2, 3, 4, 0, 0, 'With backpack load'),
('Slow Inverted Rows',              'Horizontal pulling balance with eccentric focus',    2, 1, 4, 2, 0, 0, '3 sec pull / 4 sec descend'),

-- PUSH
('Heavy Weighted Pushups',          'Max neural pressing strength',                       1, 1, 1, 5, 0, 1, 'Grip rotates Normal / Diamond'),
('Explosive Pushups',               'Velocity retention and neural firing',               1, 1, 1, 5, 0, 1, 'Grip rotates Normal / Slightly Wide'),
('Controlled Wide Pushups',         'Structural pressing control',                        4, 1, 1, 2, 0, 0, '1 sec up / 3 sec down'),
('Mid-Range Isometric Push',        'Sticking-point reinforcement at ~90 degrees',        3, 2, 3, 3, 0, 0, NULL),
('Top Support Hold',                'Lockout stability',                                  3, 2, 3, 3, 0, 0, 'Top of pushup position'),
('Explosive Pike Pushups',          'Vertical pressing power',                            1, 1, 1, 5, 0, 0, NULL),
('Weighted Slow Push-Ups',          'Anterior chain tendon loading',                      2, 1, 4, 1, 0, 0, '5 sec descend / 1 sec pause / explosive push'),
('Long-Length Bottom Hold',         'Shoulder tendon strengthening at deep range',        3, 2, 3, 4, 0, 0, '2-3 cm above ground'),
('Slow Pike Push-Ups',              'Vertical pressing structural strength',              2, 1, 4, 2, 0, 0, '4 sec descend'),
('Slow Deficit Push-Ups',           'Deep-range structural pressing strength',            2, 1, 4, 1, 0, 0, '5 sec descend'),
('Bottom Position Isometric',       'Elastic reversal strength',                          3, 2, 3, 3, 0, 0, '2-3 cm above ground'),

-- SCAPULAR / SHOULDER
('Wall Shoulder Slides',            'Scapular mechanics',                                 5, 1, 1, 7, 0, 0, '2 sec up / 2 sec down'),
('Scapular Stability Plank',        'Serratus and core linkage',                          3, 2, 3, 7, 0, 0, NULL),

-- LEGS
('Jump Squats',                     'Maximum rate of force development',                  1, 1, 1, 5, 0, 0, 'Full reset between reps'),
('Dumbbell Jump Squats',            'Loaded velocity stimulus',                           1, 1, 1, 5, 0, 0, NULL),
('Split Squat Jumps',               'Unilateral neural power',                            1, 1, 1, 5, 1, 0, 'Each leg tracked separately'),
('Deep Squat Isometric',            'Joint priming and tolerance development',            3, 2, 3, 4, 0, 0, 'Goblet hold'),
('ATG Split Squat Hold',            'Knee resilience at long muscle length',              3, 2, 3, 3, 1, 0, 'Each leg separately'),
('Dumbbell Squats',                 'Primary lower strength support',                     4, 1, 1, 1, 0, 0, '2 sec descend / explosive stand'),
('Bulgarian Split Squats',          'Unilateral strength',                                4, 1, 1, 1, 1, 0, 'Each leg separately'),
('Weighted Single-Leg Calf Raises', 'Achilles stiffness and tendon conditioning',         4, 1, 1, 1, 1, 0, '2 sec up / 2 sec pause / 2 sec down'),
('Mid-Range Squat Hold',            'Joint tolerance at ~90 degrees',                     3, 2, 3, 4, 0, 0, NULL),
('Single-Leg Hip Lock Hold',        'Pelvic stability',                                   3, 2, 3, 3, 1, 0, 'Each leg separately'),
('Deep Slow Goblet Squats',         'Patellar tendon and deep-range strength',            2, 1, 4, 1, 0, 0, '5 sec descend / 2 sec pause'),
('Step-Down Lunges',                'Unilateral knee stability and control',              4, 1, 1, 2, 1, 0, 'Each leg separately'),
('Slow Single-Leg Calf Raises',     'Achilles tendon conditioning',                       2, 1, 4, 1, 1, 0, '3 sec up / 5 sec down'),
('Single-Leg Romanian Deadlift',    'Posterior chain stability',                          4, 1, 1, 1, 1, 0, 'Offset load'),
('Tibialis Raises',                 'Anterior lower-leg strength',                        4, 1, 1, 2, 0, 0, NULL),
('Explosive Jump Squats',           'Neural maintenance for lower body',                  1, 1, 1, 5, 0, 0, 'Full reset'),
('Cossack Squats',                  'Lateral mobility and hip strength',                  4, 1, 1, 6, 1, 0, '2 sec descend each side'),

-- CORE
('Dead Bugs',                       'Core stiffness for force transfer',                  5, 1, 1, 2, 0, 0, '2 sec extend / 2 sec return'),
('Glute Bridge',                    'Posterior chain activation',                         5, 1, 1, 7, 0, 0, '2 sec up / 2 sec squeeze / 2 sec down'),
('Banded Lateral Walks',            'Glute med activation',                               5, 1, 1, 7, 1, 0, 'Each side'),

-- MOBILITY
('Elevated Pike Stretch',           'Posterior chain mobility',                           6, 2, 6, 6, 0, 0, NULL),
('Couch Stretch',                   'Hip flexor release',                                 6, 2, 6, 6, 1, 0, 'Each leg'),
('Front Split Progression',         'Hamstring mobility expansion',                       6, 2, 6, 6, 1, 0, 'Each leg'),
('Hip Flexor Lunge Stretch',        'Hip extension mobility',                             6, 2, 6, 6, 1, 0, 'Each leg'),
('Seated Straddle Stretch',         'Adductor flexibility',                               6, 2, 6, 6, 0, 0, NULL),
('Posterior Chain Tilt Drill',      'Hip hinge coordination',                             5, 1, 1, 7, 0, 0, 'Slow controlled'),
('Active Pike Stretch',             'Posterior chain mobility — active version',          6, 2, 6, 6, 0, 0, NULL),
('Cobra Extension Hold',            'Spinal balance',                                     6, 2, 6, 7, 0, 0, NULL),
('Active Cobra Hold',               'Spinal extension balance',                           6, 2, 6, 7, 0, 0, NULL),
('Bridge Hold',                     'Anterior chain opening',                             6, 2, 6, 6, 0, 0, NULL),
('Active Bridge Hold',              'Anterior chain mobility',                            6, 2, 6, 6, 0, 0, NULL),
('Wall Shoulder Flexion Stretch',   'Overhead mobility',                                  6, 2, 6, 6, 0, 0, NULL),
('Deep Squat Sit',                  'Full-range mobility',                                6, 2, 6, 6, 0, 0, NULL),
('Side Split Hold',                 'Adductor flexibility',                               6, 2, 6, 6, 0, 0, NULL),
('Standing Quad Stretch',           'Anterior chain release',                             6, 2, 6, 6, 1, 0, 'Each leg'),
('Straddle Stretch',                'Adductor flexibility',                               6, 2, 6, 6, 0, 0, NULL),
('Posterior Pelvic Tilt Practice',  'Pelvic control',                                     5, 2, 3, 7, 0, 0, NULL);

GO

-- =============================================
-- PROGRAM DATA
-- CORRECT ORDER: Q1 = Tendon, Q2 = Neural
-- =============================================

INSERT INTO Quarter (QuarterName, Focus, CycleLengthDays) VALUES
('Q1 - Tendon Conditioning',    'Tendon stiffness, slow eccentrics, long isometrics, connective tissue remodeling. Foundation phase — must complete before neural loading.', 8),
('Q2 - Neural Strength',        'Explosive power, motor unit recruitment, rate of force development, Type 2x activation. Built on tendon foundation from Q1.', 9),
('Q3 - Type 2x + Neural Mix',   'Maximum Type 2x recruitment with neural retention. Paired because training styles are similar.', 9),
('Q4 - Hypertrophy',            'CSA growth on top of the full foundation built in Q1-Q3.', 7);

-- =============================================
-- Q1 CYCLE DAYS — Tendon (8 day cycle)
-- =============================================

INSERT INTO CycleDay (QuarterID, DayNumber, DayName, DayType, IsRestDay) VALUES
(1, 1, 'Pull Structural',                   'Training',     0),
(1, 2, 'Push Structural',                   'Training',     0),
(1, 3, 'Leg Structural',                    'Training',     0),
(1, 4, 'Pull Strength and Transmission',    'Training',     0),
(1, 5, 'Push Stability',                    'Training',     0),
(1, 6, 'Leg Strength',                      'Training',     0),
(1, 7, 'Rest - Tendon Decompression',       'Full Rest',    1),
(1, 8, 'Full Rest - Deep Tendon Reset',     'Full Rest',    1);

-- =============================================
-- Q2 CYCLE DAYS — Neural (9 day cycle)
-- =============================================

INSERT INTO CycleDay (QuarterID, DayNumber, DayName, DayType, IsRestDay) VALUES
(2, 1, 'Pull Explosive',    'Training',         0),
(2, 2, 'Push Strength',     'Training',         0),
(2, 3, 'Leg Explosive',     'Training',         0),
(2, 4, 'CNS Recovery',      'CNS Recovery',     1),
(2, 5, 'Pull Strength',     'Training',         0),
(2, 6, 'Push Explosive',    'Training',         0),
(2, 7, 'Leg Strength',      'Training',         0),
(2, 8, 'Full CNS Reset',    'Full Rest',        1),
(2, 9, 'Optional Regen',    'Optional Regen',   1);

GO

-- =============================================
-- VERIFY
-- =============================================

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

SELECT q.QuarterName, cd.DayNumber, cd.DayName, cd.DayType
FROM Quarter q
JOIN CycleDay cd ON q.QuarterID = cd.QuarterID
ORDER BY q.QuarterID, cd.DayNumber;
