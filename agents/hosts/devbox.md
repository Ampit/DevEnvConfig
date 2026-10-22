## Devbox records and execution

Development compute, builds, tests, app servers, and agents run on Devbox.
Mac administration and explicitly authorized Mac-only tools use the existing
`work-mac` / `personal-mac` SSH routes. Preserve host-key checks and credentials.
Fleet's checkout is `{{HOME}}/workspace/personal/fleet`; consult its access and
cross-machine thread docs before rediscovering routes or requesting pairing.

Private coordination records, kept out of configuration Git:

- Access map: `{{HOME}}/.local/state/agent-workflow/access-map.md`.
- Nucla status: `{{HOME}}/.local/state/agent-workflow/nucla/STATUS.md`.
- Creator status: `{{HOME}}/.local/state/agent-workflow/creator/STATUS.md`.
- Three-task trial: `{{HOME}}/.local/state/agent-workflow/pilot.json`.

The next three substantial Nucla/Creator tasks record a short result in the trial:
outcome, avoidable clarification/access interruptions, user-discovered defects,
and reopened work. Count observed events only; unknown is not zero. Do not create
tasks, schedules, notifications, or agents just to fill the trial.
