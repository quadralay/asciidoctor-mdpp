# Active Context: Asciidoctor-MDPP

## Current Work Focus

The current development focus is on stabilizing and enhancing the Asciidoctor-MDPP converter with particular attention to:

1. **Line Break Handling**: Improving line break recovery, especially in list items where the AsciiDoc AST drops continuation content after a trailing `+` character
2. **Complex Table Rendering**: Refining the handling of multiline tables to better preserve source content fidelity
3. **Test Coverage**: Expanding the test suite with additional edge cases to ensure robust conversion
4. **Documentation**: Preparing documentation for the project's upcoming open-source release

## Recent Changes

Recent development efforts have addressed:

- **Admonition Conversion**: Implemented proper handling of both fenced and short-form admonitions with correct style tags
- **Image Handling**: Added support for dimensions and styling in image conversion
- **Section Anchors**: Added support for explicit anchors in section headers
- **Code Blocks**: Implemented support for code fences with language tags
- **Page & Thematic Breaks**: Added handling for page breaks and thematic breaks (horizontal rules)
- **Video Embeds**: Added support for YouTube video embeds

## Development Patterns

The project follows these active development patterns:

1. **Test-First Development**: All new features begin with sample/expected fixture pairs before implementation
2. **Strict Output Matching**: Tests validate conversion through byte-for-byte comparison of output with expected fixtures
3. **Fallback Mechanisms**: Complex conversions implement fallbacks to ensure output is always generated, even with edge cases
4. **Source Preservation**: Where AST information is insufficient, source file lookups are used to reconstruct the original content
5. **Documentation Updates**: Development guidelines and specifications are updated alongside code changes

## Key Insights & Learnings

Working with the Asciidoctor AST has revealed several important insights:

- **AST Limitations**: Some AsciiDoc features (like list item continuations) are not fully represented in the AST, requiring additional source processing
- **Node Context Matters**: The same node type may require different handling based on its parent context (e.g., lists inside other lists)
- **Source Processing Trade-offs**: Direct source parsing provides more control but introduces dependencies on source file availability
- **Whitespace Sensitivity**: Exact reproduction of expected output requires careful handling of newlines, indentation, and whitespace

## Decision Framework

When implementing new conversion features, the following decision framework is used:

1. **AST-first approach**: Attempt to use Asciidoctor's AST representation when it contains sufficient information
2. **Source fallback**: When AST is insufficient, implement controlled source file lookups as a fallback
3. **Graceful degradation**: When neither approach works, provide a clear but functional fallback (e.g., TODO comments)
4. **Test validation**: Ensure all approaches are validated with comprehensive fixture-based tests

## Next Steps

The immediate development roadmap includes:

1. **Line Break Recovery Enhancement**: Improve the source location fallback for list item breaks
2. **Nested Content Support**: Enhance handling of deeply nested structures (lists within lists within blocks)
3. **Error Reporting**: Add better error messages and warnings for problematic conversions
4. **Performance Optimization**: Review and optimize source file lookups and processing
5. **Documentation Completion**: Finalize documentation for open-source release
6. **GitHub Preparation**: Completed preparation of the repository for public GitHub release by Quadralay Corporation.

## Recent Changes

- **Repository Preparation**: Updated `README.md`, created `CONTRIBUTING.md` and `CODE_OF_CONDUCT.md`, updated `LICENSE.txt` and `asciidoctor-mdpp.gemspec` for open-source release, including copyright and author attribution to Quadralay Corporation.
- **Description Update**: Updated the gem's functional description in `gemspec`, `README.md`, `projectbrief.md`, and `productContext.md` to "Ruby-based Asciidoctor converter for converting AsciiDoc files to Markdown++ files."
- **Cleanup**: Removed `codex.md` and the `.codex` directory.
- **File Extension Clarification**: Clarified the use of the `.md` file extension for Markdown++ files and its backward compatibility benefits in `README.md`, `docs/mdpp-specification/overview.md`, and `productContext.md`.

## Current Challenges

The main technical challenges being addressed are:

1. **Line Break Recovery**: The AST drops content after inline breaks in list items, requiring source reconstruction
2. **Table Source Parsing**: Complex table structures benefit from direct source parsing, but this creates dependencies on source file availability
3. **Strict Fixture Matching**: Tests require exact byte-for-byte matches, making whitespace and newline handling critical
4. **AST Navigation**: Determining the context of nodes (e.g., whether a list is nested) requires careful parent/child relationship analysis

## Collaboration Notes

- **Commit Workflow**: Group related changes into focused, logical commits (fixtures, converter updates, documentation)
- **Test Requirements**: All converter changes must be accompanied by fixture updates to maintain test coverage
- **Code Style**: Follow Ruby conventions with frozen_string_literal and clean method boundaries
- **Feature Documentation**: Document conversion details, assumptions, and limitations in the appropriate files under docs/
