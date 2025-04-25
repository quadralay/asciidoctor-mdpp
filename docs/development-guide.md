<!-- docs/development-guide.md -->
# Developer Guide

This document summarizes key workflows, conventions, and architectural notes for contributors and Codex sessions.

## Testing and Fixtures
- All feature work is done TDD-style: start by adding or updating a sample in `spec/fixtures/samples` and its corresponding expected output in `spec/fixtures/expected`.
- Update `spec/converter_spec.rb` to include tests for new fixture files.
- Run `rspec` to verify all tests, then commit both code changes and fixture updates together.

## Converter Architecture
- The core converter is `lib/asciidoctor/converter/mdpp.rb`, implementing a `convert(node, transform)` dispatch to `convert_<node>` methods.
- Common patterns:
  - `convert_paragraph`, `convert_image`, `convert_admonition`, `convert_ulist`/`convert_olist`, etc.
  - For new Asciidoctor node types (e.g., tables), implement a `convert_table(node)` method.

## Markdown++ Extensions
- Specifications for language extensions (multiline tables, custom style tags, etc.) live under `docs/mdpp-specification/`.
- Please refer to those spec files when implementing or updating features.

## Documentation Updates
- When workflow or conventions change, update `.codex/instructions.md` and `codex.md` to reflect the new process.

## Helpful Tips
- Use interactive inspect scripts (e.g., throwaway `inspect_*.rb`) to explore Asciidoctor AST nodes, then delete those scripts before committing.
- Keep commits small and focused: fix root causes, update only relevant files.

Happy Converting!