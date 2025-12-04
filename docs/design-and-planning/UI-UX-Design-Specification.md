# UI/UX Design Specification

**Date:** December 3, 2025  
**Status:** IMPLEMENTATION SPECIFICATION - CRITICAL PATH  
**Version:** 1.0  
**Classification:** Binding Implementation Standard

---

**SOURCE OF TRUTH TRACKING**

**COMPLIANCE STATUS:** ✅ PROPOSAL-COMPLIANT (with approved extensions)  
**SOURCE OF TRUTH:** 
- Tier 1: `docs/proposal/DataQuest-Project-Proposal.md` (Appendix A: UI Mockups)
- Tier 3: This document

**CHANGE REQUESTS:** CR002 (Approved Extensions - Phase 2/3 forward-looking design)  
**CAPSTONE IMPACT:** ZERO (all extensions clearly marked Phase 2/3+)  
**LAST COMPLIANCE REVIEW:** December 3, 2025  
**REVIEWED BY:** Systematic Compliance Review

---

## 📋 Document Purpose

This specification defines the user interface and user experience for DataQuest: SQL Detective. It operationalizes the tier system, agent coordination, and pedagogical principles into concrete visual and interaction patterns that make learning SQL engaging and intuitive.

**This document enables:**
- ✅ Developers to build UI without ambiguity
- ✅ QA to validate UX without clarification
- ✅ Designers to maintain consistency
- ✅ Stakeholders to understand student experience

---

## 🎯 Scope

### What This Document Covers

```
✅ Overall application layout and structure
✅ Dashboard/home screen design
✅ Case selection interface
✅ Case execution interface
✅ Query editor and submission
✅ Evidence/timeline display
✅ Hint system UI
✅ Achievement and progression display
✅ Tier advancement messaging
✅ Navigation patterns
✅ Responsive design guidelines
✅ Accessibility standards
✅ Error and feedback display
✅ Agent coordination indicators
✅ Student context awareness
```

### What This Document Does NOT Cover

```
❌ Specific visual style/branding (color palette, fonts)
❌ Detailed code implementation
❌ Backend architecture
❌ Database schema
❌ Agent implementation details
❌ Mobile app (future Phase 3)
```

---

## 🏗️ Architecture Overview

### Application Structure

```
DataQuest Application
│
├─ AUTHENTICATION LAYER (Phase 2+)
│  └─ Session management
│
├─ NAVIGATION LAYER
│  ├─ Main navigation
│  ├─ Breadcrumb trail
│  └─ Context indicators
│
├─ MAIN CONTENT AREA
│  ├─ Dashboard (Phase 2+)
│  ├─ Case Selection
│  ├─ Case Execution
│  └─ Results/Achievement Display
│
├─ AGENT COORDINATION LAYER
│  ├─ Query Tutor display
│  ├─ Database Agent display
│  └─ Context sharing
│
└─ CONTEXTUAL ELEMENTS
   ├─ Current tier display
   ├─ Progress indicators
   ├─ Time tracking
   └─ Help/support
```

### Screen Hierarchy

```
TIER 1 (MVP - Phase 1):
├─ Home/Start Screen
├─ Case Selection Screen
├─ Case Execution Screen
└─ Completion Screen

TIER 2 (Enhanced - Phase 2):
├─ Login Screen
├─ Dashboard Screen (Progression tracking)
├─ Case Selection (Updated)
├─ Case Execution (Updated)
└─ Achievement Display

TIER 3+ (Advanced - Phase 3+):
├─ Career Dashboard
├─ Analytics Dashboard
├─ Custom case creation
└─ Social features
```

---

## 📐 Core Screen Designs

### Screen 1: Home/Start Screen

#### Purpose
```
First impression, case selection entry point
Communicates tier system and progression concept
Sets tone for learning experience
```

#### Layout Structure

```
┌─────────────────────────────────────────────────────────────┐
│  DataQuest: SQL Detective    [?]                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  "Welcome to DataQuest!"                                    │
│  "You're beginning your data career                         │
│   as a Junior Data Analyst"                                 │
│                                                             │
│  [Hero Section: Career Progression Visual]                  │
│  ┌───────────────────────────────────────────────────────┐  │
│  │ Junior    Senior    Data        Data        Director  │  │
│  │ Data    → Data    → Inspector → Detective → Of Data   │  │
│  │ Analyst   Analyst                           Integrity │  │
│  │   ✓         ○          ○           ○           ○      │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                             │
│  Your Current Role: Junior Data Analyst [Bronze ◆]          │
│  Progress: 0/3 cases complete                               │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐  │
│  │                    [START A CASE]                     │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                             │
│  "In DataQuest, you advance through authentic               │
│   career roles by solving data mysteries using SQL"         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

#### Key Elements

**Tier Progression Visual:**
```
PURPOSE: Show career path visually
DESIGN:
- 5 tier boxes with icons/badges
- Current tier highlighted (Bronze medal for Tier 1)
- Locked appearance for future tiers
- Clear advancement pathway

INTERACTION:
- Hover to see tier details
- Click to see upcoming tier requirements
- Click to see tier characteristics
```

**Role Display:**
```
PURPOSE: Reinforce current career position
DESIGN:
- Prominent: "Your Current Role: Junior Data Analyst"
- Badge icon matching tier (Bronze, Silver, Gold, etc.)
- Tier description short blurb
- Progress: X of Y cases complete

MESSAGING:
- Tier 1: "You're beginning your data career"
- Tier 2: "You're developing specialization"
- Tier 3: "You're mastering quality verification"
- Tier 4: "You're solving complex investigations"
- Tier 5: "You're leading data strategy"
```

**Call-to-Action Button:**
```
PURPOSE: Clear primary action
DESIGN:
- Large, prominent button
- Text: "START A CASE" (not "Play", not "Begin Level")
- Professional appearance
- Clearly clickable

STATE:
- Default: Active and inviting
- Hover: Subtle animation
- Disabled: If no cases available (rare)
```

---

### Screen 2: Case Selection Screen

#### Purpose
```
Show available cases
Display current tier cases prominently
Show locked future tier cases
Enable case filtering/organization
```

#### Layout Structure

```
┌─────────────────────────────────────────────────────┐
│  DataQuest: SQL Detective    [?]  [←Back]           │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Select Your Investigation                          │
│  ─────────────────────────────────────────────────  │
│                                                     │
│  Your Current Tier: Junior Data Analyst             │
│  Progress: 1/3 cases complete → [Continue tier]     │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │ AVAILABLE CASES (Your Tier)                 │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│  ┌──────────────────┐  ┌──────────────────┐         │
│  │ [✓] The Missing  │  │ [ ] Timeline     │         │
│  │     Code         │  │Discrepancy       │         │
│  │ Simple case      │  │ Simple case      │         │
│  │ 5-7 min          │  │ 5-7 min          │         │
│  │ Junior Analyst   │  │ Junior Analyst   │         │
│  │    [START]       │  |                  │         |
│  └──────────────────┘  └──────────────────┘         │
│                                                     │
│  ┌──────────────────┐                               │
│  │ [ ] The Account  │                               │
│  │     Mystery      │                               │
│  │ Simple case      │                               │
│  │ 7-9 min          │                               │
│  │ Junior Analyst   │                               │
│  │ [START]          │                               │
│  └──────────────────┘                               │
│                                                     │
│  ─────────────────────────────────────────────────  │
│  NEXT TIER PREVIEW                                  │
│  ─────────────────────────────────────────────────  │
│  Complete 3/3 cases to unlock Senior Data Analyst   │
│                                                     │
│  ┌───────────────────────────────────────────────┐  │
│  │ [🔒] Data Quality Check    [Unlock at Tier 2] │  │
│  │ [🔒] Transaction Patterns  [Unlock at Tier 2] |  │
│  └───────────────────────────────────────────────┘  │
│                                                     │
└─────────────────────────────────────────────────────┘
```

#### Key Elements

**Tier Header:**
```
PURPOSE: Remind student of current tier and progress
DESIGN:
- Clear tier name
- Progress bar or counter: "1/3 cases complete"
- Link to continue current tier
- Visual tier badge

INTERACTION:
- Click badge to see tier characteristics
- Click progress to see promotion criteria
```

**Case Card (Available):**
```
PURPOSE: Show case option that's available
DESIGN:
- Card layout with:
  ├─ Checkmark if completed (✓)
  ├─ Case title (professional, not gamified)
  ├─ One-line description
  ├─ Estimated time (5-7 min, 10-15 min, etc.)
  ├─ Tier designation (Junior Data Analyst)
  └─ START button

STATES:
- New case: Available, clickable START button
- In progress: Checkmark + "CONTINUE" button
- Completed: Checkmark + "REVIEW" button (optional)

INTERACTION:
- Hover: Subtle highlight
- Click START: Launch case
- Click title: Show case description popup
```

**Case Card (Locked):**
```
PURPOSE: Show future cases and unlock criteria
DESIGN:
- Card layout with:
  ├─ Lock icon (🔒)
  ├─ Case title (grayed out)
  ├─ Gray background
  ├─ "Unlock at [Tier Name]" label
  └─ No clickable button

INTERACTION:
- Hover: Show "Complete current tier to unlock"
- Click: Show tier requirements popup
```

**Tier Progression Section:**
```
PURPOSE: Show remaining cases and unlock path
DESIGN:
- Section header: "NEXT TIER PREVIEW"
- Short message: "Complete 3/3 cases to unlock 
  Senior Data Analyst"
- Grid of 2-3 locked case cards
- Shows clear progression path

INTERACTION:
- Click any locked case: Show unlock requirements
- Shows what tier/cases needed
```

---

### Screen 3: Case Execution Screen (Primary)

#### Purpose
```
Core learning interface where student solves SQL cases
Coordinate Query Tutor and Database Agent
Display evidence/context
Enable query submission
```

#### Layout Structure

```
┌────────────────────────────────────────────────────────────┐
│  DataQuest: SQL Detective             [?]  [Tier] [←Back]  │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  Case: The Missing Code    ⏱ 12:34 / 15 min               │
│  Junior Data Analyst  |  Step 1 of 3                       │
│  ──────────────────────────────────────────────────────────│
│                                                            │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ CASE NARRATIVE                                      │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │                                                     │   │
│  │ You're a Junior Data Analyst investigating a        │   │
│  │ customer complaint. A code was entered but never    │   │
│  │ recorded in the system. Find all missing codes      │   │
│  │ from the CodeLog table.                             │   │
│  │                                                     │   │
│  │ Available tables: CodeLog, Customers                │   │
│  │                                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                            │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ CURRENT QUESTION                                    │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │                                                     │   │
│  │ Q: Which customer codes have Status = 'Missing'?    │   │
│  │                                                     │   │
│  │ [? Help]  [💡 Hint]  [📊 Schema]                    │   │
│  │                                                     │   │
│  │ Your Query:                                         │   │
│  │ ┌─────────────────────────────────────────────────┐ │   │
│  │ │ SELECT CustomerID, Code                         │ │   │
│  │ │ FROM CodeLog                                    │ │   │
│  │ │ WHERE Status = 'Missing'                        │ │   │
│  │ │                                                 │ │   │
│  │ │                                                 │ │   │
│  │ └─────────────────────────────────────────────────┘ │   │
│  │                                                     │   │
│  │ [SUBMIT QUERY] [CLEAR] [Copy from earlier]          │   │
│  │                                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                            │
│  Agent Responses:                                          │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ QUERY TUTOR HINTS                                   │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │                                                     │   │
│  │ Q: What tables contain the information we need?     │   │
│  │                                                     │   │
│  │ A: The CodeLog table contains code records with     │   │
│  │    their status. The Customers table has customer   │   │
│  │    information if needed.                           │   │
│  │                                                     │   │
│  │ Ready for next hint? [Hint Level: 1/6]  [MORE]      │   │
│  │                                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                            │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ DATABASE SCHEMA                                     │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │                                                     │   │
│  │ CodeLog Table:                                      │   │
│  │ - CodeID (unique identifier)                        │   │
│  │ - CustomerID (which customer)                       │   │
│  │ - Code (the code value)                             │   │
│  │ - Status (Missing, Active, Closed)                  │   │
│  │ - CreatedDate (when it was entered)                 │   │
│  │                                                     │   │
│  │ [View full schema] [Ask about column]               │   │
│  │                                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

#### Key Elements

**Header Section:**
```
PURPOSE: Situate student in case and tier
DESIGN:
├─ Case title: "The Missing Code"
├─ Tier badge: "Junior Data Analyst"
├─ Progress indicator: "Step 1 of 3"
├─ Timer: "12:34 / 15 min"
└─ Navigation: Back button, tier info

INTERACTIVE ELEMENTS:
- Click timer: Show case time estimate details
- Click step: Show investigation map
- Click tier badge: Show tier requirements
```

**Case Narrative Panel:**
```
PURPOSE: Set investigation context and tone
DESIGN:
├─ Professional, investigative language (not "Find the bug!")
├─ Clear investigation goal
├─ Available tables listed
├─ 2-3 paragraphs max (keep focused)
└─ Available schema reference

EXAMPLE (Tier 1):
"You're a Junior Data Analyst investigating a customer 
complaint. A code was entered but never recorded in the 
system. Find all missing codes from the CodeLog table."

EXAMPLE (Tier 4):
"As a Data Detective, you're investigating a complex pattern 
of inconsistencies. The CodeLog table shows codes, but 
there's a deeper issue. Your investigation should reveal 
the underlying contradiction."
```

**Question Display:**
```
PURPOSE: Show current investigation step
DESIGN:
├─ Clear question phrasing
├─ Links to help resources (Hint, Schema)
├─ Focuses student on specific task
└─ Builds on previous step (if applicable)

TIER ADAPTATION:
Tier 1: "Which customer codes have Status = 'Missing'?"
Tier 3: "What data quality issues can you identify in 
      the CodeLog table? How would you verify them?"
Tier 5: "What multiple interpretations of this data are 
         possible? What would you recommend strategically?"
```

**Query Editor:**
```
PURPOSE: Enable SQL query writing
DESIGN:
├─ Syntax-highlighted text area
├─ Line numbers
├─ Monospace font (SQL standard)
├─ Auto-indent support
├─ Basic formatting (if applicable)
└─ Clear visual boundary

FEATURES:
- Syntax highlighting for SQL keywords
- Line numbers for error reference
- Copy/paste support
- Clear button to reset
- Option to load prior queries
- Character count or size indicator

HEIGHT: 200-300px (enough to see queries)
```

**Query Editor Controls:**
```
PURPOSE: Submit, manage, and reference queries
DESIGN:
├─ [SUBMIT QUERY] - Primary action (prominent)
├─ [CLEAR] - Secondary action
└─ [View prior attempts] - Tertiary action

STATES:
- Submit button: Active when query present
- Disabled if query is empty
- Loading state while processing
- Success/error state after submission
```

**Query Tutor Panel:**
```
PURPOSE: Display agent guidance
DESIGN:
├─ Label: "QUERY TUTOR HINTS"
├─ Current hint or question
├─ Escalation level indicator: "Level 1/6"
├─ [MORE] button for next level
└─ Encouraging tone

DISPLAY PATTERNS:
- Question at Level 1: "What tables contain...?"
- Hint at Level 3: "You might use SELECT..."
- Partial answer at Level 5: "SELECT [...] FROM [table] WHERE..."
- Full answer at Level 6: "SELECT CustomerID..."

INTERACTION:
- [MORE] button: Request next hint level
- Auto-escalate if stuck (configurable)
- Clear history button (optional)
```

**Database Schema Panel:**
```
PURPOSE: Provide schema information on demand
DESIGN:
├─ Label: "DATABASE SCHEMA"
├─ Relevant table descriptions
├─ Key columns listed
├─ Data type and constraints
└─ Examples or notes

DISPLAY:
- Show only relevant tables for current question
- Expandable/collapsible sections
- [View full schema] link
- [Ask about column] action

INTERACTION:
- Click table: Expand to show columns
- Click column: Show details and examples
- Search for specific table/column
```

**Evidence/Timeline Panel (Optional):**
```
PURPOSE: Display case evidence (if applicable)
DESIGN:
├─ Timeline view or evidence grid
├─ Key facts from investigation
├─ Data quality issues
└─ Relevant findings

DISPLAY:
- Text or table format
- Highlight key information
- Reference to query results (if applicable)
- Notes about contradictions
```

---

### Screen 4: Query Results Screen

#### Purpose
```
Show query results and evaluation
Provide feedback (correct/incorrect)
Display suggestions for next step
```

#### Layout Structure (Success Path)

```
┌────────────────────────────────────────────────────────────┐
│  DataQuest: SQL Detective     [?]  [Tier] [←Back]          │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  ✅ CORRECT! Excellent Query!                              │
│  ──────────────────────────────────────────────────────────│
│                                                            │
│  Your Query:                                               │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ SELECT CustomerID, Code                              │  │
│  │ FROM CodeLog                                         │  │
│  │ WHERE Status = 'Missing'                             │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                            │
│  Results (23 rows):                                        │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ CustomerID  Code                                     │  │
│  │ ──────────────────────                               │  │
│  │ 101         ABC123                                   │  │
│  │ 102         DEF456                                   │  │
│  │ 103         GHI789                                   │  │
│  │ ...         ...                                      │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                            │
│  ✅ You identified all 23 missing codes!                   │
│                                                            │
│  What you did right:                                       │
│  • Selected relevant columns                               │
│  • Filtered for correct status                             │
│  • Retrieved all matching records                          │
│                                                            │
│  Ready for next question?                                  │
│                                                            │
│[NEXT QUESTION] [REVIEW QUERY] [CONTINUE INVESTIGATION]     │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

#### Layout Structure (Incorrect Path)

```
┌────────────────────────────────────────────────────────────┐
│  DataQuest: SQL Detective              [?]  [Tier] [←Back] │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  ⚠️ Query executed, but result doesn't match expectations  │
│  ──────────────────────────────────────────────────────────│
│                                                            │
│  Your Query:                                               │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ SELECT *                                             │  │
│  │ FROM CodeLog                                         │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                            │
│  Results (1,247 rows returned)                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ [Showing first 20 of 1,247 rows]                     │  │
│  │ CodeID  CustomerID  Code  Status  CreatedDate        │  │
│  │ ──────────────────────────────────────────────────   │  │
│  │ 1     101        ABC123  Active  2025-01-01          │  │
│  │ 2       102   DEF456  Active  2025-01-01             │  │
│  │ ...     ...  ...     ...     ...                     │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                            │
│  Hmm, let me ask: Does your result answer the question?    │
│                                                            │
│  Query Tutor Analysis:                                     │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ Your query returns 1,247 rows, but we're looking     │  │
│  │ for just the missing codes. Let's think about it:    │  │
│  │                                                      │  │
│  │ How would you filter to show ONLY the ones with      │  │
│  │ Status = 'Missing'?                                  │  │
│  │                                                      │  │
│  │ [Hint Level: 2/6]  [MORE HELP]                       │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                            │
│  [TRY AGAIN] [CLEAR QUERY] [PREVIOUS ATTEMPT]              │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

#### Key Elements

**Result Header:**
```
PURPOSE: Immediately show correctness
DESIGN:
- ✅ CORRECT! (with celebratory tone)
- ⚠️ Not quite right (encouraging, not discouraging)
- ❌ Error message (if syntax error or database issue)

TONE:
- Success: "Excellent Query!", "Perfect!"
- Near-correct: "You're on the right track..."
- Incorrect: "Let me ask... does your result..."
- Error: "SQL error at line X: ..."
```

**Query Display (Read-only):**
```
PURPOSE: Show what student submitted
DESIGN:
- Syntax-highlighted
- Line numbers
- Read-only display
- Copy button (optional)
- Clear boundary

USE CASE:
Students can see exactly what ran
Helps debug from Query Tutor feedback
Reference for next attempt
```

**Results Table:**
```
PURPOSE: Show query results
DESIGN:
- Column headers
- Data rows (max 20-50 visible, paginated if more)
- Result count ("23 rows returned")
- Scrollable/pageable if large

DISPLAY:
- Monospace font for data
- Clear column separation
- Null values indicated clearly
- Truncate long text (with expand option)
```

**Feedback Section:**
```
PURPOSE: Guide student learning
DESIGN:

SUCCESS:
- "What you did right:"
  ├─ Identified correct tables
  ├─ Used proper WHERE logic
  └─ Retrieved complete results
- Celebratory message
- Next question or investigation step

INCORRECT:
- Query Tutor explanation
- Socratic question about result
- Hint escalation option
- "Try Again" button

ERROR:
- Error message with line reference
- Suggestion for fix
- Link to syntax help
```

**Action Buttons:**
```
PURPOSE: Enable next action
DESIGN:

SUCCESS:
- [NEXT QUESTION] - Primary action
- [REVIEW QUERY] - Show explanation (optional)
- [CONTINUE INVESTIGATION] - Skip to next step

INCORRECT:
- [TRY AGAIN] - Return to editor
- [CLEAR QUERY] - Start fresh
- [GET MORE HELP] - Escalate hint level
- [PREVIOUS ATTEMPT] - Review prior query

ERROR:
- [BACK TO EDITOR] - Return to editor
- [SYNTAX HELP] - Show SQL syntax help
- [CLEAR QUERY] - Start fresh
```

---

### Screen 5: Case Completion Screen

#### Purpose
```
Celebrate completion
Display tier advancement opportunity
Show achievement badge
Suggest next case
```

#### Layout Structure

```
┌──────────────────────────────────────────────────────────────┐
│  DataQuest: SQL Detective                [?]  [Tier] [←Back] │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  🎉 CASE COMPLETE! Excellent Investigation!                  │
│  ════════════════════════════════════════════════════════════│
│                                                              │
│  Case: The Missing Code      ⏱ 8:32 / 15 min                │
│  Junior Data Analyst              ✓ SOLVED                   │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐  │
│  │ INVESTIGATION SUMMARY                                  │  │
│  ├────────────────────────────────────────────────────────┤  │
│  │                                                        │  │
│  │ ✓ Found 23 missing codes                               │  │
│  │ ✓ Identified root cause (Status = 'Missing')           │  │
│  │ ✓ Verified result accuracy                             │  │
│  │                                                        │  │
│  │ Key SQL Skills Demonstrated:                           │  │
│  │ • SELECT with specific columns                         │  │
│  │ • WHERE clause with conditions                         │  │
│  │ • Filtering data effectively                           │  │
│  │                                                        │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐  │
│  │ TIER PROGRESS                                          │  │
│  ├────────────────────────────────────────────────────────┤  │
│  │                                                        │  │
│  │ You've completed 2 of 3 Junior Data Analyst cases      │  │
│  │                                                        │  │
│  │ [██████░░░░░░] 66% complete                            │  │
│  │                                                        │  │
│  │ 1 more case to unlock: Senior Data Analyst             │  │
│  │ • Gain specialization skills with JOINs                │  │
│  │ • Work with multiple data sources                      │  │
│  │ • Resolve data contradictions                          │  │
│  │                                                        │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                              │
│  [NEXT CASE] [BACK TO CASES] [VIEW STATISTICS]               │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

#### Key Elements

**Celebration Header:**
```
PURPOSE: Celebrate achievement
DESIGN:
- 🎉 Emoji for celebration
- Congratulatory message
- Professional tone (not gamified)
- Case title and result

MESSAGING:
"CASE COMPLETE! Excellent Investigation!"
"You've solved [case name]"
"Time: 8:32 (well under 15 min estimate)"
```

**Investigation Summary:**
```
PURPOSE: Reflect on learning accomplished
DESIGN:
- ✓ Accomplishments listed
- ✓ SQL skills demonstrated
- ✓ Concepts mastered
- Brief reflection on investigation

EXAMPLE:
"✓ Found 23 missing codes
✓ Identified root cause (Status = 'Missing')
✓ Verified result accuracy

Key SQL Skills Demonstrated:
• SELECT with specific columns
• WHERE clause with conditions
• Filtering data effectively"
```

**Tier Progress Display:**
```
PURPOSE: Show advancement toward next tier
DESIGN:
- Progress bar (visual percentage)
- Counter: "2 of 3 cases complete"
- Clear unlock criteria
- Next tier preview

MESSAGING:
"1 more case to unlock: Senior Data Analyst"
[Show next tier benefits]
[Show next tier case preview]
```

**Action Buttons:**
```
PURPOSE: Enable next action
DESIGN:
- [NEXT CASE] - Primary action (advance through tier)
- [BACK TO CASES] - Return to case selection
- [VIEW STATISTICS] - Show stats (optional, Phase 2+)
```

---

### Screen 6: Phase 2 Dashboard (Progress Tracking)

#### Purpose
```
Show career progression (Phase 2+)
Display achievements and badges
Enable case recommendations
Show analytics (Phase 3+)
```

#### Layout Structure (Phase 2)

```
┌────────────────────────────────────────────────────────────────┐
│  DataQuest: SQL Detective     [📊 Dashboard] [?] [⚙️] [👤]    │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  Welcome back, Data Detective!                                 │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ YOUR CAREER PROGRESSION                                  │  │
│  │                                                          │  │
│  │ ✓ Junior Data Analyst      (Bronze ◆)  Dec 1             │  │
│  │ ✓ Senior Data Analyst  (Silver ◆)Dec 5                   │  │
│  │ ● Data Inspector    (Gold ◆)    In Progress              │  │
│  │   2 of 5 cases complete                                  │  │
│  │ ○ Data Detective           (Platinum ◆) Locked           │  │
│  │ ○ Director of Data         (Diamond ◆) Locked            │  │
│  │   Integrity                                              │  │
│  │                                                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ ACHIEVEMENTS                                             │  │
│  │ Bronze ◆    Silver ◆    Gold ◆    [Platinum ◆]           │  │
│  │      Locked    [Diamond ◆]                               │  │
│  │ Locked                                                   │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ CURRENT TIER: Data Inspector                             │  │
│  ├──────────────────────────────────────────────────────────┤  │
│  │ Progress: [██████░░░░░░░░░░] 40% complete                │  │
│  │ 2 of 5 cases complete                                    │  │
│  │ 3 more cases to unlock Data Detective                    │  │
│  │                                                          │  │
│  │ [CONTINUE CURRENT TIER] [VIEW ALL CASES]                 │  │
│  │                                                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ RECOMMENDED NEXT CASE                                    │  │
│  ├──────────────────────────────────────────────────────────┤  │
│  │                                                          │  │
│  │ Quality Assurance Investigation (Data Inspector)         │  │
│  │ Estimated time: 20-30 minutes                            │  │
│  │ Difficulty: Moderate (2-3 contradictions)                │  │
│  │ Focus: Multi-table queries and pattern detection         │  │
│  │                                                          │  │
│  │ [START CASE]                                             │  │
│  │                                                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ LEARNING STATISTICS (Phase 3+)                           │  │
│  │ Total time invested: 3 hours 27 minutes                  │  │
│  │ Cases completed: 7                                       │  │
│  │ Average query attempts: 2.3 per case                     │  │
│  │ SQL skills: Intermediate (improving)                     │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

---

## 🎨 Design Principles

### 1. Career Progression Over Gamification

```
✅ DO:
- "Your Role: Senior Data Analyst"
- "Advance to Data Inspector"
- Professional tier names
- Career-focused language

❌ DON'T:
- "Level 2 Unlocked!"
- "Achievement: 50 XP earned!"
- "Streak: 7 days!"
- Game-centric language
```

### 2. Clarity Over Complexity

```
✅ DO:
- Clear SQL syntax highlighting
- Simple, professional layout
- One question at a time
- Obvious affordances (buttons, links)

❌ DON'T:
- Cluttered interface
- Too many options at once
- Confusing navigation
- Hidden or unclear actions
```

### 3. Support Over Judgment

```
✅ DO:
- "Let me ask..." (Socratic)
- "You're thinking correctly..."
- "That's an interesting approach..."
- Encouraging tone always

❌ DON'T:
- "That's wrong!"
- "Obviously..."
- "You should know this..."
- Dismissive language
```

### 4. Context Over Isolation

```
✅ DO:
- Show tier and progress always
- Connect to case investigation
- Reference prior queries
- Show time and estimate

❌ DON'T:
- Isolated query editor (no context)
- No tier reference
- Generic, decontextualized hints
- Time pressure without estimate
```

---

## 📱 Responsive Design Guidelines

### Breakpoints

```
DESKTOP (1200px+):
- Full multi-panel layout
- Side-by-side agent panels
- Large query editor
- All information visible

TABLET (768px - 1199px):
- Single column with tabs
- Stacked agent panels
- Medium query editor
- Scrollable content

MOBILE (< 768px):
- Single column layout (Phase 3+, if supported)
- Modal dialogs for schema/hints
- Full-width query editor
- Bottom navigation
```

### Query Editor Adaptation

```
DESKTOP:
- 300px+ height
- Side-by-side with results
- Syntax highlighting full

TABLET:
- 250px height
- Above/below results (tabbed)
- Syntax highlighting simplified

MOBILE:
- Keyboard-aware layout
- Full-width query box
- Results below (scrollable)
```

---

## 🔐 Accessibility Standards

### WCAG 2.1 Level AA Compliance

```
✅ COLOR:
- Not relying on color alone for meaning
- Sufficient contrast ratios (4.5:1)
- Color-blind friendly palette

✅ TEXT:
- Font size: 14px minimum (body text)
- Line height: 1.5x minimum
- Adequate word spacing

✅ INTERACTION:
- Keyboard navigation
- Focus indicators visible
- Skip to main content link
- Tab order logical

✅ SEMANTICS:
- Proper heading hierarchy
- Form labels associated
- Images with alt text
- ARIA labels where needed
```

---

## 🧪 Testing and Validation

### Test Scenarios

**Test 1: First-Time User (Tier 1)**
```
User lands on home screen
- Can understand tier system
- Can see current tier (Junior Data Analyst)
- Can see progress (0/3 cases)
- Can click START A CASE
- Case selection shows available cases
- Can start a case
```

**Test 2: Case Execution**
```
User in active case
- Case narrative is clear
- Question is answerable
- Query editor is usable
- Can access Query Tutor hints
- Can access Database Schema
- Can submit query
- Results display correctly
```

**Test 3: Tier Advancement (Phase 2)**
```
User completes tier
- Case completion shows progress
- Progress bar updates
- Shows "1 more case to unlock next tier"
- After completing tier:
  - Promotion message displays
  - New badge shown
  - Next tier unlocked
  - Cases become available
```

**Test 4: Responsive Design**
```
Desktop (1200px+): Full layout
Tablet (768px): Tabbed layout
Mobile (< 768px): Single column (if supported)
```

### Performance Requirements

```
PAGE LOAD: < 2 seconds
INTERACTION: < 100ms response time
QUERY SUBMISSION: < 5 seconds (with feedback)
NAVIGATION: Instant (< 500ms transitions)
```

---

## 📊 Information Hierarchy

### Visual Hierarchy

```
PRIMARY (Most Important):
1. Case narrative/question
2. Query editor (student action)
3. Submit button

SECONDARY:
4. Query results
5. Agent guidance

TERTIARY:
6. Schema reference
7. Progress indicators
8. Time tracking
```

### Content Hierarchy

```
MOST CRITICAL:
- Case question (what to solve)
- Query editor (how to solve it)
- Submit button (take action)

VERY IMPORTANT:
- Query results (feedback)
- Agent hints (guidance)
- Query errors (problem indication)

IMPORTANT:
- Case narrative (context)
- Schema (reference)
- Progress (motivation)

NICE TO HAVE:
- Time tracking
- Statistics
- Achievement badges
```

---

## 📚 Related Documents

**Core Standards:**
- `DataQuest-Tier-System-Official-Design-Guideline.md`
- `Query-Tutor-Agent-Implementation-Specification.md`
- `Database-Agent-Implementation-Specification.md`

**Integration Points:**
- `Case-Lifecycle-and-State-Management.md`
- `API-and-Service-Layer-Architecture.md`

**Case Design:**
- `Case-Design-Template-and-Examples.md`

**Testing:**
- `Testing-and-QA-Implementation-Guide.md`

---

## ✅ Implementation Checklist

### Design Phase

```
[ ] Create low-fidelity wireframes
[ ] Validate information hierarchy
[ ] Test responsive breakpoints
[ ] Plan color scheme (accessibility-focused)
[ ] Define typography system
[ ] Create component library
```

### High-Fidelity Design

```
[ ] Design all screen states
[ ] Create interactive prototypes
[ ] Validate with accessibility tools
[ ] Test with users (sample students)
[ ] Iterate based on feedback
```

### Development Handoff

```
[ ] Provide design specifications
[ ] Document component interactions
[ ] Create design system documentation
[ ] Prepare visual assets
[ ] Define CSS standards
```

### Quality Assurance

```
[ ] Test on multiple browsers
[ ] Test responsive design (all breakpoints)
[ ] Validate accessibility (WCAG 2.1 AA)
[ ] Test keyboard navigation
[ ] Test touch interactions
[ ] Validate performance metrics
```

---

## 🎓 Conclusion

The UI/UX Design is where DataQuest's pedagogical mission becomes reality. This specification ensures that every interface element—from tier badges to agent responses—reinforces the core principle: students are progressing through authentic career roles by solving real SQL challenges, not playing a game.

**Key Success Factors:**

1. **Career focus** - Professional language and progression
2. **Clarity** - Every element serves a purpose
3. **Support** - Encouragement at every interaction
4. **Context** - Always show tier, progress, time
5. **Accessibility** - WCAG 2.1 AA compliance
6. **Responsiveness** - Works on all devices
7. **Agent coordination** - Seamless Query Tutor + Database Agent

---

**IMPLEMENTATION SPECIFICATION COMPLETE:** December 3, 2025  
**Status:** ✅ **READY FOR DESIGN & DEVELOPMENT**

