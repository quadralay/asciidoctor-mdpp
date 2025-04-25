
This project provides the Asciidoctor→Markdown++ converter in `lib/asciidoctor/converter/mdpp.rb`.

Development follows a test-driven workflow:
  - Add or update an AsciiDoc sample under `spec/fixtures/samples` and its expected Markdown++ output under `spec/fixtures/expected`.
  - Update `spec/converter_spec.rb` to include the new fixture(s).
  - Run `rspec` and ensure all tests pass.
  - Commit both the converter code changes and fixture updates together.

For detailed development guidelines, see `docs/development-guide.md`.
For Markdown++ language specifications, see `docs/mdpp-specification/`.
