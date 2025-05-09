# Product Context: Asciidoctor-MDPP

## The Problem
Technical writers and documentation teams often face a challenging situation: they need to write content in a structured authoring format (like AsciiDoc) but need to deliver it in a format that's compatible with specific publishing systems or documentation platforms that use Markdown++.

Without a reliable converter, authors would be forced to either:
1. Manually translate AsciiDoc to Markdown++ (time-consuming and error-prone)
2. Write directly in Markdown++ (losing AsciiDoc's powerful features)
3. Use standard Markdown output (losing Markdown++'s enhanced capabilities)

## What is Markdown++?
Markdown++ is an enhanced variant of standard Markdown that extends the basic syntax with additional features:

1. **Multiline tables** - Tables that can contain complex content spanning multiple lines, including lists, code blocks, and other Markdown elements
2. **Style tags** - HTML comment-based syntax for applying custom styles to content (e.g., `<!-- style:AdmonitionNote -->`)
3. **File includes** - Ability to include content from other Markdown++ files (e.g., `<!--include:file.md-->`)
4. **Anchors and cross-references** - Enhanced linking capabilities through anchor comments (e.g., `<!-- #id -->`)

These extensions make Markdown++ particularly well-suited for technical documentation while maintaining compatibility with basic Markdown parsers.

## How Asciidoctor-MDPP Solves the Problem
Asciidoctor-MDPP bridges the gap between AsciiDoc's structured authoring capabilities and Markdown++'s publishing flexibility by:

1. **Providing automated conversion** - Eliminating manual translation work
2. **Preserving document structure** - Maintaining the hierarchy and relationships in the original AsciiDoc
3. **Supporting Markdown++ extensions** - Translating AsciiDoc features to their Markdown++ equivalents
4. **Enabling batch processing** - Converting entire documentation sets with a single command
5. **Integrating with existing workflows** - Working with standard Asciidoctor toolchains

## Target Users
This converter is designed for:
- Documentation teams using AsciiDoc for authoring but needing Markdown++ output
- Technical writers who work across multiple documentation systems
- Documentation toolchain engineers integrating multiple authoring and publishing platforms
- Open-source projects wanting to maintain documentation in AsciiDoc while publishing to Markdown++-compatible platforms

## User Experience Goals
- **Seamless conversion** - Authors should be able to write in AsciiDoc without worrying about the conversion process
- **High fidelity output** - The Markdown++ output should faithfully represent the original AsciiDoc content
- **Easy integration** - The converter should work with existing Asciidoctor toolchains and workflows
- **Clear error handling** - When conversion challenges arise, they should be clearly documented and reported
- **Simple troubleshooting** - Users should be able to easily identify and address conversion issues
- **Extensibility** - The system should accommodate future enhancements to both AsciiDoc and Markdown++

## Business Context
WebWorks is developing this project as an open-source contribution to the technical documentation community. By publishing it on GitHub, WebWorks aims to:
- Support the broader documentation toolchain ecosystem
- Enable more flexible documentation workflows
- Demonstrate commitment to open-source development
- Establish expertise in documentation conversion solutions
- Potentially attract community contributions to enhance the converter's capabilities
