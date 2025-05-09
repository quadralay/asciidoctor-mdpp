# Project Brief: Asciidoctor-MDPP

## Overview
Asciidoctor-MDPP is a Ruby gem that provides a custom converter for transforming AsciiDoc documents into Markdown++ (MDPP), an enhanced variant of standard Markdown. It extends the Asciidoctor framework with specialized conversion capabilities to handle unique Markdown++ features while preserving document structure and formatting.

## Purpose
The primary purpose of this project is to facilitate the conversion of technical documentation from AsciiDoc format to Markdown++ format, enabling users to leverage AsciiDoc's structured authoring capabilities while targeting systems that work with Markdown++.

## Status
The gem is currently in active development by WebWorks and is planned to be published as an open-source project on GitHub. The core conversion functionality is implemented and working well, though there are some known challenges with specific AsciiDoc features.

## Goals
- Provide a reliable and accurate conversion from AsciiDoc to Markdown++
- Support all Markdown++ specific features including multiline tables, custom style tags, and file includes
- Ensure high fidelity conversion that maintains document structure and formatting
- Create a well-documented, maintainable, and extensible codebase
- Establish a robust testing framework using Test-Driven Development (TDD)
- Release as an open-source project to benefit the broader technical writing community

## Key Requirements
- Maintain a test-driven development approach for all feature additions
- Support Markdown++ extensions like multiline tables, style tags, and includes
- Handle AsciiDoc-specific features with appropriate Markdown++ equivalents
- Provide comprehensive documentation for users and contributors
- Ensure the converter is compatible with standard Asciidoctor workflows

## Scope
The project's scope encompasses:
- Core converter functionality for AsciiDoc to Markdown++ transformation
- Support for all standard AsciiDoc elements (headings, paragraphs, lists, tables, etc.)
- Special handling for Markdown++ extensions and styling
- CLI tools for batch conversion
- Documentation for usage and contribution

## Non-Goals
- Support for converting Markdown++ back to AsciiDoc
- WYSIWYG editing capabilities
- Web-based conversion interface (focused on CLI/library usage)
- Support for formats other than AsciiDoc and Markdown++
