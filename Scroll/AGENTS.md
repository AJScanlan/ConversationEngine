# AGENTS.md

Operating instructions for AI agents and contributors working in this repo.

For *why* this project exists — the thesis, guiding principles, architecture
vision, and phased roadmap — read **[PURPOSE.md](PURPOSE.md)**. This file does
not repeat that material; it covers *how to work* here.

---

## Current State (2026-06-21)

Stage 0: docs only. No `Package.swift`, no `Sources/`, no tests yet.
The "Repository Structure" below is aspirational, not present.

The first implementation step is Phase 1 in [PURPOSE.md](PURPOSE.md): an
in-memory `ChatEvent` model + reducer, packaged as a Swift package.

## Quick Start

```bash
# Once a Swift package exists:
swift build
swift test          # prefer SPM over Xcode for the core library
```

Until `Package.swift` exists there is nothing to build — start by creating the
package for Phase 1.

---

## How to Work Here

Optimize, in order, for: **Learning → Simplicity → Explainability → Incremental
progress** — before Features, Performance, Completeness, or Production readiness.

Act as a mentor and collaborator, not just an implementer. For large
architectural problems, do not jump straight to a complete implementation.
Instead:

1. Explain the problem.
2. Explain the tradeoffs.
3. Propose possible approaches.
4. Recommend the smallest reasonable implementation.
5. Leave room for exploration.

**Core rule when solving a problem:** prefer the simplest solution that *exposes*
the underlying problem over the sophisticated one that *hides* it.

> Good: "We replay all events on startup. This is slow. We should investigate snapshots."
>
> Bad: "I implemented snapshotting before replay performance became an issue."

The educational value comes from encountering architectural limits naturally, so
build incrementally and do not skip stages (see the roadmap in PURPOSE.md).

## Architectural Priorities

Order matters: **Correctness → Clarity → Testability → Simplicity → Performance.**

Introduce performance optimizations only after measurable evidence shows they are
needed.

## Event-Sourcing Bias

Prefer solutions compatible with immutable events, derived state, reducers,
replayability, and deterministic behavior. This does not mean event sourcing
everywhere — but justify alternative approaches explicitly. (Rationale:
[PURPOSE.md](PURPOSE.md), "Events First" and "State Is Derived".)

When introducing reconciliation logic, be explicit and do not hide it behind
opaque abstractions. State the assumptions:

- Identity assumptions.
- Ordering assumptions.
- Failure modes.
- Duplicate handling.

The reasoning is often more valuable than the implementation.

---

## Repository Structure

Aspirational target (nothing here exists yet — do not force the repo toward it
prematurely):

```
Sources/
    Core/
        Event.swift
        EventStore.swift
        Reducers/
    Persistence/
        SQLiteStore.swift
        SnapshotStore.swift
    Networking/
        REST/
        WebSocket/
    Sync/
        Reconciler.swift
    UI/
        TimelineView.swift
        MessageRow.swift

Tests/
Docs/
Blog/
```

## Code Quality Guidelines

**Prefer:** small types · explicit names · composition over inheritance · value
types where practical · deterministic behavior.

**Avoid (until complexity clearly justifies them):** global mutable state ·
hidden side effects · clever abstractions · excessive protocol hierarchies ·
dependency-injection frameworks.

## Layer Guidance

**SwiftUI** is a presentation layer. Keep business logic out of views.
Prefer `Core → Observable State → SwiftUI`; avoid `SwiftUI → Business Logic →
Networking`.

**Persistence** should favor transparency over efficiency early on: human-readable
storage, simple SQLite schemas, straightforward serialization. Avoid premature
indexing, complex caching, or multi-level persistence abstractions.

**Networking** — REST and WebSockets should eventually be modeled as event
producers. Look for opportunities to unify historical and live data under a common
abstraction rather than building separate state systems for each.

## Testing

Emphasize reducer correctness, replayability, determinism, reconciliation
behavior, and failure scenarios. Prefer test names that describe system behavior:

```
given_events_when_replayed_then_messages_are_reconstructed()   // good
testMessageManager()                                           // bad
```

## Documentation, ADRs, and Blog

New architectural concepts should ship with documentation — comments, diagrams,
and an ADR where significant. This project values written explanations nearly as
much as working code.

Capture significant decisions as ADRs; the rationale matters more than the
decision itself:

```
Docs/ADR/
    0001-event-log-as-source-of-truth.md
    0002-reducer-based-state-derivation.md
    0003-sqlite-over-core-data.md
```

This repo is accompanied by a blog series. Before a major architectural change,
ask: *"Would this make a good blog post?"* If not, the change may be too large,
too abrupt, or insufficiently understood.
