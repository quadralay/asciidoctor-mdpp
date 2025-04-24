
This project maintains the AsciiDoctor custom converter for converting AsciiDoc files into Markdown++ files. The converter is in the file: `lib/asciidoctor/converter/mdpp.rb`.

The Markdown++ file format is an extension of CommonMark Markdown. It extends the language use simple comments, such as: `<!-- style:Foo; #alias -->`. For filenames, Markdown++ uses the filename extension `*.md`.

You will perform incremental tasks to add functionality to the Markdown++ converter.
  - When code is modified you will be responsible for updating testing fixtures located at: `spec/fixtures`. There are two folders: `samples` (contains test AsciiDoc files) and `expected` (contains golden converted Markdown++ files).

  - When `lib/asciidoctor/converter/mdpp.rb` is modified, you will test it by running `rspec`. If all tests are passed, then you will commit all the changes, including changes to fixtures.

  - The file `spec/converter_spec.rb` needs to be updated anytime a new fixture sample is added.

  