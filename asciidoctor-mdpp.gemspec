# frozen_string_literal: true

require_relative "lib/asciidoctor/mdpp/version"

Gem::Specification.new do |spec|
  spec.name = "asciidoctor-mdpp"
  spec.version = Asciidoctor::Mdpp::VERSION
  spec.authors = ["WebWorks - Quadralay Corporation"]
  spec.email = ["development@webworks.com"]

  spec.summary = "Ruby-based Asciidoctor converter for converting AsciiDoc files to Markdown++ files."
  spec.description = "Ruby-based Asciidoctor converter for converting AsciiDoc files to Markdown++ files."
  spec.homepage = "https://github.com/quadralay/asciidoctor-mdpp"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html

  spec.add_runtime_dependency 'asciidoctor', '~> 2.0'
end
