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
 
- Programmatically, you can invoke the converter from Ruby:
  ```ruby
  require 'asciidoctor/converter/mdpp'
  output = Asciidoctor.convert_file(
    'input.adoc',
    backend:     'mdpp',
    safe:        :safe,
    require:     'asciidoctor/converter/mdpp',
    attributes:  { 'outfilesuffix' => '.md' },
    header_footer: true,
    to_file:       false
  )
  ```
 
- From the shell:
  ```bash
  asciidoctor -r lib/asciidoctor/converter/mdpp.rb -b mdpp -o output.md input.adoc
  ```

## CLI Wrapper and Batch Conversion Script
- A helper script lives at `scripts/convert-mdpp.sh` to run the MDPP converter recursively over a directory tree.
  - Usage: `./scripts/convert-mdpp.sh <SRC_DIR> <OUT_DIR>`
  - It finds all `.adoc`/`.asciidoc` files under `SRC_DIR`, creates matching paths in `OUT_DIR`, and invokes:
    ```bash
    asciidoctor -r lib/asciidoctor/converter/mdpp.rb -b mdpp -o "$DST" "$SRC"
    ```

## Single-File Conversion Script
- A helper script at `scripts/convert-mdpp-file.sh` converts a single AsciiDoc file to Markdown++ side-by-side.
  - Usage: `./scripts/convert-mdpp-file.sh <INPUT.adoc>`
  - Verifies the file exists and has a `.adoc` or `.asciidoc` extension.
  - Outputs a `.md` file alongside the source with the same basename.
  - Ensures the output ends with a trailing newline for strict fixture matching.

## Fixture Tuning and Exact Matching
- All tests perform strict string comparisons of output vs. expected fixtures.
- Blank lines, trailing newlines, and precise spacing matter for passing tests.
- When adding or modifying fixtures, use the diff in `rspec` output to identify mismatches and adjust the expected file accordingly.
- The converter updates are synchronized with fixture tweaks in each feature commit to ensure consistency.

Happy Converting!

## CLI Wrapper and Batch Conversion Script
- A helper script resides at `scripts/convert-mdpp.sh` to invoke the MDPP converter over a directory tree.
- Usage: `./scripts/convert-mdpp.sh <SRC_DIR> <OUT_DIR>`
- It scans for `.adoc`/`.asciidoc` files under `SRC_DIR`, mirrors the directory structure in `OUT_DIR`, and runs:
  ```bash
  asciidoctor -r lib/asciidoctor/converter/mdpp.rb -b mdpp -o "$DST" "$SRC"
  ```

## Fixture Tuning and Exact Matching
- Tests compare outputs strictly (including blank lines, trailing newlines, and spacing).
- When creating or updating fixture files, inspect the `rspec` diff and adjust expected files to match the converter’s output exactly.
- Fixture updates should accompany code changes in the same commit to keep tests green.