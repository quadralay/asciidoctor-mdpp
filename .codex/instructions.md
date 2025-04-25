For project-specific instructions, see the following files and directories:

- `codex.md` (root): overview of the project workflow and testing conventions.
- `docs/development-guide.md`: developer onboarding, test-driven workflow, and coding guidelines.
- `docs/mdpp-specification/`: Markdown++ language extension specifications (e.g., multiline tables).

Tracks these files to ensure any changes to workflows or specs are captured and committed.

Additional session progress tracking:
 - When a user prompt begins with “Task:” (case-insensitive), or uses “task” to signal upcoming work, the CLI should:
   1. Invoke `logTask(prompt_text)` (from `.codex/session_tracker.js`) to append the full prompt to `.codex/SESSION_TASKS.md`.
   2. On startup, load the last entry via `lastTask()` so the agent can re-state the most recent task.