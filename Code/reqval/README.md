# ARP4754A Requirements Validation System  v2

A **multi-agent AI system** built with **LangChain + LangGraph + GPT-4o** that validates
aerospace requirements against **ARP4754A** *(Guidelines for Development of Civil Aircraft
and Systems)*, produces **corrected rewrites** for every violation, and grounds its analysis
in your project's own documents via a **RAG knowledge base**.

---

## What's new in v2

| Feature | Detail |
|---------|--------|
| **RAG knowledge base** | Ingest PDFs, DOCX, TXT, MD files from your project (FHA, PSSA, ICD, SOW, System Description…). Each validation agent queries the store to use your actual system vocabulary, numeric values, and architecture. |
| **Recommender Agent** (Agent 7) | For every non-compliant requirement: produces a corrected rewrite using project terminology, split compound requirements, adds units/tolerances, and adds a `[Verification: T/A/I/D]` tag. Explains every change with the ARP4754A rule it fixes. |
| **Vocabulary grounding** | No more generic placeholders. If your FHA says "loss of terrain awareness (FC-TA-001) is DAL-B", the agents know that and will flag a requirement that says "the system shall be reliable" as missing the specific failure condition reference. |

---

## Architecture

```
                    ┌──────────────────────────────────────────────────┐
                    │            LANGGRAPH WORKFLOW GRAPH               │
                    └──────────────────────────────────────────────────┘

  ┌──────────────┐       ┌──────────────────────────────────┐
  │  System Docs │──────▶│   RAG Engine (ChromaDB)          │
  │  PDF/DOCX/   │       │   OpenAI text-embedding-3-small  │
  │  TXT/MD      │       └────────────────┬─────────────────┘
  └──────────────┘                        │ queried by every agent
                                          │
  ┌──────────────┐                        ▼
  │  Raw Reqs    │──▶ [1] ORCHESTRATOR  ──────── Parses reqs, builds system context
  │  (text/file) │         │
  └──────────────┘         ▼
                    [2] COMPLETENESS  §5.3  ─── IDs, criteria, DAL refs, sources
                         │
                         ▼
                    [3] CONSISTENCY   §5.4  ─── Contradictions, terminology, DAL align
                         │
                         ▼
                    [4] VERIFIABILITY §5.5  ─── Measurability, T/A/I/D methods
                         │
                         ▼
                    [5] TRACEABILITY  §5.6  ─── Upstream sources, FHA linkage, HW/SW
                         │
                         ▼
                    [6] CORRECTNESS   §5.2  ─── "shall", compound reqs, abstraction
                         │
                         ▼
                    [7] RECOMMENDER   ◀──── NEW: corrected rewrites per requirement
                         │                       grounded in RAG vocabulary & values
                         ▼
                    [8] REPORTER      ─── Final ARP4754A compliance report
                         │
                         ▼
                      PASS / CONDITIONAL PASS / FAIL
```

---

## Installation

```bash
# 1. Clone / copy the project
cd arp4754_validator/

# 2. Create a virtual environment
python -m venv venv
source venv/bin/activate        # Linux/macOS
venv\Scripts\activate           # Windows

# 3. Install dependencies
pip install -r requirements.txt

# 4. Configure your OpenAI API key
cp .env.example .env
# Edit .env → OPENAI_API_KEY=sk-...
```

---

## Usage

### Ingest system documents + validate

```bash
python main.py --docs ./system_docs/ --file requirements.txt
```

The `system_docs/` folder can contain any mix of:
- **System Description / Concept of Operations** (TXT, DOCX, PDF)
- **Functional Hazard Assessment (FHA)** — failure conditions, DAL levels
- **Interface Control Document (ICD)** — data formats, protocols, timing
- **System Safety Assessment (PSSA/SSA)** — probability targets
- **Glossary / Acronym List**
- Any other project reference document

### Validate with existing vector store (no re-ingestion)

```bash
python main.py --file requirements.txt
```

### Add new documents to the store

```bash
python main.py --docs ./new_docs/ --file requirements.txt
```

### Reset the store and rebuild from scratch

```bash
python main.py --docs ./system_docs/ --clear-store --file requirements.txt
```

### Check what documents are currently indexed

```bash
python main.py --list-docs
```

### Demo mode (built-in navigation system requirements)

```bash
python main.py --demo
```

### Save report + verbose intermediate output

```bash
python main.py --docs ./docs/ --file reqs.txt --output report.txt --verbose
```

### Programmatic API

```python
from main import run_validation

report = run_validation(
    requirements_text=open("requirements.txt").read(),
    docs_folder="./system_docs/",   # optional — omit to reuse existing store
    save_to="report.txt"            # optional
)
print(report)
```

---

## What the Recommender Agent produces

For each non-compliant requirement you get a block like:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
REQUIREMENT: SYS-NAV-002
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ORIGINAL:
  The system should display navigation data to the pilot as fast as possible.

VIOLATIONS SUMMARY:
  • [REQ-R03] Uses "should" instead of "shall" — not a mandatory statement
  • [REQ-V02] "as fast as possible" is not a quantifiable performance threshold
  • [REQ-C02] Ambiguous terms: "fast", "as fast as possible"

CORRECTED REWRITE:
  SYS-NAV-002: The navigation display shall update at a minimum rate of 5 Hz
  with a maximum end-to-end latency of 200 ms from sensor data to display
  refresh, under all operational phases defined in CONOPS §3.2.
  [Verification: T]

CHANGES EXPLAINED:
  • "should" → "shall"          (REQ-R03: mandatory statements use "shall")
  • "as fast as possible" →     (REQ-V02: replaced with measurable threshold)
    "5 Hz / 200 ms latency"
  • "pilot" → "navigation display" (REQ-R01: state the system behaviour, not the observer)

VOCABULARY NOTE (RAG):
  • "5 Hz" and "200 ms" taken from ICD-NAV §4.3 display refresh requirements
  • "CONOPS §3.2" referenced from the System Description document
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## ARP4754A Rules Covered

| Section | Area | Key checks |
|---------|------|-----------|
| §5.2 | Correctness | "shall" usage, compound reqs, HOW vs WHAT, abstraction level |
| §5.3 | Completeness | Unique IDs, acceptance criteria, DAL refs, source/rationale, interface definitions |
| §5.4 | Consistency | Contradictions, terminology, unit conflicts, DAL alignment |
| §5.5 | Verifiability | Quantifiable thresholds, T/A/I/D method mapping, measurability |
| §5.6 | Traceability | Upstream source, FHA linkage, derived req. justification, HW/SW allocation |

---

## File Structure

```
arp4754_validator/
├── main.py                    # CLI entry point (--docs, --file, --demo, etc.)
├── agents.py                  # 8 LangChain/LangGraph agents including Recommender
├── rag.py                     # RAG engine: ingestion, embedding, retrieval (ChromaDB)
├── arp4754_rules.py           # ARP4754A rules knowledge base
├── requirements.txt           # Python dependencies
├── .env.example               # Environment template
├── example_requirements.txt   # Sample aerospace requirements for testing
└── README.md                  # This file

# Created at runtime:
chroma_db/                     # Persistent ChromaDB vector store (auto-created)
system_docs/                   # Put your project documents here (user-provided)
```

---

## Optional: LangSmith Tracing

```bash
# Add to .env
LANGCHAIN_TRACING_V2=true
LANGCHAIN_API_KEY=your-langsmith-key
LANGCHAIN_PROJECT=arp4754-validator
```

This gives you a visual trace of every agent call and RAG retrieval in the LangSmith UI.
