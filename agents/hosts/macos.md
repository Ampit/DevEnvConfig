## Mac interface and shared Devbox records

Work Mac is the work interface; Personal Mac is the personal interface.
Development compute, builds, tests, app servers, and agents stay on Devbox.
Mac administration and explicitly authorized Mac-only tools use existing SSH.
Fleet's local mirror is `{{HOME}}/workspace/fleet`; read its access and
cross-machine thread docs before rediscovering routes or requesting pairing.

Private status and access records remain canonical on Devbox, not on this Mac.
Read/update them through the verified `devbox` SSH alias. For example:

```sh
ssh -o BatchMode=yes -o StrictHostKeyChecking=yes devbox 'cat /home/ubuntu/.local/state/agent-workflow/access-map.md'
```

Devbox paths:

- Access map: `/home/ubuntu/.local/state/agent-workflow/access-map.md`.
- Nucla status: `/home/ubuntu/.local/state/agent-workflow/nucla/STATUS.md`.
- Creator status: `/home/ubuntu/.local/state/agent-workflow/creator/STATUS.md`.
- Three-task trial: `/home/ubuntu/.local/state/agent-workflow/pilot.json`.

Never create a second local status/trial copy. If SSH is unavailable, report
shared state as unverified. Preserve existing credentials, checkouts, and holds.
The next three substantial Nucla/Creator tasks record observed interruptions,
user-discovered defects, and reopened work in the trial; unknown is not zero.
Do not create tasks, schedules, notifications, or agents just to fill the trial.
