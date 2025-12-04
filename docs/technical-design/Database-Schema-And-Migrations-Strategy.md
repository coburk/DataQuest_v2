# Database Schema & Migrations Strategy

**Date:** December 3, 2025  
**Status:** IMPLEMENTATION SPECIFICATION - DATABASE SCHEMA & MIGRATIONS  
**Version:** 1.0  
**Classification:** Critical - Required Before Phase 1 Launch

---

## 📋 Document Purpose

This specification defines the complete database schema for DataQuest, including all tables, relationships, constraints, and the strategy for managing schema changes through migrations. It consolidates existing schema documentation and provides clear guidance for developers building the database layer.

**This document enables:**
- ✅ Developers understand the complete data model
- ✅ Database initialization for new environments
- ✅ Schema evolution through migrations
- ✅ Performance through proper indexing
- ✅ Data integrity through constraints
- ✅ Query optimization through design

---

## 🎯 Scope

### What This Document Covers

```
✅ Complete database schema (all tables, columns, types)
✅ Primary/foreign key relationships
✅ Constraints and validation rules
✅ Indexing strategy (columns to index, composite keys)
✅ Database migration strategy (how to update schema)
✅ Seed data strategy (initial data for environments)
✅ Backup and recovery procedures
✅ Query performance optimization guidelines
✅ Connection pooling configuration
✅ Database initialization procedures
```

### What This Document Does NOT Cover

```
❌ Specific T-SQL syntax (refer to SQL Server documentation)
❌ Advanced replication/sharding strategies
❌ Data warehouse or OLAP considerations
❌ Cloud-specific database options (Phase 2+)
```

---

## 🏗️ Database Architecture Overview

### Design Principles

```
1. Normalization (3NF)
   └─ Reduces data redundancy
   └─ Maintains data integrity
   └─ Supports query flexibility

2. Performance First
   └─ Strategic denormalization where needed
   └─ Proper indexing on foreign keys
   └─ Composite indices for common queries

3. Auditability
   └─ CreatedAt, UpdatedAt timestamps
   └─ CreatedBy, UpdatedBy tracking
   └─ Soft deletes where appropriate

4. Extensibility
   └─ Room for additional fields
   └─ JSON columns for semi-structured data
   └─ Versioning for case content
```

### Two-Part Schema Design

**DataQuest uses a dual-schema approach:**

```
PART 1: Student & Platform Management
├─ Students - Student profiles and progress
├─ Student_Sessions - Case session tracking
├─ Student_Queries - Query submissions and results
├─ Query_Feedback - AI tutor feedback
├─ Case_Content - Case definitions (stored as JSON + metadata)
└─ Audit_Log - Security and compliance logging

PART 2: Investigative Case Data (per case database)
├─ Cases - Case definitions (metadata only in main DB)
├─ Persons - People involved in the case
├─ Locations - Places of interest
├─ Evidence - Physical evidence records
├─ WitnessStatements - Statements from witnesses
├─ TransactionLogs - Financial/access logs
├─ CommunicationRecords - Phone/email logs
├─ Relationships - Links between persons
└─ StorySteps - Sequential case progression steps
```

---

## 📊 Core Schema Design

### Entity Relationship Diagram (Logical)

```
PART 1: STUDENT MANAGEMENT TIER
┌──────────────────────────────────────────────────────────────────┐
│      Platform-Level Tables (Main Database)   │
└──────────────────────────────────────────────────────────────────┘

STUDENTS (PK: StudentID)
  ├─ StudentID (GUID)
  ├─ Email (nvarchar(255), unique)
  ├─ FirstName (nvarchar(100))
  ├─ LastName (nvarchar(100))
  ├─ CurrentTier (int, FK→Tiers)
  ├─ TierStartedAt (datetime2)
  ├─ CreatedAt (datetime2)
  └─ UpdatedAt (datetime2)

STUDENT_SESSIONS (PK: SessionID)
  ├─ SessionID (GUID)
  ├─ StudentID (GUID, FK→Students)
  ├─ CaseID (GUID, FK→Cases)
  ├─ State (nvarchar(50): ACTIVE, PAUSED, COMPLETED)
  ├─ CurrentStepNumber (int)
  ├─ CreatedAt (datetime2)
  ├─ ExpiresAt (datetime2)
  ├─ LastActivityAt (datetime2)
  └─ CompletedAt (datetime2, nullable)

STUDENT_QUERIES (PK: QueryID)
  ├─ QueryID (GUID)
  ├─ SessionID (GUID, FK→Student_Sessions)
  ├─ StudentID (GUID, FK→Students)
  ├─ CaseID (GUID, FK→Cases)
  ├─ QueryText (nvarchar(max))
  ├─ ExecutionTimeMs (int)
  ├─ Status (nvarchar(50): VALID, INVALID, ERROR, TIMEOUT)
  ├─ ErrorMessage (nvarchar(max), nullable)
  ├─ ResultRowCount (int)
  ├─ SubmittedAt (datetime2)
  ├─ FeedbackID (GUID, FK→Query_Feedback, nullable)
  └─ CreatedAt (datetime2)

QUERY_FEEDBACK (PK: FeedbackID)
  ├─ FeedbackID (GUID)
  ├─ QueryID (GUID, FK→Student_Queries)
  ├─ SessionID (GUID, FK→Student_Sessions)
  ├─ FeedbackType (nvarchar(50): HINT, CORRECTION, ENCOURAGEMENT)
  ├─ FeedbackText (nvarchar(max))
  ├─ HintLevel (int, 1-6, nullable)
  ├─ AgentGenerated (bit)
  ├─ CreatedAt (datetime2)
  └─ UpdatedAt (datetime2)

CASE_CONTENT (PK: ContentID)
  ├─ ContentID (GUID)
  ├─ CaseID (GUID, FK→Cases)
  ├─ CaseJSON (nvarchar(max))  ← Full case content
  ├─ Version (int)
  ├─ CreatedAt (datetime2)
  ├─ CreatedBy (nvarchar(255))
  └─ Active (bit)

AUDIT_LOG (PK: AuditID)
  ├─ AuditID (BIGINT)
  ├─ EventType (nvarchar(100))
  ├─ StudentID (GUID, FK→Students, nullable)
  ├─ EntityType (nvarchar(100))
  ├─ EntityID (GUID, nullable)
  ├─ Details (nvarchar(max), JSON)
  ├─ IPAddress (nvarchar(50))
  ├─ Timestamp (datetime2)
  └─ [Index on Timestamp]

CASES (PK: CaseID)
  ├─ CaseID (GUID)
  ├─ CaseName (nvarchar(255))
  ├─ Tier (int, FK→Tiers)
  ├─ Description (nvarchar(max))
  ├─ DatabaseName (nvarchar(128))
  ├─ Version (int)
  ├─ Status (nvarchar(50): DRAFT, ACTIVE, ARCHIVED)
  ├─ CreatedAt (datetime2)
  ├─ UpdatedAt (datetime2)
  └─ CreatedBy (nvarchar(255))

TIERS (PK: TierID)
  ├─ TierID (int)
  ├─ TierName (nvarchar(100))
  ├─ TierLevel (int, 1-5)
  ├─ Description (nvarchar(max))
  ├─ SocraticLevel (int, 1-6)
  ├─ MinHintCount (int)
  ├─ MaxHintCount (int)
  └─ CreatedAt (datetime2)

┌──────────────────────────────────────────────────────────────────┐
│  PART 2: INVESTIGATIVE CASE DATA (Per Case Database)    │
│    Defined in Core Domain Models & Data Dictionary     │
└──────────────────────────────────────────────────────────────────┘

CASES (Metadata - case definitions)
  ├─ CaseID (int, PK)
  ├─ CaseTitle (varchar(100))
  ├─ InitialPrompt (varchar(max))
  └─ Conclusion (varchar(max), nullable)

PERSONS (PK: PersonID)
  ├─ PersonID (int)
  ├─ CaseID (int, FK→Cases)
  ├─ Name (varchar(50))
  ├─ Role (varchar(50))
  └─ IsSuspect (bit)

LOCATIONS (PK: LocationID)
  ├─ LocationID (int)
  ├─ CaseID (int, FK→Cases)
  ├─ Name (varchar(100))
  └─ Address (varchar(255))

EVIDENCE (PK: EvidenceID)
  ├─ EvidenceID (int)
  ├─ CaseID (int, FK→Cases)
  ├─ LocationID (int, FK→Locations)
  ├─ Type (varchar(50))
  └─ TimestampFound (datetime2)

WITNESSTATEMENTS (PK: StatementID)
  ├─ StatementID (int)
  ├─ CaseID (int, FK→Cases)
  ├─ PersonID (int, FK→Persons)
  └─ StatementText (varchar(max))

TRANSACTIONLOGS (PK: LogID)
  ├─ LogID (int)
  ├─ CaseID (int, FK→Cases)
  ├─ PersonID (int, FK→Persons, nullable)
  ├─ Timestamp (datetime2)
└─ Amount (decimal(10,2), nullable)

COMMUNICATIONRECORDS (PK: RecordID)
  ├─ RecordID (int)
  ├─ CaseID (int, FK→Cases)
  ├─ CallerID (int, FK→Persons)
  ├─ ReceiverID (int, FK→Persons)
  └─ Timestamp (datetime2)

RELATIONSHIPS (PK: RelationshipID)
  ├─ RelationshipID (int)
  ├─ PersonID_A (int, FK→Persons)
  ├─ PersonID_B (int, FK→Persons)
  └─ Type (varchar(50))

STORYSTEPS (PK: StepID)
  ├─ StepID (int)
  ├─ CaseID (int, FK→Cases)
  ├─ StepPrompt (varchar(max))
  └─ CanonicalQuery (varchar(max))

ANSWERKEYS (PK: AnswerKeyID)
  ├─ AnswerKeyID (int)
  ├─ StepID (int, FK→StorySteps)
  ├─ ExpectedResultHash (varchar(64))
  └─ ExpectedClueValue (varchar(max))
```

---

## 📋 Detailed Table Specifications

### PART 1: STUDENT MANAGEMENT TABLES

[Table specifications continue as before: Students, Student_Sessions, Student_Queries, Query_Feedback, Case_Content, Audit_Log, Cases, Tiers]

### PART 2: INVESTIGATIVE CASE TABLES (From Core Domain Models)

**Reference:** See `docs/design-and-planning/Core Domain Models.md` and `docs/design-and-planning/Data Dictionary - DataQuest.md`

These tables are defined per-case in separate case databases. Key tables include:

#### Table: Persons

```sql
CREATE TABLE Persons (
    PersonID INT PRIMARY KEY,
    CaseID INT NOT NULL,
    Name VARCHAR(50) NOT NULL,
    Role VARCHAR(50) NOT NULL CHECK (Role IN ('Suspect', 'Witness', 'Victim')),
    IsSuspect BIT NOT NULL DEFAULT 0,
    
CONSTRAINT FK_Persons_Case FOREIGN KEY (CaseID)
        REFERENCES Cases(CaseID),
CONSTRAINT CK_PersonRole CHECK (Role IN ('Suspect', 'Witness', 'Victim'))
)
```

#### Table: Locations

```sql
CREATE TABLE Locations (
    LocationID INT PRIMARY KEY,
    CaseID INT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    
    CONSTRAINT FK_Locations_Case FOREIGN KEY (CaseID)
        REFERENCES Cases(CaseID)
)
```

#### Table: Evidence

```sql
CREATE TABLE Evidence (
    EvidenceID INT PRIMARY KEY,
  CaseID INT NOT NULL,
    LocationID INT NOT NULL,
  Type VARCHAR(50) NOT NULL,
    TimestampFound DATETIME2 NOT NULL,
    
    CONSTRAINT FK_Evidence_Case FOREIGN KEY (CaseID)
        REFERENCES Cases(CaseID),
    CONSTRAINT FK_Evidence_Location FOREIGN KEY (LocationID)
        REFERENCES Locations(LocationID)
)
```

#### Table: TransactionLogs

```sql
CREATE TABLE TransactionLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    CaseID INT NOT NULL,
    PersonID INT NULL,
    Timestamp DATETIME2 NOT NULL,
    Amount DECIMAL(10,2) NULL,
    
    CONSTRAINT FK_TransactionLogs_Case FOREIGN KEY (CaseID)
        REFERENCES Cases(CaseID),
    CONSTRAINT FK_TransactionLogs_Person FOREIGN KEY (PersonID)
        REFERENCES Persons(PersonID),
    CONSTRAINT CK_Amount CHECK (Amount IS NULL OR Amount > 0)
)
```

#### Table: WitnessStatements

```sql
CREATE TABLE WitnessStatements (
    StatementID INT PRIMARY KEY,
    CaseID INT NOT NULL,
    PersonID INT NOT NULL,
    StatementText VARCHAR(MAX) NOT NULL,
    
    CONSTRAINT FK_WitnessStatements_Case FOREIGN KEY (CaseID)
        REFERENCES Cases(CaseID),
    CONSTRAINT FK_WitnessStatements_Person FOREIGN KEY (PersonID)
        REFERENCES Persons(PersonID)
)
```

#### Table: CommunicationRecords

```sql
CREATE TABLE CommunicationRecords (
    RecordID INT PRIMARY KEY,
    CaseID INT NOT NULL,
    CallerID INT NOT NULL,
    ReceiverID INT NOT NULL,
    Timestamp DATETIME2 NOT NULL,
    
    CONSTRAINT FK_CommunicationRecords_Case FOREIGN KEY (CaseID)
   REFERENCES Cases(CaseID),
    CONSTRAINT FK_CommunicationRecords_Caller FOREIGN KEY (CallerID)
        REFERENCES Persons(PersonID),
    CONSTRAINT FK_CommunicationRecords_Receiver FOREIGN KEY (ReceiverID)
        REFERENCES Persons(PersonID)
)
```

#### Table: Relationships

```sql
CREATE TABLE Relationships (
    RelationshipID INT PRIMARY KEY,
    PersonID_A INT NOT NULL,
    PersonID_B INT NOT NULL,
    Type VARCHAR(50) NOT NULL,
    
    CONSTRAINT FK_Relationships_PersonA FOREIGN KEY (PersonID_A)
        REFERENCES Persons(PersonID),
    CONSTRAINT FK_Relationships_PersonB FOREIGN KEY (PersonID_B)
     REFERENCES Persons(PersonID),
    CONSTRAINT CK_Different_Persons CHECK (PersonID_A <> PersonID_B)
)
```

#### Table: StorySteps

```sql
CREATE TABLE StorySteps (
    StepID INT PRIMARY KEY,
    CaseID INT NOT NULL,
    StepPrompt VARCHAR(MAX) NOT NULL,
    CanonicalQuery VARCHAR(MAX) NOT NULL,
    
    CONSTRAINT FK_StorySteps_Case FOREIGN KEY (CaseID)
      REFERENCES Cases(CaseID)
)
```

#### Table: AnswerKeys

```sql
CREATE TABLE AnswerKeys (
AnswerKeyID INT PRIMARY KEY,
    StepID INT NOT NULL,
    ExpectedResultHash VARCHAR(64) NOT NULL,
  ExpectedClueValue VARCHAR(MAX) NOT NULL,
    
    CONSTRAINT FK_AnswerKeys_Step FOREIGN KEY (StepID)
        REFERENCES StorySteps(StepID),
    CONSTRAINT UQ_AnswerKeys_Step UNIQUE (StepID)
)
```

---

## 📋 CONSOLIDATED TABLE REFERENCE

| Category | Table Name | Purpose | Location |
|----------|-----------|---------|----------|
| **Student Management** | Students | Student profiles | Main DB |
| | Student_Sessions | Case session tracking | Main DB |
| | Student_Queries | Query submissions | Main DB |
| | Query_Feedback | Tutor feedback | Main DB |
| | Tiers | Tier definitions | Main DB |
| | Cases | Case metadata | Main DB |
| | Case_Content | Case JSON content | Main DB |
| | Audit_Log | Security logging | Main DB |
| **Investigative Data** | Persons | Case people | Case DB |
| | Locations | Case locations | Case DB |
| | Evidence | Physical evidence | Case DB |
| | WitnessStatements | Witness accounts | Case DB |
| | TransactionLogs | Financial/access logs | Case DB |
| | CommunicationRecords | Communication logs | Case DB |
| | Relationships | Person relationships | Case DB |
| | StorySteps | Case progression | Case DB |
| | AnswerKeys | Canonical answers | Case DB |

---

## 🔄 Database Initialization Strategy

### Initialization Order

**Step 1: Create Student Management Database (Main)**
```sql
-- Create all tables in Part 1
-- Insert Tier seed data
-- Ready for students to enroll
```

**Step 2: Create Case Databases (Per Case)**
```sql
-- For each active case, create a separate database
-- Insert case-specific tables (Persons, Locations, Evidence, etc.)
-- Populate with case data from Case_Content JSON
-- Register in main Cases table
```

**Step 3: Seed Reference Data**
```sql
-- Tiers (main DB)
-- Cases metadata (main DB)
-- Case content via Case_Content table
```

[Rest of document continues as before...]

