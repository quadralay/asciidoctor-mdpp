<!-- docs/development-guide.md -->
# Developer Guide

This document summarizes key workflows, conventions, and architectural notes for contributors and coding agent sessions.

## Testing and Fixtures
- All feature work is done TDD-style: start by adding or updating a sample in `spec/fixtures/samples` and its corresponding expected output in `spec/fixtures/expected`.
- Update `spec/converter_spec.rb` to include tests for new fixture files.
- Run `rspec` to verify all tests, then commit both code changes and fixture updates together.
- When writing tests that rely on node source locations (e.g., for inline-break recovery in list items), load documents with `Asciidoctor.load_file(..., sourcemap: true)` and call `doc.convert` rather than using `Asciidoctor.convert_file`. This ensures `source_location` is populated on AST nodes.

## Converter Architecture
- The core converter is `lib/asciidoctor/converter/mdpp.rb`, implementing a `convert(node, transform)` dispatch to `convert_<node>` methods.
- Common patterns:
  - `convert_paragraph`, `convert_image`, `convert_admonition`, `convert_ulist`/`convert_olist`, etc.
  - For new Asciidoctor node types (e.g., tables), implement a `convert_table(node)` method.

## Markdown++ Extensions
- Specifications for language extensions (multiline tables, custom style tags, etc.) live under `docs/mdpp-specification/`.
- Please refer to those spec files when implementing or updating features.

## Documentation Updates
- When workflow or conventions change, update this file to reflect the new process.

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
    # To enable recovery of source_location on nodes (e.g., for list-item inline-break tests),
    # prefer using Asciidoctor.load_file with sourcemap: true:
    #   doc = Asciidoctor.load_file('input.adoc', safe: :safe, sourcemap: true,
    #     require: 'asciidoctor/converter/mdpp', backend: 'mdpp', header_footer: true)
    #   output = doc.convert
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
- Byte-for-byte fixture matching: tests compare the full output (including trailing newlines). When changing newline behavior, trim or add newlines in expected fixtures (e.g., `truncate -s -1 spec/fixtures/expected/file.md`) instead of altering specs.
- Rapid ad-hoc conversion checks: use a Ruby one-liner to preview converter output, for example:
  ```bash
  ruby -Ilib -r asciidoctor/converter/mdpp -e "puts Asciidoctor.convert_file('spec/fixtures/samples/your.adoc', backend: 'mdpp', safe: :safe, require: 'asciidoctor/converter/mdpp', header_footer: true)"
  ```
- Distinguish explicit vs. auto-generated anchors: Asciidoctor auto-prefixes IDs with the document’s `idprefix` (default `_`), so emit only user-defined anchors by checking `sec.id` against that prefix.
- Handling new block types: for each new node (e.g., `page_break`, `thematic_break`, `video`), implement a `convert_<node>` in `mdpp.rb`, add sample and expected fixtures, and update the spec.
- Logical, focused commits: group related changes into separate commits (fixtures, converter/spec updates, documentation) with clear, descriptive messages.

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