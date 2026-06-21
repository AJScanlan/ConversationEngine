---
name: new-adr
description: Scaffold the next numbered Architecture Decision Record in Docs/ADR
disable-model-invocation: true
---

## Usage

```
/new-adr <title>
```

Example: `/new-adr sqlite as event store`

The title becomes the file slug — spaces are fine, they'll be hyphenated automatically.

---

## Instructions

Follow these steps exactly when invoked:

### 1. Determine the next ADR number

Run:
```bash
ls Docs/ADR/ 2>/dev/null | sort | tail -1
```

Parse the leading 4-digit number from the result and add 1. If `Docs/ADR/` is empty or doesn't exist, start at `0001`. Zero-pad to 4 digits (e.g. `0003`).

### 2. Derive the filename

Slugify the title argument: lowercase, replace spaces and underscores with hyphens, drop punctuation.

Filename pattern: `{number}-{slug}.md`
Example: `0003-sqlite-as-event-store.md`
Full path: `Docs/ADR/{filename}`

### 3. Create the directory if needed

```bash
mkdir -p Docs/ADR
```

### 4. Write the file

Create `Docs/ADR/{filename}` with this exact template. Fill in `{number}`, `{Title}` (title-cased from the arg), and today's date. Leave all comment blocks and body sections **blank for the user to complete** — do not infer or pre-fill content.

```markdown
# ADR {number}: {Title}

**Date**: {YYYY-MM-DD}  
**Status**: Proposed

---

## Context

<!-- What situation or problem prompted this decision?
     What forces are at play — technical, architectural, or educational?
     Reference the relevant learning phase from PURPOSE.md if applicable. -->

## Decision

<!-- State the decision plainly and directly. One or two sentences. -->

## Rationale

<!-- WHY this over the alternatives?
     This section matters most — the reasoning outlasts the decision.
     Consider: what distributed systems concept does this support?
     How does it align with event sourcing, local-first, or derived state principles? -->

## Consequences

### Positive
- 

### Negative / Trade-offs
- 

## Alternatives Considered

| Alternative | Why Rejected |
|---|---|
|  |  |

## Related ADRs

<!-- Reference sibling or upstream decisions. Example: [[0001-event-log-as-source-of-truth]] -->

---

*Blog angle: <!-- One sentence on what makes this decision interesting to write about. -->*
```

### 5. Confirm

Print the created file path so the user knows where to find it. Do not summarize or interpret the template sections.