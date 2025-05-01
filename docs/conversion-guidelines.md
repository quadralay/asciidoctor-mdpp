<!-- docs/conversion-guidelines.md -->
# AsciiDoc → Markdown++ Conversion: Design Guidelines

This document captures key design decisions, assumptions, and limitations of the MDPP converter.

## Table Conversion

- The converter supports two main table styles:
  1. **AST-based simple tables** (more than two columns): uses Asciidoctor’s AST to extract header and body rows, compute column widths, and render a padded Markdown++ table.
  2. **Grid-based multiline tables** (exactly two columns with multiline cell content): parses the raw source between `|===` fences to preserve cell grouping, then emits a two-column Markdown++ table with `multiline` style.
- A **final AST fallback** wraps the entire grid parse in a `begin…rescue` to catch inconsistent fencing, missing fences, or nil comparisons. On error, it reverts to the simple AST-based renderer to guarantee conversion succeeds.
- Challenges:
  - Inconsistent AsciiDoc fencing (missing closing `|===`) caused `nil` index errors.
  - Column width calculations needed nil-safe defaults.
  - Preserving empty lines between logical row groups to match expected fixtures.

## Admonition Conversion

- Two rendering modes:
  1. **Fenced blocks** (`[NOTE]` / `====…====`): convert child blocks (e.g., paragraphs, lists) recursively, then prefix each line with `> ` and prepend `<!-- style:Admonition<Type> -->` without a trailing blank line.
  2. **Short-form blocks** (`NOTE:` in a paragraph): capture the raw lines, quote them verbatim, and append a trailing blank line to separate from following content.
- Challenges:
  - Distinguishing fenced vs. inline admonitions was required to control newlines correctly.
  - Tests use strict equality, so extra or missing blank lines broke fixtures.

## Image Macro Conversion

- Single converter (`convert_image`) handles both block and inline images.
- Parsing rules:
  - **Alt text**: only the first positional attribute is used; if none, the `alt` is empty (`![]`).
  - **Dimensions**: `width` and `height` can be numeric or percentage (e.g., `60%`), either as positional params or named attributes (`width="60%"`).
  - **Style name**: built as `w<value>` and/or `h<value>` with `%` mapped to `percent` (e.g., `w60percent`).
  - **Style comment**: only emitted when at least one dimension is specified: `<!-- style:w250h350 -->`.
  - **pdfwidth** and other non-size attributes are ignored.
- Inline images are processed via `convert_paragraph`, which gsubs on the `image:…[...]` pattern and reuses the same style logic.
- Challenges:
  - Handling mixed named and positional parameters.
  - Ensuring inline and block conversions stay in sync.
  - Avoiding extraneous style comments when no size is provided.

## Strict Fixture Matching

- Because tests perform byte-for-byte comparisons, every blank line, trailing newline, and space counts.
- All converter methods (`convert_document`, `convert_admonition`, etc.) must be careful about where they append `\n`.
  - For example, `convert_document` should not append an extra newline at end, to avoid unexpected blank line.
  - Short-form admonitions append one trailing newline, whereas fenced admonitions do not.

---
_These guidelines will evolve as new edge cases appear. Please document any future converter gotchas here._
## Line Break Challenges

- Asciidoctor normalizes trailing `+` line breaks differently in paragraphs vs. list items:
  - Paragraph breaks (trailing `+`) appear in `par.lines` and are handled by `convert_paragraph` by joining lines after stripping the `+`.
  - List-item breaks are absorbed by the parser (AST loses the second line), so `convert_list_item` sees only the first segment.
- The only reliable way to recover list-item breaks is a minimal file-aware fallback in `convert_olist`:
  1. Call `convert(li, 'list_item')`. If it yields an empty or whitespace-only body, then
  2. Use `li.source_location` to get the file path and line number.
  3. Read that raw source line, strip the trailing `+`, emit `warn "path:lineno: inline '+' break in list item is not supported; text following the '+' has been dropped"` to `STDERR`, and use the remaining text as the list item.
- Do not attempt to preprocess or rewrite `reader.lines` for this, as it breaks nested blocks, tables, and other constructs.
- For nested list indentation, always check whether `ulist.parent.node_name == 'list_item'` instead of trusting `ulist.level`, which can vary in non-list contexts.