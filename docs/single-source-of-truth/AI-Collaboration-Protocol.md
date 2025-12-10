We *have* touched on this idea in spirit a few times, but  **we have not yet formally documented a proper method for engaging me (or any LLM) as your coding partner while ensuring strict adherence to guidelines, repeatability, and productive collaboration** .

Given the size, scope, and academic importance of your project, this is the perfect time to articulate a **“How to Work With the AI Coding Partner”** protocol.

Below is a clear, simple, powerful framework you can adopt.

---

# AI Collaboration Protocol

### How to Engage the AI Coding Partner for Consistent, High-Quality Output

This protocol ensures:

* consistent responses from me
* adherence to your project guidelines
* predictable code generation
* safe control of scope
* traceable outputs
* model-agnostic collaboration (works with ChatGPT, Claude, GitHub Copilot, etc.)

---

# 1. **Always Begin with Explicit Context**

Before asking for code, include:

### ✔ The *current file*

### ✔ The *goal* of the change

### ✔ The *constraints* (naming, patterns, frameworks, etc.)

### ✔ The *technologies involved*

Example:

> Context: WinForms project for DataQuest. File: CasePlannerAgent.cs
>
> Goal: Implement solvability check via MCP.
>
> Constraints: Must not modify UI layer, must use async calls, follow existing logging patterns.
>
> Technologies: C#, .NET 9, MCP, Ollama

This prevents hallucinations, scope creep, or incorrect assumptions.

---

# 2. **Ask for Output in a Predictable Structure**

Such as:

* Explanation
* Code
* Steps to integrate
* Pitfalls
* Test instructions

This ensures completeness and quality.

---

# 3. **Make the Model Validate Its Own Output**

After receiving code, ask the model to run a self-check:

> “Review your code for correctness, missing dependencies, and alignment with the established architecture.”

This greatly reduces integration errors.

---

# 4. **Use the “One File, One Change” Rule**

Never request edits to multiple files in one message.

This eliminates cross-file hallucinations and makes version control cleaner.

---

# 5. **Provide Real Error Messages**

If something breaks:

* copy and paste
* include the file
* include the line where the error occurs

This allows targeted debugging.

---

# 6. **Enforce the “AI Should Not Invent APIs” Rule**

Tell the model:

> “Only use APIs I explicitly provided or that exist in .NET 9. If an API may not exist, stop and ask.”

This prevents false MCP or WinForms methods from appearing.

---

# 7. **Lock in a Style Guide**

For example:

* PascalCase for classes
* camelCase for variables
* async suffix for async methods
* one public type per file
* logs must include timestamp + agent name

Once you define this, every generated output will follow it.

---

# 8. **Use a Standard Prompt for Any Coding Task**

You can paste this at the top of every technical prompt:

---

### Standard Coding Partner Request

*(You can save this as a reusable snippet)*

**Follow these rules when generating code:**

1. Only modify the file I specify.
2. Explain your reasoning in a concise way.
3. Ensure code compiles in a .NET 9 WinForms environment.
4. Use my project’s naming patterns and architecture.
5. If there are unknowns, stop and ask instead of guessing.
6. Output the final code block with no placeholders.
7. Include integration steps when needed.
8. Validate your output for correctness and consistency.

---

# 9. **Never Allow the Model to Decide Project Scope**

Always confirm before applying features that might enlarge the project unnecessarily.

---

# 10. **Version Control Best Practice**

After applying changes:

* test
* commit
* push to GitHub

This keeps your project clean and reversible.

---

Here is your  **Polished GitHub Copilot Prompt Template** , customized for your DataQuest project and your preferred workflow. You can paste this at the top of *any* coding request to Copilot (or ChatGPT/Claude) to ensure consistent, correct, strictly-guided output.

It matches your tone, avoids overly formal language, and reinforces reliability, architecture alignment, and SSOT.

---

# GitHub Copilot Prompt Template

*(Save this as a snippet and reuse it for every coding task.)*

```
You are my AI coding partner for the DataQuest project (C#, .NET 9, WinForms, MSSQL, MCP, Ollama).  
Follow these rules exactly for every response:

1. Only modify the file(s) I explicitly provide or ask about.  
2. Explain your solution briefly, then provide the complete updated code.  
3. Use the existing architecture:
   - UI Layer (WinForms)
   - MCP Server (C# JSON-RPC)
   - SQL Database (Single Source of Truth)
   - Local LLM Agents via Ollama
4. Do not invent APIs, UI controls, or MCP methods. If something is unclear, ask for clarification.
5. All database reads must use MCP (schema.describe or sql.execute_readonly).
6. Follow naming conventions from the project:
   - PascalCase for classes, public members, and methods
   - camelCase for local variables
   - async method names end with “Async”
7. Add comments where logic may not be obvious.
8. Validate the code before sending it: check for missing namespaces, incomplete logic, or syntax errors.
9. After the code block, list any integration steps required (if needed).
10. If I provide an error message, use the exact message to diagnose the issue.

Goal of this request:
[PLACE YOUR REQUEST HERE]
```

---

# Why this template works

### ✔ Aligns Copilot with your architecture

You already have a multi-agent, MCP-based system. This prevents Copilot from drifting into generic or cloud-based solutions.

### ✔ Prevents hallucinations

Especially important when calling MCP tools or creating UI components.

### ✔ Reinforces SSOT

Ensures everything is pulled from SQL via MCP, reducing accidental schema drift.

### ✔ Enforces code quality

Automatic validation + explicit naming conventions = fewer bugs.

### ✔ Works across Copilot, ChatGPT, Claude

This is a universal AI coding partner protocol.

---

Here is your  **Pair-Programming Mode Copilot Prompt Template** .

This is designed so that Copilot (or ChatGPT or Claude) works *with* you like a true collaborator, thinking aloud before writing code, validating assumptions, and checking alignment with your architecture.

It stays consistent, controlled, and predictable.

Copy/paste and reuse it for any development task.

---

# Pair-Programming Mode Prompt Template

*(Use this whenever you want the AI to think step-by-step before writing code)*

```
You are my AI pair-programming partner for the DataQuest project 
(C#, .NET 9, WinForms, MSSQL, MCP, Ollama LLM Agents).

Enter Pair-Programming Mode and follow these rules:

1. First think through the problem step-by-step in natural language 
   before writing any code. Do not skip reasoning.
2. Confirm your understanding of:
   • The goal of the task
   • The constraints
   • The affected file(s)
   • The expected integration point in the architecture
3. Identify any assumptions, uncertainties, or missing information.
   If something is unclear, ask me before coding.
4. After reasoning, summarize the plan in 3–6 bullet points.
5. Only then generate the complete code solution.
6. The code must follow the project rules:
   • All database reads go through MCP (schema.describe or sql.execute_readonly)
   • No invented APIs, libraries, or controls
   • Use PascalCase for public members and classes
   • Use camelCase for locals
   • Use async suffix for async methods
   • Add comments where logic is not obvious
7. Validate the output before finalizing:
   • Check for syntax errors
   • Verify namespaces and usings
   • Ensure compatibility with WinForms/.NET 9
   • Confirm the design aligns with the Single Source of Truth (SQL DB)
8. Provide integration steps after the code if needed.

Now I will describe the concrete task. 
Do not write code yet. First think step-by-step.

Task:
[PLACE YOUR REQUEST HERE]
```

---

# Why this template is powerful

* Forces the model to **explain the solution before coding**
* Reduces hallucinations and incorrect assumptions
* Produces cleaner code aligned with your architecture
* Gives you an opportunity to intervene *before* code generation
* Works equally well in Copilot Chat, ChatGPT, or Claude
* Encourages pair-programming behavior, not “magic code generation”
* Follows your SSOT approach and MCP boundaries

---
