-- Seed data for DataQuest database
-- This script populates the database with sample investigative data
-- Data Dictionary compliant

USE DataQuest;
GO

-- ============================================================
-- Seed Persons table
-- ============================================================

INSERT INTO [dbo].[Persons] ([Name], [Role], [IsSuspect])
VALUES
    ('Alice Johnson', 'Suspect', 1),
    ('Bob Smith', 'Witness', 0),
    ('Carol Williams', 'Investigator', 0),
    ('David Brown', 'Witness', 0),
    ('Emma Davis', 'Victim', 0);
GO

-- ============================================================
-- Seed Locations table
-- ============================================================

INSERT INTO [dbo].[Locations] ([Name], [Address])
VALUES
    ('Main Office', '123 Business Ave, New York, NY 10001'),
    ('Conference Room A', '123 Business Ave, Room 501, New York, NY 10001'),
    ('Coffee Shop Downtown', '456 Coffee St, New York, NY 10002'),
    ('Alice Residence', '789 Oak St, New York, NY 10003'),
    ('Server Room', '123 Business Ave, Basement, New York, NY 10001');
GO

-- ============================================================
-- Seed Relationships table
-- ============================================================

INSERT INTO [dbo].[Relationships] ([PersonID_A], [PersonID_B], [Type])
VALUES
    (1, 2, 'Coworker'),   -- Alice and Bob
    (1, 3, 'Acquaintance'),  -- Alice and Carol
    (2, 4, 'Coworker'),      -- Bob and David
    (1, 5, 'Employer'),      -- Alice and Emma (supervisor)
    (3, 5, 'Coworker');      -- Carol and Emma
GO

-- ============================================================
-- Seed Cases table
-- ============================================================

INSERT INTO [dbo].[Cases] ([CaseTitle], [InitialPrompt], [Conclusion])
VALUES
    (
  'The Mystery of the Missing Code',
        'A valuable proprietary code repository has gone missing from the main office. Your job is to investigate by examining communications, access logs, and witness statements to determine who took it and why. Timeline is critical - trace when the theft occurred.',
        NULL  -- Conclusion will be filled after student completes case
    ),
    (
     'Timeline Contradiction',
        'Multiple witnesses provide conflicting accounts of their activities on the day of the incident. Use SQL to construct a timeline from transaction logs and communications. Identify which accounts are inconsistent and determine what really happened.',
        NULL
    ),
    (
        'The Data Breach',
   'Unusual database access has been detected outside normal business hours. Someone unauthorized accessed customer data. Examine server logs, access records, and communications to identify the culprit and determine what data was accessed.',
        NULL
    );
GO

-- ============================================================
-- Seed Evidence table
-- ============================================================

INSERT INTO [dbo].[Evidence] ([CaseID], [LocationID], [Type], [TimestampFound])
VALUES
    (1, 1, 'CCTV_Log', '2024-01-15 09:30:00'),
    (1, NULL, 'Email', '2024-01-15 10:00:00'),
    (1, 4, 'Physical', '2024-01-15 14:20:00'),
    (1, 2, 'CCTV_Log', '2024-01-15 08:00:00'),
    (2, NULL, 'Financial_Record', '2024-01-15 15:00:00'),
    (3, 5, 'CCTV_Log', '2024-01-16 02:15:00'),
    (3, NULL, 'Access_Log', '2024-01-16 02:30:00');
GO

-- ============================================================
-- Seed WitnessStatements table
-- ============================================================

INSERT INTO [dbo].[WitnessStatements] ([CaseID], [PersonID], [StatementText])
VALUES
    (1, 2, 'I saw Alice leaving the office around 5:15 PM with a USB drive. She looked nervous and hurried out quickly.'),
 (1, 4, 'I was in the conference room working late. I did not see anyone suspicious. Alice was at her desk most of the day.'),
    (1, 5, 'Alice asked me about accessing the code repository backup yesterday. She said she needed it for a project, but I thought that was strange since we have version control.'),
    (2, 2, 'I left the office at 3 PM on that day. I saw David at the coffee shop around 3:30 PM.'),
    (2, 4, 'I was at the office the entire day. I did not leave until 6 PM. I never went to the coffee shop.'),
    (3, 3, 'System detected unauthorized access to the database server at 2:15 AM. Access was from an internal IP, suggesting someone with physical access to the building.');
GO

-- ============================================================
-- Seed TransactionLogs table
-- ============================================================

INSERT INTO [dbo].[TransactionLogs] ([PersonID], [Timestamp], [Amount])
VALUES
    (1, '2024-01-15 08:00:00', NULL),     -- Alice arrives at office
    (1, '2024-01-15 09:15:00', NULL),     -- Alice at workstation
    (2, '2024-01-15 08:30:00', NULL),     -- Bob arrives
    (2, '2024-01-15 15:00:00', NULL),     -- Bob leaves office
    (2, '2024-01-15 15:30:00', 5.50),     -- Bob's coffee purchase (Timeline Contradiction case)
    (4, '2024-01-15 08:45:00', NULL),     -- David arrives
    (4, '2024-01-15 18:00:00', NULL),     -- David leaves office (contradicts statement)
    (1, '2024-01-15 17:15:00', NULL),   -- Alice leaves office
    (1, '2024-01-16 00:00:00', NULL),     -- Alice badge access attempt at night (suspicious)
    (3, '2024-01-16 02:15:00', NULL), -- Carol at server room (authorized maintenance)
    (NULL, '2024-01-16 02:30:00', NULL);  -- Unauthorized access (person unknown)
GO

-- ============================================================
-- Seed StorySteps table
-- ============================================================

INSERT INTO [dbo].[StorySteps] ([CaseID], [StepNumber], [StepPrompt], [CanonicalQuery])
VALUES
    (
        1,
        1,
  'Who left the office latest and might have had opportunity to steal the code?',
   'SELECT TOP 1 p.Name, MAX(t.Timestamp) as LastSeen FROM Persons p JOIN TransactionLogs t ON p.PersonID = t.PersonID WHERE p.IsSuspect = 1 GROUP BY p.PersonID, p.Name ORDER BY MAX(t.Timestamp) DESC'
    ),
    (
        1,
        2,
        'What relationships exist between the suspect and other people?',
        'SELECT r.Type, CASE WHEN r.PersonID_A = 1 THEN p.Name ELSE p2.Name END as RelatedPerson FROM Relationships r JOIN Persons p ON r.PersonID_B = p.PersonID JOIN Persons p2 ON r.PersonID_A = p2.PersonID WHERE r.PersonID_A = 1 OR r.PersonID_B = 1'
    ),
    (
        1,
      3,
        'What did witnesses say about the suspect''s behavior?',
        'SELECT w.StatementText FROM WitnessStatements w WHERE w.PersonID = 1 OR w.StatementText LIKE ''%Alice%'''
    ),
    (
  2,
        1,
        'Build a timeline of everyone''s activities on that day.',
        'SELECT p.Name, t.Timestamp, DATEPART(HOUR, t.Timestamp) as Hour FROM Persons p LEFT JOIN TransactionLogs t ON p.PersonID = t.PersonID WHERE CAST(t.Timestamp AS DATE) = ''2024-01-15'' ORDER BY t.Timestamp'
    ),
    (
  2,
  2,
        'Which witness statement contradicts the transaction logs?',
   'SELECT p.Name, w.StatementText FROM Persons p JOIN WitnessStatements w ON p.PersonID = w.PersonID WHERE w.CaseID = 2 AND (p.PersonID = 2 OR p.PersonID = 4)'
    ),
    (
        3,
1,
        'Who had physical access to the server room at the time of the breach?',
        'SELECT p.Name, t.Timestamp FROM Persons p JOIN TransactionLogs t ON p.PersonID = t.PersonID WHERE t.Timestamp BETWEEN ''2024-01-16 02:00:00'' AND ''2024-01-16 03:00:00'' ORDER BY t.Timestamp'
    );
GO

-- ============================================================
-- Seed AnswerKeys table
-- ============================================================

INSERT INTO [dbo].[AnswerKeys] ([StepID], [ExpectedResultHash], [ExpectedClueValue])
VALUES
    (1, 'HASH_1_LATEST_PERSON', 'Alice Johnson left at 17:15:00 - latest departure'),
    (2, 'HASH_1_RELATIONSHIPS', 'Alice has relationships with: Coworker (Bob), Acquaintance (Carol), Employer relationship to Emma'),
    (3, 'HASH_1_WITNESS_STATEMENTS', 'Bob saw Alice leaving with a USB drive looking nervous; Emma found her request for backup access suspicious'),
  (4, 'HASH_2_TIMELINE', 'David''s log shows 18:00 departure but his statement claims he was at office all day and left at 6 PM - times don''t match'),
    (5, 'HASH_2_CONTRADICTION', 'David''s statement says he was at office, but transaction logs show coffee shop visit at 15:30'),
 (6, 'HASH_3_ACCESS', 'Carol had authorized access; unauthorized access was from unknown person - likely insider with credentials');
GO

-- ============================================================
-- Data seeding complete - Schema and data are Data Dictionary compliant
-- ============================================================
