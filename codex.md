
This project provides the Asciidoctor→Markdown++ converter in `lib/asciidoctor/converter/mdpp.rb`.

Development follows a test-driven workflow:
  - Add or update an AsciiDoc sample under `spec/fixtures/samples` and its expected Markdown++ output under `spec/fixtures/expected`.
  - Update `spec/converter_spec.rb` to include the new fixture(s).
  - Run `rspec` and ensure all tests pass.
  - Commit both the converter code changes and fixture updates together.

For detailed development guidelines, see `docs/development-guide.md`.
For Markdown++ language specifications, see `docs/mdpp-specification/`.

## Session Task Logging

When a prompt begins with “Task:” (case-insensitive), or otherwise uses “task” to signal upcoming work, the CLI will record that full description into `.codex/SESSION_TASKS.md` with a timestamp. On restart, inspecting this file or calling `SessionTracker.last_task` (from `.codex/session_tracker.rb`) lets you resume from the last assigned task.

To activate this wrapper:
1. Place the wrapper script in `.codex/codex` (included here).
2. Make sure it’s executable (`chmod +x .codex/codex`).
3. Invoke your session via `./.codex/codex [args]` (or add `.codex/` to your PATH).
4. You can override which codex binary is wrapped by setting the `CODEX_BIN` environment variable.
