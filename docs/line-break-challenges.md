## Inline-Break Challenges and Partial Recovery

AsciiDoc hard line breaks (a trailing `+` at end of line) are handled differently depending on context:

### Paragraph-level inline breaks
- Asciidoctor represents a trailing `+` as an inline break, but using `par.content` drops them.
- The converter now processes `par.lines`, strips any trailing `+` on each line, and joins lines with literal newlines:
  ```ruby
  lines = par.lines.map { |l| l.chomp("\n").chomp('+') }
  text  = lines.join("\n")
  ```
- This restores hard breaks in normal paragraphs, image-macro paragraphs, admonitions, and most block contexts.

### List-item inline breaks
- **AST limitation**: For `olist` items, Asciidoctor splits at the break marker and drops the continuation from the AST; only the first segment remains.
- **Fallback approach** (implemented but brittle):
  1. Enable `sourcemap: true` when loading via `Asciidoctor.load_file` so that `li.source_location` is populated.
  2. In `convert_olist`, inspect `li.source_location` to locate the raw source file and line number.
  3. Read the raw file lines, strip trailing `+`, and collect all subsequent lines until the next list-item marker or a blank line.
  4. Reconstruct the multi-line item by preserving the original numbering marker and indenting continuations.
- **Limitations**:
  - `source_location` is not set when using `Asciidoctor.convert_file` (the common conversion path), so fallback rarely triggers.
  - Relative paths in `loc.path` require lookup via the document’s `docfile` attribute.
  - The logic is brittle and may fail for nested lists and complex items.
  - The converter currently emits `<!-- TODO: inline_break -->` placeholders for list-item breaks.

### Future work
- Consider writing an Asciidoctor extension to merge broken list-item segments before conversion.
- Improve `convert_olist` fallback or switch to a preprocessor-based approach for robust recovery.