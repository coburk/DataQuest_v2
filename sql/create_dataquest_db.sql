-- Create DataQuest database
-- This script creates the initial database schema for DataQuest: SQL Detective

-- Use master database to create the new database
USE master;
GO

-- Drop existing database if it exists (for development)
-- Comment out or remove in production
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'DataQuest')
BEGIN
    ALTER DATABASE DataQuest SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataQuest;
END
GO

-- Create the DataQuest database
CREATE DATABASE DataQuest;
GO

-- Use the DataQuest database for schema creation
USE DataQuest;
GO

-- ============================================================
-- Core Investigative Tables
-- ============================================================

-- Create Person table
CREATE TABLE [dbo].[Person] (
    [PersonId] INT PRIMARY KEY IDENTITY(1,1),
    [FirstName] NVARCHAR(100) NOT NULL,
    [LastName] NVARCHAR(100) NOT NULL,
    [Gender] CHAR(1) NULL,
    [DateOfBirth] DATE NULL,
    [Occupation] NVARCHAR(100) NULL,
    [PhoneNumber] NVARCHAR(20) NULL,
    [EmailAddress] NVARCHAR(100) NULL,
    [CreatedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [ModifiedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);
GO

-- Create Location table
CREATE TABLE [dbo].[Location] (
    [LocationId] INT PRIMARY KEY IDENTITY(1,1),
    [LocationName] NVARCHAR(200) NOT NULL,
    [Address] NVARCHAR(300) NULL,
    [City] NVARCHAR(100) NULL,
    [State] NVARCHAR(50) NULL,
    [ZipCode] NVARCHAR(20) NULL,
    [LocationType] NVARCHAR(50) NULL,
    [Description] NVARCHAR(MAX) NULL,
    [CreatedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [ModifiedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);
GO

-- Create Evidence table
CREATE TABLE [dbo].[Evidence] (
    [EvidenceId] INT PRIMARY KEY IDENTITY(1,1),
    [EvidenceDescription] NVARCHAR(MAX) NOT NULL,
    [EvidenceType] NVARCHAR(100) NOT NULL,
    [FoundLocation] INT NULL,
    [FoundDate] DATETIME2 NULL,
    [Chain] NVARCHAR(500) NULL,
  [CreatedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [ModifiedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    FOREIGN KEY ([FoundLocation]) REFERENCES [dbo].[Location]([LocationId])
);
GO

-- Create Communication table
CREATE TABLE [dbo].[Communication] (
    [CommunicationId] INT PRIMARY KEY IDENTITY(1,1),
    [FromPersonId] INT NOT NULL,
    [ToPersonId] INT NOT NULL,
    [CommunicationType] NVARCHAR(50) NOT NULL, -- 'Phone', 'Email', 'Message', 'Meeting'
    [CommunicationDateTime] DATETIME2 NOT NULL,
    [MessageContent] NVARCHAR(MAX) NULL,
    [Duration] INT NULL, -- in seconds
    [Location] INT NULL,
    [CreatedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [ModifiedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    FOREIGN KEY ([FromPersonId]) REFERENCES [dbo].[Person]([PersonId]),
    FOREIGN KEY ([ToPersonId]) REFERENCES [dbo].[Person]([PersonId]),
    FOREIGN KEY ([Location]) REFERENCES [dbo].[Location]([LocationId])
);
GO

-- ============================================================
-- Case Management Tables
-- ============================================================

-- Create Case table
CREATE TABLE [dbo].[Case] (
  [CaseId] INT PRIMARY KEY IDENTITY(1,1),
    [CaseName] NVARCHAR(200) NOT NULL,
[CaseDescription] NVARCHAR(MAX) NULL,
    [CaseStatus] NVARCHAR(50) NOT NULL, -- 'Draft', 'Active', 'Completed', 'Archived'
 [Difficulty] NVARCHAR(50) NULL, -- 'Beginner', 'Intermediate', 'Advanced'
    [CreatedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [ModifiedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);
GO

-- Create CaseStep table
CREATE TABLE [dbo].[CaseStep] (
    [CaseStepId] INT PRIMARY KEY IDENTITY(1,1),
    [CaseId] INT NOT NULL,
    [StepNumber] INT NOT NULL,
    [StepTitle] NVARCHAR(200) NOT NULL,
    [StepDescription] NVARCHAR(MAX) NULL,
    [StepType] NVARCHAR(50) NOT NULL, -- 'Investigation', 'Conclusion', 'Evidence', 'Timeline'
    [CreatedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [ModifiedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
FOREIGN KEY ([CaseId]) REFERENCES [dbo].[Case]([CaseId]),
  UNIQUE ([CaseId], [StepNumber])
);
GO

-- ============================================================
-- Query Management Tables
-- ============================================================

-- Create StudentQuery table
CREATE TABLE [dbo].[StudentQuery] (
    [QueryId] INT PRIMARY KEY IDENTITY(1,1),
    [CaseId] INT NOT NULL,
    [CaseStepId] INT NOT NULL,
  [StudentId] NVARCHAR(100) NOT NULL,
    [QueryText] NVARCHAR(MAX) NOT NULL,
    [SubmittedDateTime] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [HintLevel] INT NULL DEFAULT 0,
    [IsCorrect] BIT NULL,
    [CreatedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
FOREIGN KEY ([CaseId]) REFERENCES [dbo].[Case]([CaseId]),
    FOREIGN KEY ([CaseStepId]) REFERENCES [dbo].[CaseStep]([CaseStepId])
);
GO

-- ============================================================
-- Indexes
-- ============================================================

-- Create indexes for common queries
CREATE INDEX IDX_Person_Name ON [dbo].[Person]([LastName], [FirstName]);
CREATE INDEX IDX_Location_Name ON [dbo].[Location]([LocationName]);
CREATE INDEX IDX_Evidence_Type ON [dbo].[Evidence]([EvidenceType]);
CREATE INDEX IDX_Communication_DateTime ON [dbo].[Communication]([CommunicationDateTime]);
CREATE INDEX IDX_Communication_Persons ON [dbo].[Communication]([FromPersonId], [ToPersonId]);
CREATE INDEX IDX_Case_Status ON [dbo].[Case]([CaseStatus]);
CREATE INDEX IDX_CaseStep_CaseId ON [dbo].[CaseStep]([CaseId]);
CREATE INDEX IDX_StudentQuery_CaseId ON [dbo].[StudentQuery]([CaseId], [StudentId]);

GO

-- ============================================================
-- Schema created successfully
-- ============================================================
