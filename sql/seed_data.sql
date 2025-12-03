-- Seed data for DataQuest database
-- This script populates the database with sample investigative data

USE DataQuest;
GO

-- ============================================================
-- Seed Person table
-- ============================================================

INSERT INTO [dbo].[Person] ([FirstName], [LastName], [Gender], [DateOfBirth], [Occupation], [PhoneNumber], [EmailAddress])
VALUES
    ('Alice', 'Johnson', 'F', '1985-03-15', 'Software Engineer', '555-0101', 'alice.johnson@email.com'),
    ('Bob', 'Smith', 'M', '1982-07-22', 'Project Manager', '555-0102', 'bob.smith@email.com'),
    ('Carol', 'Williams', 'F', '1990-11-08', 'Data Analyst', '555-0103', 'carol.williams@email.com'),
    ('David', 'Brown', 'M', '1988-05-30', 'System Administrator', '555-0104', 'david.brown@email.com'),
    ('Emma', 'Davis', 'F', '1992-09-12', 'Business Analyst', '555-0105', 'emma.davis@email.com');
GO

-- ============================================================
-- Seed Location table
-- ============================================================

INSERT INTO [dbo].[Location] ([LocationName], [Address], [City], [State], [ZipCode], [LocationType], [Description])
VALUES
    ('Main Office', '123 Business Ave', 'New York', 'NY', '10001', 'Office', 'Corporate headquarters'),
    ('Conference Room A', '123 Business Ave, Room 501', 'New York', 'NY', '10001', 'Meeting Room', 'Large conference room'),
    ('Coffee Shop Downtown', '456 Coffee St', 'New York', 'NY', '10002', 'Public Place', 'Local coffee shop'),
    ('Home Office - Alice', '789 Oak St', 'New York', 'NY', '10003', 'Residence', 'Alice residence'),
    ('Server Room', '123 Business Ave, Basement', 'New York', 'NY', '10001', 'Technical', 'Data center');
GO

-- ============================================================
-- Seed Evidence table
-- ============================================================

INSERT INTO [dbo].[Evidence] ([EvidenceDescription], [EvidenceType], [FoundLocation], [FoundDate], [Chain])
VALUES
    ('Red USB drive found on desk', 'Physical Evidence', 1, '2024-01-15 09:30:00', 'Alice -> Bob -> Evidence Log'),
    ('Email correspondence about project', 'Digital Evidence', NULL, '2024-01-15 10:00:00', 'Email System -> Archive'),
    ('Handwritten note with code snippet', 'Physical Evidence', 4, '2024-01-15 14:20:00', 'Alice residence -> Lab'),
    ('Security camera footage', 'Video Evidence', 2, '2024-01-15 08:00:00', 'Security System -> Digital Archive'),
    ('Phone call records', 'Digital Evidence', NULL, '2024-01-15 15:00:00', 'Telecom Provider -> Records');
GO

-- ============================================================
-- Seed Communication table
-- ============================================================

INSERT INTO [dbo].[Communication] ([FromPersonId], [ToPersonId], [CommunicationType], [CommunicationDateTime], [MessageContent], [Duration], [Location])
VALUES
    (1, 2, 'Email', '2024-01-15 08:00:00', 'Hi Bob, please review the project status report.', NULL, NULL),
    (2, 1, 'Email', '2024-01-15 08:15:00', 'Alice, I will review it this morning.', NULL, NULL),
    (1, 3, 'Phone', '2024-01-15 09:00:00', NULL, 1200, NULL),
    (1, 2, 'Meeting', '2024-01-15 10:00:00', 'Project Status Review', 3600, 2),
    (2, 4, 'Phone', '2024-01-15 14:00:00', NULL, 600, NULL);
GO

-- ============================================================
-- Seed Case table
-- ============================================================

INSERT INTO [dbo].[Case] ([CaseName], [CaseDescription], [CaseStatus], [Difficulty])
VALUES
    ('The Mystery of the Missing Code', 'A valuable code repository has gone missing. Investigators must trace communications and physical evidence to find out who took it and why.', 'Draft', 'Intermediate'),
    ('Timeline Contradiction', 'Multiple witnesses provide conflicting accounts of their activities. Use SQL to construct a timeline and identify inconsistencies.', 'Draft', 'Beginner'),
    ('The Data Breach', 'Unusual database access has been detected. Trace logs and communications to identify the culprit.', 'Draft', 'Advanced');
GO

-- ============================================================
-- Seed CaseStep table
-- ============================================================

INSERT INTO [dbo].[CaseStep] ([CaseId], [StepNumber], [StepTitle], [StepDescription], [StepType])
VALUES
    (1, 1, 'Gather Witness Statements', 'Interview all people involved and review their statements', 'Investigation'),
    (1, 2, 'Timeline Analysis', 'Build a timeline of events from the communications', 'Timeline'),
    (1, 3, 'Draw Conclusions', 'Determine who took the code and provide evidence', 'Conclusion'),
    (2, 1, 'Initial Evidence Review', 'Examine all evidence and witness statements', 'Evidence'),
    (2, 2, 'Build Timeline', 'Construct a chronological timeline of events', 'Timeline'),
    (2, 3, 'Identify Contradictions', 'Use SQL to find conflicts in the timeline', 'Investigation'),
    (2, 4, 'Final Conclusion', 'Determine which account is most likely true', 'Conclusion');
GO

-- ============================================================
-- Data seeding complete
-- ============================================================
