-- =============================================
-- MEGAMIND WORKOUT POPULATION
-- File: workout_population.sql
-- Run order: 4th — run after megamind_workout_schema.sql
-- =============================================
-- Populates:
--   Reference data  — BodyRegion, SetProtocol, ExerciseIntent,
--                     MeasurementType, ProgressionRule
--   Exercise data   — Exercise, ExerciseBodyRegion
--   Program data    — Quarter, CycleDay, DayExercise
-- =============================================

USE Megamind;
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
-- SECTION 1: ExerciseBodyRegion
-- Maps every exercise to the body regions it loads
-- IsPrimary: 1 = main target, 0 = secondary load
--
-- RegionID Reference:
-- 1  = CNS
-- 2  = Lats
-- 3  = Biceps / Brachialis
-- 4  = Rhomboids / Mid Traps
-- 5  = Rear Deltoids
-- 6  = Elbow Tendons
-- 7  = Shoulder Tendons Pull
-- 8  = Scapular Stabilizers
-- 9  = Chest / Pectorals
-- 10 = Triceps
-- 11 = Front Deltoids
-- 12 = Serratus / Scapular
-- 13 = Shoulder Tendons Push
-- 14 = Wrist Tendons
-- 15 = Quadriceps
-- 16 = Hamstrings
-- 17 = Glutes
-- 18 = Calves / Gastrocnemius
-- 19 = Hip Flexors
-- 20 = Adductors
-- 21 = Tibialis Anterior
-- 22 = Patellar Tendon
-- 23 = Achilles Tendon
-- 24 = Hip Tendons
-- 25 = Core / Anterior Chain
-- 26 = Spinal Extensors
-- =============================================

INSERT INTO ExerciseBodyRegion (ExerciseID, RegionID, IsPrimary) VALUES

-- 1. Cluster Explosive Pull-Ups
(1, 1, 1),   -- CNS (systemic — explosive)
(1, 2, 1),   -- Lats
(1, 3, 1),   -- Biceps / Brachialis
(1, 6, 1),   -- Elbow Tendons
(1, 7, 1),   -- Shoulder Tendons Pull
(1, 4, 0),   -- Rhomboids / Mid Traps
(1, 14, 0),  -- Wrist Tendons

-- 2. Weighted Explosive Pull-Ups
(2, 1, 1),   -- CNS
(2, 2, 1),   -- Lats
(2, 3, 1),   -- Biceps / Brachialis
(2, 6, 1),   -- Elbow Tendons
(2, 7, 1),   -- Shoulder Tendons Pull
(2, 4, 0),   -- Rhomboids / Mid Traps
(2, 14, 0),  -- Wrist Tendons

-- 3. Scapular Pull-Ups
(3, 8, 1),   -- Scapular Stabilizers
(3, 7, 1),   -- Shoulder Tendons Pull
(3, 2, 0),   -- Lats
(3, 12, 0),  -- Serratus / Scapular

-- 4. Chin Above Bar Isometric
(4, 2, 1),   -- Lats
(4, 3, 1),   -- Biceps / Brachialis
(4, 6, 1),   -- Elbow Tendons
(4, 1, 0),   -- CNS
(4, 14, 0),  -- Wrist Tendons

-- 5. Passive Dead Hang
(5, 7, 1),   -- Shoulder Tendons Pull
(5, 6, 1),   -- Elbow Tendons
(5, 8, 1),   -- Scapular Stabilizers
(5, 14, 0),  -- Wrist Tendons

-- 6. Weighted Pull-Ups
(6, 2, 1),   -- Lats
(6, 3, 1),   -- Biceps / Brachialis
(6, 6, 1),   -- Elbow Tendons
(6, 1, 1),   -- CNS
(6, 4, 0),   -- Rhomboids / Mid Traps
(6, 7, 0),   -- Shoulder Tendons Pull
(6, 14, 0),  -- Wrist Tendons

-- 7. Explosive Pull-Ups
(7, 1, 1),   -- CNS
(7, 2, 1),   -- Lats
(7, 3, 1),   -- Biceps / Brachialis
(7, 6, 0),   -- Elbow Tendons
(7, 7, 0),   -- Shoulder Tendons Pull

-- 8. Inverted Rows
(8, 4, 1),   -- Rhomboids / Mid Traps
(8, 5, 1),   -- Rear Deltoids
(8, 3, 1),   -- Biceps / Brachialis
(8, 6, 0),   -- Elbow Tendons
(8, 8, 0),   -- Scapular Stabilizers

-- 9. Top Position Hold
(9, 2, 1),   -- Lats
(9, 3, 1),   -- Biceps / Brachialis
(9, 6, 1),   -- Elbow Tendons
(9, 7, 0),   -- Shoulder Tendons Pull

-- 10. Slow Eccentric Pull-Ups
(10, 6, 1),  -- Elbow Tendons
(10, 2, 1),  -- Lats
(10, 3, 1),  -- Biceps / Brachialis
(10, 7, 1),  -- Shoulder Tendons Pull
(10, 4, 0),  -- Rhomboids / Mid Traps
(10, 14, 0), -- Wrist Tendons

-- 11. Mid-Range Isometric Pull
(11, 6, 1),  -- Elbow Tendons
(11, 2, 1),  -- Lats
(11, 3, 1),  -- Biceps / Brachialis
(11, 7, 0),  -- Shoulder Tendons Pull

-- 12. Active Hang
(12, 7, 1),  -- Shoulder Tendons Pull
(12, 8, 1),  -- Scapular Stabilizers
(12, 6, 0),  -- Elbow Tendons
(12, 12, 0), -- Serratus / Scapular

-- 13. Controlled Weighted Pull-Ups
(13, 2, 1),  -- Lats
(13, 3, 1),  -- Biceps / Brachialis
(13, 6, 1),  -- Elbow Tendons
(13, 7, 1),  -- Shoulder Tendons Pull
(13, 4, 0),  -- Rhomboids / Mid Traps
(13, 14, 0), -- Wrist Tendons

-- 14. Top Position Hold Weighted
(14, 2, 1),  -- Lats
(14, 3, 1),  -- Biceps / Brachialis
(14, 6, 1),  -- Elbow Tendons
(14, 7, 0),  -- Shoulder Tendons Pull
(14, 14, 0), -- Wrist Tendons

-- 15. Slow Inverted Rows
(15, 4, 1),  -- Rhomboids / Mid Traps
(15, 5, 1),  -- Rear Deltoids
(15, 3, 1),  -- Biceps / Brachialis
(15, 6, 0),  -- Elbow Tendons
(15, 8, 0),  -- Scapular Stabilizers

-- 16. Heavy Weighted Pushups
(16, 9, 1),  -- Chest / Pectorals
(16, 10, 1), -- Triceps
(16, 11, 1), -- Front Deltoids
(16, 1, 1),  -- CNS
(16, 13, 0), -- Shoulder Tendons Push
(16, 14, 0), -- Wrist Tendons

-- 17. Explosive Pushups
(17, 9, 1),  -- Chest / Pectorals
(17, 10, 1), -- Triceps
(17, 11, 1), -- Front Deltoids
(17, 1, 1),  -- CNS
(17, 13, 0), -- Shoulder Tendons Push

-- 18. Controlled Wide Pushups
(18, 9, 1),  -- Chest / Pectorals
(18, 13, 1), -- Shoulder Tendons Push
(18, 10, 0), -- Triceps
(18, 11, 0), -- Front Deltoids

-- 19. Mid-Range Isometric Push
(19, 9, 1),  -- Chest / Pectorals
(19, 13, 1), -- Shoulder Tendons Push
(19, 10, 0), -- Triceps
(19, 11, 0), -- Front Deltoids

-- 20. Top Support Hold
(20, 13, 1), -- Shoulder Tendons Push
(20, 10, 1), -- Triceps
(20, 14, 0), -- Wrist Tendons
(20, 25, 0), -- Core / Anterior Chain

-- 21. Explosive Pike Pushups
(21, 11, 1), -- Front Deltoids
(21, 10, 1), -- Triceps
(21, 1, 1),  -- CNS
(21, 13, 0), -- Shoulder Tendons Push

-- 22. Weighted Slow Push-Ups
(22, 9, 1),  -- Chest / Pectorals
(22, 13, 1), -- Shoulder Tendons Push
(22, 10, 0), -- Triceps
(22, 11, 0), -- Front Deltoids

-- 23. Long-Length Bottom Hold
(23, 13, 1), -- Shoulder Tendons Push
(23, 9, 1),  -- Chest / Pectorals
(23, 11, 0), -- Front Deltoids
(23, 14, 0), -- Wrist Tendons

-- 24. Slow Pike Push-Ups
(24, 11, 1), -- Front Deltoids
(24, 13, 1), -- Shoulder Tendons Push
(24, 10, 0), -- Triceps

-- 25. Slow Deficit Push-Ups
(25, 9, 1),  -- Chest / Pectorals
(25, 13, 1), -- Shoulder Tendons Push
(25, 10, 0), -- Triceps
(25, 11, 0), -- Front Deltoids

-- 26. Bottom Position Isometric
(26, 9, 1),  -- Chest / Pectorals
(26, 13, 1), -- Shoulder Tendons Push
(26, 11, 0), -- Front Deltoids

-- 27. Wall Shoulder Slides
(27, 8, 1),  -- Scapular Stabilizers
(27, 12, 1), -- Serratus / Scapular
(27, 13, 0), -- Shoulder Tendons Push

-- 28. Scapular Stability Plank
(28, 12, 1), -- Serratus / Scapular
(28, 8, 1),  -- Scapular Stabilizers
(28, 25, 1), -- Core / Anterior Chain
(28, 13, 0), -- Shoulder Tendons Push

-- 29. Jump Squats
(29, 1, 1),  -- CNS
(29, 15, 1), -- Quadriceps
(29, 17, 1), -- Glutes
(29, 22, 0), -- Patellar Tendon
(29, 23, 0), -- Achilles Tendon
(29, 16, 0), -- Hamstrings

-- 30. Dumbbell Jump Squats
(30, 1, 1),  -- CNS
(30, 15, 1), -- Quadriceps
(30, 17, 1), -- Glutes
(30, 22, 0), -- Patellar Tendon
(30, 23, 0), -- Achilles Tendon

-- 31. Split Squat Jumps
(31, 1, 1),  -- CNS
(31, 15, 1), -- Quadriceps
(31, 17, 1), -- Glutes
(31, 24, 1), -- Hip Tendons
(31, 22, 0), -- Patellar Tendon
(31, 19, 0), -- Hip Flexors

-- 32. Deep Squat Isometric
(32, 22, 1), -- Patellar Tendon
(32, 15, 1), -- Quadriceps
(32, 24, 1), -- Hip Tendons
(32, 17, 0), -- Glutes
(32, 20, 0), -- Adductors

-- 33. ATG Split Squat Hold
(33, 22, 1), -- Patellar Tendon
(33, 15, 1), -- Quadriceps
(33, 24, 1), -- Hip Tendons
(33, 19, 0), -- Hip Flexors
(33, 16, 0), -- Hamstrings

-- 34. Dumbbell Squats
(34, 15, 1), -- Quadriceps
(34, 17, 1), -- Glutes
(34, 22, 1), -- Patellar Tendon
(34, 16, 0), -- Hamstrings
(34, 25, 0), -- Core / Anterior Chain

-- 35. Bulgarian Split Squats
(35, 15, 1), -- Quadriceps
(35, 17, 1), -- Glutes
(35, 19, 1), -- Hip Flexors
(35, 22, 0), -- Patellar Tendon
(35, 24, 0), -- Hip Tendons
(35, 16, 0), -- Hamstrings

-- 36. Weighted Single-Leg Calf Raises
(36, 23, 1), -- Achilles Tendon
(36, 18, 1), -- Calves / Gastrocnemius
(36, 22, 0), -- Patellar Tendon

-- 37. Mid-Range Squat Hold
(37, 22, 1), -- Patellar Tendon
(37, 15, 1), -- Quadriceps
(37, 24, 0), -- Hip Tendons
(37, 17, 0), -- Glutes

-- 38. Single-Leg Hip Lock Hold
(38, 24, 1), -- Hip Tendons
(38, 17, 1), -- Glutes
(38, 19, 0), -- Hip Flexors
(38, 25, 0), -- Core / Anterior Chain

-- 39. Deep Slow Goblet Squats
(39, 22, 1), -- Patellar Tendon
(39, 15, 1), -- Quadriceps
(39, 24, 1), -- Hip Tendons
(39, 17, 0), -- Glutes
(39, 20, 0), -- Adductors

-- 40. Step-Down Lunges
(40, 15, 1), -- Quadriceps
(40, 22, 1), -- Patellar Tendon
(40, 17, 0), -- Glutes
(40, 16, 0), -- Hamstrings
(40, 24, 0), -- Hip Tendons

-- 41. Slow Single-Leg Calf Raises
(41, 23, 1), -- Achilles Tendon
(41, 18, 1), -- Calves / Gastrocnemius
(41, 22, 0), -- Patellar Tendon

-- 42. Single-Leg Romanian Deadlift
(42, 16, 1), -- Hamstrings
(42, 17, 1), -- Glutes
(42, 24, 1), -- Hip Tendons
(42, 26, 0), -- Spinal Extensors
(42, 25, 0), -- Core / Anterior Chain

-- 43. Tibialis Raises
(43, 21, 1), -- Tibialis Anterior

-- 44. Explosive Jump Squats
(44, 1, 1),  -- CNS
(44, 15, 1), -- Quadriceps
(44, 17, 1), -- Glutes
(44, 22, 0), -- Patellar Tendon
(44, 23, 0), -- Achilles Tendon

-- 45. Cossack Squats
(45, 20, 1), -- Adductors
(45, 15, 1), -- Quadriceps
(45, 24, 1), -- Hip Tendons
(45, 17, 0), -- Glutes

-- 46. Dead Bugs
(46, 25, 1), -- Core / Anterior Chain
(46, 19, 0), -- Hip Flexors
(46, 26, 0), -- Spinal Extensors

-- 47. Glute Bridge
(47, 17, 1), -- Glutes
(47, 16, 0), -- Hamstrings
(47, 26, 0), -- Spinal Extensors

-- 48. Banded Lateral Walks
(48, 17, 1), -- Glutes
(48, 20, 1), -- Adductors
(48, 24, 0), -- Hip Tendons

-- 49. Elevated Pike Stretch
(49, 16, 1), -- Hamstrings
(49, 23, 0), -- Achilles Tendon
(49, 26, 0), -- Spinal Extensors

-- 50. Couch Stretch
(50, 19, 1), -- Hip Flexors
(50, 15, 0), -- Quadriceps
(50, 24, 0), -- Hip Tendons

-- 51. Front Split Progression
(51, 16, 1), -- Hamstrings
(51, 19, 1), -- Hip Flexors
(51, 24, 0), -- Hip Tendons

-- 52. Hip Flexor Lunge Stretch
(52, 19, 1), -- Hip Flexors
(52, 24, 1), -- Hip Tendons
(52, 15, 0), -- Quadriceps

-- 53. Seated Straddle Stretch
(53, 20, 1), -- Adductors
(53, 16, 0), -- Hamstrings

-- 54. Posterior Chain Tilt Drill
(54, 26, 1), -- Spinal Extensors
(54, 17, 0), -- Glutes
(54, 16, 0), -- Hamstrings

-- 55. Active Pike Stretch
(55, 16, 1), -- Hamstrings
(55, 23, 0), -- Achilles Tendon
(55, 26, 0), -- Spinal Extensors

-- 56. Cobra Extension Hold
(56, 26, 1), -- Spinal Extensors
(56, 25, 0), -- Core / Anterior Chain

-- 57. Active Cobra Hold
(57, 26, 1), -- Spinal Extensors
(57, 25, 0), -- Core / Anterior Chain

-- 58. Bridge Hold
(58, 25, 1), -- Core / Anterior Chain
(58, 19, 1), -- Hip Flexors
(58, 26, 0), -- Spinal Extensors

-- 59. Active Bridge Hold
(59, 25, 1), -- Core / Anterior Chain
(59, 19, 1), -- Hip Flexors
(59, 13, 0), -- Shoulder Tendons Push

-- 60. Wall Shoulder Flexion Stretch
(60, 13, 1), -- Shoulder Tendons Push
(60, 7, 0),  -- Shoulder Tendons Pull
(60, 8, 0),  -- Scapular Stabilizers

-- 61. Deep Squat Sit
(61, 20, 1), -- Adductors
(61, 24, 1), -- Hip Tendons
(61, 15, 0), -- Quadriceps
(61, 22, 0), -- Patellar Tendon

-- 62. Side Split Hold
(62, 20, 1), -- Adductors
(62, 24, 0), -- Hip Tendons
(62, 16, 0), -- Hamstrings

-- 63. Standing Quad Stretch
(63, 15, 1), -- Quadriceps
(63, 19, 0), -- Hip Flexors
(63, 22, 0), -- Patellar Tendon

-- 64. Straddle Stretch
(64, 20, 1), -- Adductors
(64, 16, 0), -- Hamstrings

-- 65. Posterior Pelvic Tilt Practice
(65, 25, 1), -- Core / Anterior Chain
(65, 17, 0), -- Glutes
(65, 26, 0); -- Spinal Extensors

GO

-- =============================================
-- SECTION 2: DayExercise
-- Full prescription for every exercise
-- on every training day in Q1 and Q2
--
-- CycleDayID Reference:
-- Q1: 1=Pull Structural, 2=Push Structural, 3=Leg Structural
--     4=Pull Strength & Transmission, 5=Push Stability, 6=Leg Strength
-- Q2: 9=Pull Explosive, 10=Push Strength, 11=Leg Explosive
--     13=Pull Strength, 14=Push Explosive, 15=Leg Strength
--
-- LoadType: 'Bodyweight', 'Backpack', 'Dumbbell', 'Goblet'
-- =============================================

-- =============================================
-- Q1 DAY 1 — PULL STRUCTURAL (CycleDayID = 1)
-- =============================================
INSERT INTO DayExercise (CycleDayID, ExerciseID, OrderLetter, PrescribedSets, PrescribedReps, RepRangeMin, RepRangeMax, PrescribedSecs, TimeRangeMin, TimeRangeMax, LoadKg, LoadType, RestSeconds, RestSecMax, GripSequence, IsClusterSet, ClusterReps, ClusterRestSecs, Notes) VALUES
(1, 7,  'A', 4, 2,  NULL, NULL, NULL, NULL, NULL, NULL, 'Bodyweight', 120, 180, 'Hammer → Pronated → Hammer → Pronated', 0, NULL, NULL, 'Explosive pull / controlled descend'),
(1, 10, 'B', 4, 4,  NULL, NULL, NULL, NULL, NULL, 5,    'Backpack',   180, NULL, 'Chin',                                  0, NULL, NULL, '1 sec up / 5 sec descend / 1 sec pause'),
(1, 11, 'C', 3, NULL, NULL, NULL, NULL, 25,   25,   NULL, 'Bodyweight', 120, NULL, 'Hammer',                                0, NULL, NULL, 'Add +5 kg later if easy'),
(1, 3,  'D', 3, 8,  NULL, NULL, NULL, NULL, NULL, NULL, 'Bodyweight',  90, NULL, NULL,                                    0, NULL, NULL, '3 sec elevate / 3 sec depress'),
(1, 12, 'E', 2, NULL, NULL, NULL, NULL, 40,   50,   NULL, 'Bodyweight',  60,  90, NULL,                                    0, NULL, NULL, 'Active — scapulars engaged'),
(1, 55, 'F', 2, NULL, NULL, NULL, NULL, 45,   60,   NULL, 'Bodyweight',  60,  90, NULL,                                    0, NULL, NULL, 'Posterior chain mobility');

-- =============================================
-- Q1 DAY 2 — PUSH STRUCTURAL (CycleDayID = 2)
-- =============================================
INSERT INTO DayExercise (CycleDayID, ExerciseID, OrderLetter, PrescribedSets, PrescribedReps, RepRangeMin, RepRangeMax, PrescribedSecs, TimeRangeMin, TimeRangeMax, LoadKg, LoadType, RestSeconds, RestSecMax, GripSequence, IsClusterSet, ClusterReps, ClusterRestSecs, Notes) VALUES
(2, 17, 'A', 3, 3,  NULL, NULL, NULL, NULL, NULL, NULL, 'Bodyweight', 120, NULL, NULL,   0, NULL, NULL, 'Fast up / controlled descend'),
(2, 22, 'B', 4, 5,  NULL, NULL, NULL, NULL, NULL, 12.5, 'Backpack',   150, 180,  NULL,   0, NULL, NULL, '5 sec descend / 1 sec pause / explosive push. Load range 10-15 kg'),
(2, 23, 'C', 3, NULL, NULL, NULL, NULL, 25,   30,   12.5, 'Backpack',  120, NULL, NULL,  0, NULL, NULL, 'Load range 10-15 kg'),
(2, 24, 'D', 3, 5,  NULL, NULL, NULL, NULL, NULL, NULL, 'Bodyweight', 120, NULL, NULL,   0, NULL, NULL, '4 sec descend'),
(2, 20, 'E', 3, NULL, NULL, NULL, NULL, 25,   30,   NULL, 'Bodyweight',  90, NULL, NULL, 0, NULL, NULL, 'Lockout stability'),
(2, 27, 'F', 3, 10, NULL, NULL, NULL, NULL, NULL, NULL, 'Bodyweight',  45, NULL, NULL,   0, NULL, NULL, '2 sec up / 2 sec down'),
(2, 57, 'G', 2, NULL, NULL, NULL, NULL, 30,   30,   NULL, 'Bodyweight',  45, NULL, NULL, 0, NULL, NULL, 'Spinal extension balance');

-- =============================================
-- Q1 DAY 3 — LEG STRUCTURAL (CycleDayID = 3)
-- =============================================
INSERT INTO DayExercise (CycleDayID, ExerciseID, OrderLetter, PrescribedSets, PrescribedReps, RepRangeMin, RepRangeMax, PrescribedSecs, TimeRangeMin, TimeRangeMax, LoadKg, LoadType, RestSeconds, RestSecMax, GripSequence, IsClusterSet, ClusterReps, ClusterRestSecs, Notes) VALUES
(3, 44, 'A', 3, 3,  NULL, NULL, NULL, NULL, NULL, NULL, 'Bodyweight', 180, NULL, NULL, 0, NULL, NULL, 'Explosive jump | Full reset'),
(3, 39, 'B', 4, 5,  NULL, NULL, NULL, NULL, NULL, 20,   'Goblet',     180, NULL, NULL, 0, NULL, NULL, '5 sec descend / 2 sec pause / controlled stand'),
(3, 40, 'C', 3, 6,  NULL, NULL, NULL, NULL, NULL, 10,   'Dumbbell',   120, NULL, NULL, 0, NULL, NULL, 'Each leg. 10 kg each hand'),
(3, 32, 'D', 3, NULL, NULL, NULL, NULL, 25,   25,   10,   'Goblet',    120, NULL, NULL, 0, NULL, NULL, 'Joint tolerance development'),
(3, 41, 'E', 3, 8,  NULL, NULL, NULL, NULL, NULL, 10,   'Dumbbell',    90, NULL, NULL, 0, NULL, NULL, 'Each leg. 3 sec up / 5 sec down. 10 kg each hand'),
(3, 33, 'F', 2, NULL, NULL, NULL, NULL, 40,   40,   NULL, 'Bodyweight',  90, NULL, NULL, 0, NULL, NULL, 'Each leg'),
(3, 51, 'G', 2, NULL, NULL, NULL, NULL, 60,   60,   NULL, 'Bodyweight',  90, NULL, NULL, 0, NULL, NULL, 'Each leg');

-- =============================================
-- Q1 DAY 4 — PULL STRENGTH & TRANSMISSION (CycleDayID = 4)
-- =============================================
INSERT INTO DayExercise (CycleDayID, ExerciseID, OrderLetter, PrescribedSets, PrescribedReps, RepRangeMin, RepRangeMax, PrescribedSecs, TimeRangeMin, TimeRangeMax, LoadKg, LoadType, RestSeconds, RestSecMax, GripSequence, IsClusterSet, ClusterReps, ClusterRestSecs, Notes) VALUES
(4, 13, 'A', 4, 3,  NULL, NULL, NULL, NULL, NULL, 7.5,  'Backpack',   180, NULL, NULL, 0, NULL, NULL, 'Explosive pull / 4 sec descend. Load range 5-10 kg'),
(4, 14, 'B', 3, NULL, NULL, NULL, NULL, 20,   25,   5,    'Backpack',   120, NULL, NULL, 0, NULL, NULL, 'Upper-range strength stabilization'),
(4, 15, 'C', 4, 6,  NULL, NULL, NULL, NULL, NULL, NULL, 'Bodyweight',  90, NULL, NULL, 0, NULL, NULL, '3 sec pull / 4 sec descend'),
(4, 12, 'D', 2, NULL, NULL, NULL, NULL, 30,   40,   NULL, 'Bodyweight',  90, NULL, NULL, 0, NULL, NULL, 'Shoulder conditioning'),
(4, 45, 'E', 3, 5,  NULL, NULL, NULL, NULL, NULL, NULL, 'Bodyweight',  60, NULL, NULL, 0, NULL, NULL, 'Each side'),
(4, 64, 'F', 2, NULL, NULL, NULL, NULL, 60,   60,   NULL, 'Bodyweight',  60, NULL, NULL, 0, NULL, NULL, 'Adductor flexibility');

-- =============================================
-- Q1 DAY 5 — PUSH STABILITY (CycleDayID = 5)
-- =============================================
INSERT INTO DayExercise (CycleDayID, ExerciseID, OrderLetter, PrescribedSets, PrescribedReps, RepRangeMin, RepRangeMax, PrescribedSecs, TimeRangeMin, TimeRangeMax, LoadKg, LoadType, RestSeconds, RestSecMax, GripSequence, IsClusterSet, ClusterReps, ClusterRestSecs, Notes) VALUES
(5, 17, 'A', 3, 3,  NULL, NULL, NULL, NULL, NULL, NULL, 'Bodyweight', 120, NULL, NULL, 0, NULL, NULL, 'Maximum speed up / controlled descend'),
(5, 25, 'B', 3, 6,  NULL, NULL, NULL, NULL, NULL, 10,   'Backpack',   180, NULL, NULL, 0, NULL, NULL, '5 sec descend'),
(5, 19, 'C', 3, NULL, NULL, NULL, NULL, 25,   25,   NULL, 'Bodyweight', 120, NULL, NULL, 0, NULL, NULL, 'Joint stability reinforcement'),
(5, 24, 'D', 2, 6,  NULL, NULL, NULL, NULL, NULL, NULL, 'Bodyweight', 120, NULL, NULL, 0, NULL, NULL, 'Shoulder structural strength'),
(5, 28, 'E', 3, NULL, NULL, NULL, NULL, 30,   30,   NULL, 'Bodyweight', 120, NULL, NULL, 0, NULL, NULL, 'Serratus and core linkage'),
(5, 59, 'F', 2, NULL, NULL, NULL, NULL, 25,   30,   NULL, 'Bodyweight',  60, NULL, NULL, 0, NULL, NULL, 'Anterior chain mobility'),
(5, 60, 'G', 2, NULL, NULL, NULL, NULL, 40,   40,   NULL, 'Bodyweight',  60, NULL, NULL, 0, NULL, NULL, 'Overhead mobility');

-- =============================================
-- Q1 DAY 6 — LEG STRENGTH (CycleDayID = 6)
-- =============================================
INSERT INTO DayExercise (CycleDayID, ExerciseID, OrderLetter, PrescribedSets, PrescribedReps, RepRangeMin, RepRangeMax, PrescribedSecs, TimeRangeMin, TimeRangeMax, LoadKg, LoadType, RestSeconds, RestSecMax, GripSequence, IsClusterSet, ClusterReps, ClusterRestSecs, Notes) VALUES
(6, 35, 'A', 4, 5,  NULL, NULL, NULL, NULL, NULL, 10,   'Dumbbell',   120, NULL, NULL, 0, NULL, NULL, 'Each leg. 4 sec descend / controlled stand. 10 kg each hand'),
(6, 42, 'B', 3, 6,  NULL, NULL, NULL, NULL, NULL, 20,   'Dumbbell',   120, NULL, NULL, 0, NULL, NULL, 'Each leg. 20 kg offset hold both DBs same side'),
(6, 37, 'C', 3, NULL, NULL, NULL, NULL, 20,   25,   20,   'Goblet',    120, NULL, NULL, 0, NULL, NULL, 'Joint tolerance under load'),
(6, 38, 'D', 3, NULL, NULL, NULL, NULL, 20,   20,   NULL, 'Bodyweight', 120, NULL, NULL, 0, NULL, NULL, 'Each leg. Pelvic stability'),
(6, 43, 'E', 3, 12, NULL, NULL, NULL, NULL, NULL, NULL, 'Bodyweight',  60, NULL, NULL, 0, NULL, NULL, 'Anterior lower-leg strength'),
(6, 61, 'F', 2, NULL, NULL, NULL, NULL, 60,   60,   NULL, 'Bodyweight',  60, NULL, NULL, 0, NULL, NULL, 'Full-range mobility'),
(6, 62, 'G', 2, NULL, NULL, NULL, NULL, 60,   60,   NULL, 'Bodyweight',  60, NULL, NULL, 0, NULL, NULL, 'Adductor flexibility');

-- =============================================
-- Q2 DAY 1 — PULL EXPLOSIVE (CycleDayID = 9)
-- =============================================
INSERT INTO DayExercise (CycleDayID, ExerciseID, OrderLetter, PrescribedSets, PrescribedReps, RepRangeMin, RepRangeMax, PrescribedSecs, TimeRangeMin, TimeRangeMax, LoadKg, LoadType, RestSeconds, RestSecMax, GripSequence, IsClusterSet, ClusterReps, ClusterRestSecs, Notes) VALUES
(9, 1,  'A', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Bodyweight', 180, 240, 'Hammer → Wide Pronated → Hammer', 1, 3, 15, 'Cluster (1+1+1) x 3. 15 sec intra-rep rest'),
(9, 2,  'B', 3, 2,   NULL, NULL, NULL, NULL, NULL, 5,    'Backpack',   180, NULL, 'Chin',                            0, NULL, NULL, 'Explosive up / 2 sec descend. Max +10 kg only if speed unchanged'),
(9, 3,  'C', 2, 5,   NULL, NULL, NULL, NULL, NULL, NULL, 'Bodyweight',  90, NULL, NULL,                              0, NULL, NULL, 'Controlled elevation/depression'),
(9, 4,  'D', 3, NULL, NULL, NULL, NULL, 8,    8,    NULL, 'Bodyweight', 120, NULL, 'Wide Pronated',                   0, NULL, NULL, 'Peak contraction neural control'),
(9, 5,  'E', 2, NULL, NULL, NULL, NULL, 30,   40,   NULL, 'Bodyweight', 120, NULL, NULL,                              0, NULL, NULL, 'Joint decompression — passive'),
(9, 49, 'F', 2, NULL, NULL, NULL, NULL, 25,   30,   NULL, 'Bodyweight',  45,  60, NULL,                              0, NULL, NULL, 'Posterior chain mobility'),
(9, 50, 'G', 1, NULL, NULL, NULL, NULL, 30,   30,   NULL, 'Bodyweight',  45,  60, NULL,                              0, NULL, NULL, 'Each leg. Hip flexor release'),
(9, 46, 'H', 2, 8,   NULL, NULL, NULL, NULL, NULL, NULL, 'Bodyweight',  45,  60, NULL,                              0, NULL, NULL, '2 sec extend / 2 sec return');

-- =============================================
-- Q2 DAY 2 — PUSH STRENGTH (CycleDayID = 10)
-- =============================================
INSERT INTO DayExercise (CycleDayID, ExerciseID, OrderLetter, PrescribedSets, PrescribedReps, RepRangeMin, RepRangeMax, PrescribedSecs, TimeRangeMin, TimeRangeMax, LoadKg, LoadType, RestSeconds, RestSecMax, GripSequence, IsClusterSet, ClusterReps, ClusterRestSecs, Notes) VALUES
(10, 16, 'A', 4, 2,  NULL, NULL, NULL, NULL, NULL, 12.5, 'Backpack',  180, NULL, 'Normal ↔ Diamond rotation',  0, NULL, NULL, 'Explosive push / 2 sec descend. Load range 10-15 kg'),
(10, 17, 'B', 3, 3,  NULL, NULL, NULL, NULL, NULL, NULL, 'Bodyweight', 120, NULL, 'Normal',                     0, NULL, NULL, 'Fast up / 1 sec down'),
(10, 18, 'C', 2, 4,  NULL, NULL, NULL, NULL, NULL, NULL, 'Bodyweight', 120, NULL, 'Wide',                       0, NULL, NULL, '1 sec up / 3 sec down'),
(10, 19, 'D', 2, NULL, NULL, NULL, NULL, 8,   8,    NULL, 'Bodyweight',  60, NULL, NULL,                        0, NULL, NULL, 'Sticking-point reinforcement at ~90 degrees'),
(10, 20, 'E', 2, NULL, NULL, NULL, NULL, 15,  15,   NULL, 'Bodyweight',  60, NULL, NULL,                        0, NULL, NULL, 'Lockout stability'),
(10, 27, 'F', 3, 10, NULL, NULL, NULL, NULL, NULL, NULL, 'Bodyweight',  60, NULL, NULL,                        0, NULL, NULL, '2 sec up / 2 sec down'),
(10, 56, 'G', 3, NULL, NULL, NULL, NULL, 20,  20,   NULL, 'Bodyweight',  60, NULL, NULL,                        0, NULL, NULL, 'Spinal balance'),
(10, 47, 'H', 2, 10, NULL, NULL, NULL, NULL, NULL, NULL, 'Bodyweight',  60, NULL, NULL,                        0, NULL, NULL, '2 sec up / 2 sec squeeze / 2 sec down'),
(10, 65, 'I', 2, NULL, NULL, NULL, NULL, 10,  10,   NULL, 'Bodyweight',  60, NULL, NULL,                        0, NULL, NULL, 'Pelvic control');

-- =============================================
-- Q2 DAY 3 — LEG EXPLOSIVE (CycleDayID = 11)
-- =============================================
INSERT INTO DayExercise (CycleDayID, ExerciseID, OrderLetter, PrescribedSets, PrescribedReps, RepRangeMin, RepRangeMax, PrescribedSecs, TimeRangeMin, TimeRangeMax, LoadKg, LoadType, RestSeconds, RestSecMax, GripSequence, IsClusterSet, ClusterReps, ClusterRestSecs, Notes) VALUES
(11, 29, 'A', 5, 2,  NULL, NULL, NULL, NULL, NULL, NULL, 'Bodyweight', 180, 240, NULL, 0, NULL, NULL, 'Explosive jump | Full reset'),
(11, 30, 'B', 3, NULL, 2,   3,   NULL, NULL, NULL, 5,    'Dumbbell',   180, NULL, NULL, 0, NULL, NULL, 'Explosive jump / soft landing. 5 kg DB total'),
(11, 31, 'C', 3, 2,  NULL, NULL, NULL, NULL, NULL, NULL, 'Bodyweight', 180, NULL, NULL, 0, NULL, NULL, 'Each leg. Explosive switch / controlled landing'),
(11, 32, 'D', 3, NULL, NULL, NULL, NULL, 6,   8,    10,   'Goblet',    120, NULL, NULL, 0, NULL, NULL, 'Joint priming'),
(11, 33, 'E', 2, NULL, NULL, NULL, NULL, 25,  30,   NULL, 'Bodyweight',  60, NULL, NULL, 0, NULL, NULL, 'Each leg. Knee resilience'),
(11, 51, 'F', 2, NULL, NULL, NULL, NULL, 30,  35,   NULL, 'Bodyweight',  60, NULL, NULL, 0, NULL, NULL, 'Each leg. Hamstring mobility'),
(11, 52, 'G', 1, NULL, NULL, NULL, NULL, 30,  30,   NULL, 'Bodyweight',  60, NULL, NULL, 0, NULL, NULL, 'Each leg. Hip extension');

-- =============================================
-- Q2 DAY 5 — PULL STRENGTH (CycleDayID = 13)
-- =============================================
INSERT INTO DayExercise (CycleDayID, ExerciseID, OrderLetter, PrescribedSets, PrescribedReps, RepRangeMin, RepRangeMax, PrescribedSecs, TimeRangeMin, TimeRangeMax, LoadKg, LoadType, RestSeconds, RestSecMax, GripSequence, IsClusterSet, ClusterReps, ClusterRestSecs, Notes) VALUES
(13, 6,  'A', 4, 2,  NULL, NULL, NULL, NULL, NULL, 5,    'Backpack',  180, NULL, 'Chin ↔ Neutral ↔ Hammer ↔ Chin', 0, NULL, NULL, 'Explosive up / 2 sec descend. Max +10 kg'),
(13, 7,  'B', 3, 2,  NULL, NULL, NULL, NULL, NULL, NULL, 'Bodyweight', 120, NULL, NULL,                              0, NULL, NULL, 'Max explosive pull / controlled descend'),
(13, 8,  'C', 3, 5,  NULL, NULL, NULL, NULL, NULL, NULL, 'Bodyweight',  90, NULL, NULL,                              0, NULL, NULL, '2 sec pull / 2 sec descend'),
(13, 9,  'D', 2, NULL, NULL, NULL, NULL, 8,   8,    NULL, 'Bodyweight',  60, NULL, NULL,                              0, NULL, NULL, 'Mid-range control at ~90 degrees'),
(13, 45, 'E', 3, 5,  NULL, NULL, NULL, NULL, NULL, NULL, 'Bodyweight',  60, 120,  NULL,                              0, NULL, NULL, 'Each side. 2 sec descend'),
(13, 53, 'F', 2, NULL, NULL, NULL, NULL, 45,  45,   NULL, 'Bodyweight',  60, NULL, NULL,                              0, NULL, NULL, 'Adductor flexibility'),
(13, 54, 'G', 1, 10, NULL, NULL, NULL, NULL, NULL, NULL, 'Bodyweight',  45,  60, NULL,                              0, NULL, NULL, 'Slow controlled hinge');

-- =============================================
-- Q2 DAY 6 — PUSH EXPLOSIVE (CycleDayID = 14)
-- =============================================
INSERT INTO DayExercise (CycleDayID, ExerciseID, OrderLetter, PrescribedSets, PrescribedReps, RepRangeMin, RepRangeMax, PrescribedSecs, TimeRangeMin, TimeRangeMax, LoadKg, LoadType, RestSeconds, RestSecMax, GripSequence, IsClusterSet, ClusterReps, ClusterRestSecs, Notes) VALUES
(14, 17, 'A', 4, 3,  NULL, NULL, NULL, NULL, NULL, NULL, 'Bodyweight', 120, 180, 'Normal ↔ Slightly Wide', 0, NULL, NULL, 'Maximum speed up / controlled descend'),
(14, 16, 'B', 3, 2,  NULL, NULL, NULL, NULL, NULL, 7.5,  'Backpack',   180, NULL, NULL,                    0, NULL, NULL, 'Explosive push / ~2 sec descend. Load range 5-10 kg'),
(14, 26, 'C', 3, NULL, NULL, NULL, NULL, 8,   8,    NULL, 'Bodyweight', 60,  120, NULL,                    0, NULL, NULL, '2-3 cm above ground'),
(14, 21, 'D', 3, NULL, 2,   3,   NULL, NULL, NULL, NULL, 'Bodyweight', 120, NULL, NULL,                    0, NULL, NULL, 'Explosive press / controlled descend'),
(14, 58, 'E', 3, NULL, NULL, NULL, NULL, 20,  20,   NULL, 'Bodyweight',  60, NULL, NULL,                    0, NULL, NULL, 'Anterior chain opening'),
(14, 60, 'F', 2, NULL, NULL, NULL, NULL, 30,  30,   NULL, 'Bodyweight',  60, NULL, NULL,                    0, NULL, NULL, 'Overhead mobility'),
(14, 48, 'G', 2, 12, NULL, NULL, NULL, NULL, NULL, NULL, 'Bodyweight',  45,  60, NULL,                    0, NULL, NULL, 'Each side. Controlled steps');

-- =============================================
-- Q2 DAY 7 — LEG STRENGTH (CycleDayID = 15)
-- =============================================
INSERT INTO DayExercise (CycleDayID, ExerciseID, OrderLetter, PrescribedSets, PrescribedReps, RepRangeMin, RepRangeMax, PrescribedSecs, TimeRangeMin, TimeRangeMax, LoadKg, LoadType, RestSeconds, RestSecMax, GripSequence, IsClusterSet, ClusterReps, ClusterRestSecs, Notes) VALUES
(15, 34, 'A', 5, 3,  NULL, NULL, NULL, NULL, NULL, 20,   'Dumbbell',  180, NULL, NULL, 0, NULL, NULL, 'Explosive stand / 2 sec descend. 10 kg each hand'),
(15, 35, 'B', 3, 4,  NULL, NULL, NULL, NULL, NULL, 20,   'Dumbbell',  120, NULL, NULL, 0, NULL, NULL, 'Each leg. 2-3 sec descend / explosive stand. 10 kg each hand'),
(15, 36, 'C', 3, 6,  NULL, NULL, NULL, NULL, NULL, 15,   'Dumbbell',  120, NULL, NULL, 0, NULL, NULL, 'Each leg. 2 sec up / 2 sec pause / 2 sec down. Load range 10-20 kg'),
(15, 37, 'D', 2, NULL, NULL, NULL, NULL, 8,   10,   NULL, 'Bodyweight', 120, NULL, NULL, 0, NULL, NULL, 'Joint tolerance at ~90 degrees'),
(15, 38, 'E', 2, NULL, NULL, NULL, NULL, 15,  15,   NULL, 'Bodyweight',  60, NULL, NULL, 0, NULL, NULL, 'Each leg. Pelvic stability'),
(15, 61, 'F', 2, NULL, NULL, NULL, NULL, 40,  40,   NULL, 'Bodyweight',  60, NULL, NULL, 0, NULL, NULL, 'Full-range mobility'),
(15, 62, 'G', 2, NULL, NULL, NULL, NULL, 30,  35,   NULL, 'Bodyweight',  60, NULL, NULL, 0, NULL, NULL, 'Adductor flexibility'),
(15, 63, 'H', 1, NULL, NULL, NULL, NULL, 25,  30,   NULL, 'Bodyweight',  45,  60, NULL, 0, NULL, NULL, 'Each leg. Anterior chain release');

GO

-- =============================================
-- VERIFY
-- =============================================

SELECT COUNT(*) AS BodyRegionRows       FROM BodyRegion;
SELECT COUNT(*) AS ExerciseRows         FROM Exercise;
SELECT COUNT(*) AS ExerciseBodyRegionRows FROM ExerciseBodyRegion;
SELECT COUNT(*) AS QuarterRows          FROM Quarter;
SELECT COUNT(*) AS CycleDayRows         FROM CycleDay;
SELECT COUNT(*) AS DayExerciseRows      FROM DayExercise;
GO
