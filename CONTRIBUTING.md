# Contributing to Asciidoctor-MDPP

We welcome contributions to the Asciidoctor-MDPP project! By participating, you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md).

## How to Contribute

1.  **Fork the Repository**: Start by forking the `asciidoctor-mdpp` repository on GitHub.
2.  **Clone Your Fork**: Clone your forked repository to your local machine:
    ```bash
    git clone https://github.com/YOUR_USERNAME/asciidoctor-mdpp.git
    cd asciidoctor-mdpp
    ```
3.  **Install Dependencies**: Set up your development environment:
    ```bash
    bin/setup
    ```
4.  **Create a New Branch**: Create a new branch for your feature or bug fix:
    ```bash
    git checkout -b feature/your-feature-name
    ```
5.  **Implement Your Changes**:
    *   Follow the existing code style and conventions.
    *   All new features or bug fixes must be accompanied by new or updated tests.
    *   Ensure all tests pass before submitting your changes (`bundle exec rspec`).
    *   If you are adding a new conversion feature, please follow the Test-Driven Development (TDD) workflow outlined in `docs/development-guide.md` and `spec/fixtures/`.
6.  **Commit Your Changes**: Write clear, concise commit messages.
7.  **Push to Your Fork**:
    ```bash
    git push origin feature/your-feature-name
    ```
8.  **Create a Pull Request**: Open a pull request from your fork to the `main` branch of the upstream repository. Provide a detailed description of your changes.

## Test-Driven Development (TDD) Workflow

Our project heavily relies on TDD. When adding new conversion features:

1.  **Add Sample**: Create a new AsciiDoc sample file in `spec/fixtures/samples/`.
2.  **Define Expected Output**: Create the corresponding expected Markdown++ output in `spec/fixtures/expected/`.
3.  **Update Test Spec**: Add a new test case to `spec/converter_spec.rb` that uses your new sample and expected output.
4.  **Run Tests**: Execute `bundle exec rspec` to confirm the new test fails (as the feature is not yet implemented).
5.  **Implement Feature**: Write the necessary code in `lib/asciidoctor/converter/mdpp.rb` (or related files) to make the test pass.
6.  **Verify**: Run tests again to confirm successful conversion and that all existing tests still pass.
7.  **Commit**: Commit both the code changes and the fixture updates together.

## Cline Workflow and Memory Bank

This project utilizes a "Cline Workflow" which is supported by a `.memory-bank` directory. This directory contains documentation files that provide context, design decisions, and progress updates for the project.

### Memory Bank Structure

The `.memory-bank` directory contains the following core files:

*   `projectbrief.md`: Defines core requirements and goals.
*   `productContext.md`: Explains why the project exists, problems it solves, and user experience goals.
*   `activeContext.md`: Details current work focus, recent changes, next steps, and active decisions.
*   `systemPatterns.md`: Describes system architecture, key technical decisions, and design patterns.
*   `techContext.md`: Outlines technologies used, development setup, and technical constraints.
*   `progress.md`: Tracks what works, what's left to build, current status, and known issues.

### How to Use the Memory Bank

*   **Before Starting Work**: Always read through the `.memory-bank` files to understand the current state, context, and any ongoing discussions or decisions.
*   **During Development**: Refer to `activeContext.md` for immediate next steps and `systemPatterns.md` for architectural guidance.
*   **After Significant Changes**: Consider updating relevant `.memory-bank` files to reflect new patterns, design decisions, or progress. This helps maintain a shared understanding of the project's evolution.

By maintaining the `.memory-bank`, we ensure that all contributors have access to a comprehensive and up-to-date understanding of the project, facilitating smoother collaboration and onboarding.

## Code Style

*   Follow standard Ruby coding conventions.
*   Use `frozen_string_literal: true` at the top of Ruby files.
*   Maintain clean method boundaries and clear variable names.

## Reporting Bugs

If you find a bug, please open an issue on our [GitHub Issues page](https://github.com/quadralay/asciidoctor-mdpp/issues). Provide as much detail as possible, including steps to reproduce the bug, expected behavior, and actual behavior.

## Suggesting Enhancements

We welcome suggestions for new features or improvements. Please open an issue on our [GitHub Issues page](https://github.com/quadralay/asciidoctor-mdpp/issues) to discuss your ideas.
