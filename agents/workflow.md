# Shared agent workflow

Maintained in `Ampit/DevEnvConfig` at `agents/workflow.md` and `agents/hosts/`.
Fleet config sync generates this file; edit the versioned source and publish it
instead of editing an installed copy. Local edits are preserved and block sync.
These instructions grant no new deployment, spending, access, messaging, or
automation authority. Follow the current user task and project instructions.

- **Align on the outcome.** For substantial work, briefly state the user-visible
  outcome and 3–5 observable acceptance checks. Reuse decisions already made.
  Surface new product policy, scope, cost, or production choices before building
  them; resolve routine engineering choices yourself. Keep small fixes simple.
- **Finish authorized work.** Continue through discovery, implementation, repair,
  and verification within scope. Do not repeatedly ask "what's next?" or request
  the same approval. Repair/retry within existing authorization, respecting
  explicit one-attempt, expiry, identity, and stop conditions. Validate locally
  before using a short-lived session.
- **Make readiness inspectable.** Check the affected end-to-end journey on the
  actual review deployment when authorized. For UI changes check relevant
  desktop/mobile layouts, branding, errors, and realistic content. Distinguish
  implemented, deployed, journey-verified, and pending. Name blocked checks;
  hand over one primary review link, changes, evidence, and remaining limits.
- **Keep shared state current.** Before substantial work and at handoff, read
  and update the project's status record: timestamp, objective, owner/thread,
  active operation, PR/commit, deployment, next action, blocker, and approval
  boundaries. Distinguish historical reports from fresh verification. Preserve
  unfinished queued work in handoffs. Use one owner per production operation;
  resolve competing ownership before mutation. Status is not a lock or approval.
- **Reuse access knowledge.** Read Fleet's access docs and the private access
  map before asking for a new connection. Verify the named identity with a safe
  read within scope. Expired login is not missing configuration. Never store
  secrets in the map or silently substitute identities, personal integrations,
  or environments.
- **Give validation a stopping point.** Identify what CI proves for the revision
  and the remaining local/live check. Reuse passing evidence; repeat checks for
  relevant changes or new failures. Request more model review for a concrete
  unresolved concern or user request. Verify model/options, report capability
  mismatches, and use an agreed fallback. Tests alone are not product acceptance.
- **Keep updates scannable.** Lead with the result; use short bullets and bold
  labels for status, decisions, and blockers. Explain technical work through its
  effect on users. Keep implementation details out of product copy.

## Cross-machine threads

T3 conversations belong to the server running them. Local T3 tools cannot assume
another machine's thread IDs or history are local. Read the owning host's thread
through its T3 CLI over existing verified SSH, following Fleet's
`docs/cross-machine-threads.md`. Browser pairing is separate from SSH access.
Use a self-contained handoff with owner, scope, unfinished queue, evidence paths,
and approval limits. `@file` text does not transfer a file. Message another thread
only when the user requested it; sending starts work and transfers no authority.
Do not resume archived threads or historical queues automatically. Use app-owned
delegation for subagents, not top-level thread messaging as a substitute.
