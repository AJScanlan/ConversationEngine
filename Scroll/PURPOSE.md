# LLM-Native Chat as a Laboratory for Distributed Systems

## Purpose

This project is not primarily about building a chat UI.

It is an exploration of distributed systems, synchronization, event sourcing, state derivation, and local-first architecture using a chat application as the vehicle.

The end result may be a Swift package, a SwiftUI library, or a reusable framework, but those are secondary outcomes. The primary goal is learning.

The project should prioritize understanding over feature completeness and clarity over production readiness.

---

## Core Thesis

Most chat applications appear simple because they hide significant distributed systems complexity.

Questions such as:

- What is the source of truth?
- How do multiple data sources reconcile?
- What happens when events arrive out of order?
- How do we recover after a crash?
- How do we avoid duplicates?
- How do we represent partially completed work?
- How do we synchronize local and remote state?

are fundamentally distributed systems questions.

A chat application provides a concrete and familiar environment in which to explore them.

---

## Guiding Principles

### 1. Events First

Messages are not the fundamental unit.

Events are.

Avoid beginning with:

```swift
struct Message {
    let id: MessageID
    let text: String
}
```

Prefer thinking in terms of:

```swift
enum ChatEvent {
    case messageCreated(...)
    case tokenReceived(...)
    case messageCompleted(...)
}
```

Messages become derived state.

This allows:

- replay
- auditing
- debugging
- synchronization
- recovery
- time travel

to emerge naturally.

---

### 2. Local First

The local system should be capable of functioning independently.

Remote systems are synchronization partners rather than authoritative controllers.

The application should ideally be able to:

- launch without a network
- reconstruct state from local data
- continue operating while disconnected
- synchronize later

This forces explicit thinking about ownership and consistency.

---

### 3. State Is Derived

Avoid storing the same information in multiple places.

Instead:

```
Events
  ↓
Reducer
  ↓
State
  ↓
UI
```

The UI should consume state.

State should be derived from events.

Events should be the durable record.

---

### 4. Simplicity Before Sophistication

Every new capability should be introduced only after the previous version feels complete.

For example:

**Version 1:**
```
Events
  ↓
Reducer
  ↓
State
```

**Version 2:**
```
Events
  ↓
Persistence
  ↓
Reducer
  ↓
State
```

**Version 3:**
```
REST
  ↓
Events
  ↓
Persistence
  ↓
Reducer
  ↓
State
```

**Version 4:**
```
REST
WebSocket
  ↓
Events
  ↓
Persistence
  ↓
Reducer
  ↓
State
```

The architecture should grow incrementally.

---

## Architectural Vision

The project should gradually evolve toward something resembling:

```
        REST
         │
         ▼
    Event Stream
         ▲
         │
     WebSocket
         │
         ▼
     Event Log
         │
         ▼
      Reducer
         │
         ▼
     Chat State
         │
         ▼
      SwiftUI
```

The important observation is that historical and live data become identical once represented as events.

---

## Learning Roadmap

### Phase 1: Event Sourcing

**Questions:**
- What is an event?
- How does a reducer work?
- How is state reconstructed?

**Deliverables:**
- Event model
- Reducer
- In-memory store

**Topics:**
- Event sourcing
- Functional state transitions
- Deterministic replay

---

### Phase 2: State Derivation

**Questions:**
- How are messages derived?
- What information belongs in state?
- What information belongs in events?

**Deliverables:**
- Derived chat timeline
- Basic SwiftUI rendering

**Topics:**
- State machines
- Projection models
- Derived views

---

### Phase 3: Persistence

**Questions:**
- How should events be stored?
- How should state be recovered?

**Deliverables:**
- SQLite persistence
- Event replay
- Snapshotting experiments

**Topics:**
- Write-ahead logs
- Recovery
- Snapshots

---

### Phase 4: Synchronization

**Questions:**
- How do local and remote systems interact?
- How do we merge historical and live data?

**Deliverables:**
- REST synchronization
- Event ingestion pipeline

**Topics:**
- Synchronization
- Consistency
- Source of truth

---

### Phase 5: Real-Time Systems

**Questions:**
- What changes when updates are streamed?
- How should connections recover?

**Deliverables:**
- WebSocket support
- Reconnection logic

**Topics:**
- Streaming systems
- Backpressure
- Reconnect strategies

---

### Phase 6: Reconciliation

**Questions:**
- What happens when the same event arrives twice?
- What happens when events arrive out of order?

**Deliverables:**
- Deduplication
- Idempotency
- Ordering strategies

**Topics:**
- Distributed systems
- Eventual consistency
- Reconciliation

---

### Phase 7: LLM-Native Behavior

**Questions:**
- Is an LLM response a message or a process?
- How should partial generation be represented?

**Deliverables:**
- Token streaming
- Message lifecycle support

**Topics:**
- Long-running processes
- Incremental updates
- Streaming state machines

**Example:**

```swift
enum ChatEvent {
    case generationStarted
    case tokenReceived(String)
    case toolCallStarted
    case toolCallCompleted
    case generationFinished
}
```

---

### Phase 8: Optimistic Systems

**Questions:**
- How should the UI behave before server confirmation?
- How should failures be represented?

**Deliverables:**
- Pending messages
- Retry logic
- Failure recovery

**Topics:**
- Optimistic updates
- State reconciliation
- User experience under uncertainty

---

### Phase 9: Offline-First Architecture

**Questions:**
- Can the application function without connectivity?
- How should synchronization resume?

**Deliverables:**
- Offline operation
- Sync recovery

**Topics:**
- Local-first software
- Conflict resolution
- Event synchronization

---

## Areas Worth Exploring

As the project matures, investigate:

### CQRS

Separating:

```
Commands
  ↓
Events
  ↓
Queries
```

and examining whether it improves clarity.

---

### CRDTs

Explore whether collaborative chat editing or concurrent updates can be modeled using CRDTs.

Not because they are required, but because they are educational.

---

### Git

Treat Git as a distributed event system.

Questions:
- What is a commit?
- What is a merge?
- What is a rebase?

Many chat synchronization problems resemble simplified Git problems.

---

### Databases

Compare the architecture against:

- SQLite
- PostgreSQL
- EventStoreDB

Observe how databases solve similar problems.

---

### Messaging Systems

Compare the event log to:

- Kafka
- NATS
- RabbitMQ

Identify similarities and differences.

---

## Success Criteria

This project succeeds if:

- I gain a deeper understanding of distributed systems.
- I understand event sourcing from first principles.
- I understand synchronization and reconciliation.
- I can explain why common chat architectures are designed the way they are.
- I can reason about consistency, ordering, and recovery.
- The blog series helps other engineers learn these concepts.

The project does not require:

- Production adoption
- Commercial success
- Feature parity with existing chat SDKs

Those outcomes may occur, but they are not the goal.

---

## Final Reminder

The SwiftUI chat interface is not the destination.

It is an observability layer for a distributed system.

Whenever a design decision becomes unclear, return to the central question:

> "What distributed systems concept am I trying to learn from this stage of the project?"

If a feature does not deepen that understanding, it is probably outside the current scope.
