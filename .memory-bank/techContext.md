# Tech Context: Asciidoctor-MDPP

## Technology Stack

### Core Technologies
- **Ruby**: Primary programming language (requires Ruby 3.0.0 or higher)
- **Asciidoctor**: Base framework for document processing (version ~> 2.0)
- **RSpec**: Testing framework for Ruby
- **Bundler**: Dependency management
- **Rake**: Task automation

### Development Environment
- **Git**: Version control
- **RubyGems**: Package management and distribution
- **Bash**: Shell scripts for conversion utilities

## Development Setup

### Installation

```bash
# Clone the repository
git clone https://github.com/[USERNAME]/asciidoctor-mdpp.git
cd asciidoctor-mdpp

# Install dependencies
bundle install

# Setup development environment
bin/setup
```

### Interactive Development

```bash
# Open an interactive console with the gem loaded
bin/console

# Install the gem locally for testing
bundle exec rake install
```

## Build & Release Process

```bash
# Run tests
bundle exec rspec

# Build the gem
gem build asciidoctor-mdpp.gemspec

# Release a new version
# 1. Update version in lib/asciidoctor/mdpp/version.rb
# 2. Run:
bundle exec rake release
```

## Project Structure

```
asciidoctor-mdpp/
├── adoc/                   # Sample AsciiDoc documents
│   └── samples/            # Various AsciiDoc examples
├── bin/                    # Executables
│   ├── console             # Interactive Ruby console
│   └── setup               # Development environment setup
├── docs/                   # Project documentation
│   ├── conversion-guidelines.md
│   ├── development-guide.md
│   ├── line-break-challenges.md
│   └── mdpp-specification/ # Markdown++ syntax specification
├── lib/                    # Source code
│   ├── asciidoctor-mdpp.rb # Main entry point
│   ├── asciidoctor/        # Core module files
│   │   ├── mdpp.rb         # Module definition
│   │   ├── mdpp/           # Module components
│   │   │   └── version.rb  # Version information
│   │   └── converter/      # Converter implementation
│   │       └── mdpp.rb     # Core converter logic
├── scripts/                # Utility scripts
│   ├── convert-mdpp.sh     # Batch conversion
│   └── convert-mdpp-file.sh # Single file conversion
├── spec/                   # Test specifications
│   ├── converter_spec.rb   # Converter tests
│   ├── spec_helper.rb      # Test setup
│   └── fixtures/           # Test files
│       ├── expected/       # Expected Markdown++ output
│       └── samples/        # Sample AsciiDoc input
├── .gitignore              # Git ignore patterns
├── .rspec                  # RSpec configuration
├── asciidoctor-mdpp.gemspec # Gem specification
├── Gemfile                 # Dependencies
├── LICENSE.txt             # MIT License
├── Rakefile                # Rake tasks
└── README.md               # Project overview
```

## Testing Framework

### Test-Driven Development Workflow
1. **Add sample**: Create a new AsciiDoc file in `spec/fixtures/samples/`
2. **Define expected output**: Create corresponding Markdown++ in `spec/fixtures/expected/`
3. **Update test spec**: Add test case to `spec/converter_spec.rb`
4. **Run tests**: Execute `rspec` to verify conversion fails
5. **Implement feature**: Add or modify converter code to handle the new case
6. **Verify**: Run tests again to confirm successful conversion
7. **Commit**: Save both the code changes and fixture updates together

### Testing Commands

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/converter_spec.rb

# Run with detailed output
bundle exec rspec --format documentation
```

## Technical Constraints & Limitations

### Asciidoctor AST Limitations
- List item inline breaks (trailing `+`) are problematic due to AST dropping continuation content
- Source location info (`li.source_location`) is only populated when using `Asciidoctor.load_file` with `sourcemap: true`
- Some table structures require direct source parsing rather than relying solely on the AST

### Operational Requirements
- For line-break recovery in list items, documents must be loaded with `sourcemap: true`
- Table conversion requires access to source files for complex structures
- Strict fixture matching requires precise handling of whitespace and newlines

### Ruby Compatibility
- Requires Ruby 3.0.0 or higher
- Uses Ruby's standard library extensively (especially File I/O for source lookups)

## Command Line Usage

### Converting a Single File
```bash
# Using the script
./scripts/convert-mdpp-file.sh input.adoc

# Using Asciidoctor directly
asciidoctor -r lib/asciidoctor/converter/mdpp.rb -b mdpp -o output.md input.adoc
```

### Batch Conversion
```bash
# Convert all files in a directory
./scripts/convert-mdpp.sh <SOURCE_DIR> <OUTPUT_DIR>
```

### Programmatic Usage
```ruby
require 'asciidoctor/converter/mdpp'

# Option 1: Direct conversion
output = Asciidoctor.convert_file(
  'input.adoc',
  backend: 'mdpp',
  safe: :safe,
  require: 'asciidoctor/converter/mdpp',
  attributes: { 'outfilesuffix' => '.md' },
  header_footer: true,
  to_file: false
)

# Option 2: Two-step conversion (for source locations)
doc = Asciidoctor.load_file(
  'input.adoc', 
  safe: :safe, 
  sourcemap: true,
  require: 'asciidoctor/converter/mdpp', 
  backend: 'mdpp', 
  header_footer: true
)
output = doc.convert
```

## Ad-hoc Testing
For rapid testing during development:

```bash
# One-liner to preview converter output
ruby -Ilib -r asciidoctor/converter/mdpp -e "puts Asciidoctor.convert_file('spec/fixtures/samples/your.adoc', backend: 'mdpp', safe: :safe, require: 'asciidoctor/converter/mdpp', header_footer: true)"
```
