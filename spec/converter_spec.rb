require 'spec_helper'
require_relative '../lib/asciidoctor/converter/mdpp'      # loads your gem

FIXTURES = Pathname.new(__dir__).join('fixtures')

def convert_sample(name)
  Asciidoctor.convert_file(
    FIXTURES.join('samples', name),
    backend: 'mdpp',
    safe: :safe,
    require: 'asciidoctor/mdpp',
    attributes: {'outfilesuffix' => '.md'},
    header_footer: true,
    to_file: false
  )
end

RSpec.describe MarkdownPPConverter do
  it 'renders nested lists' do
    expect(convert_sample('nested_ulist.adoc'))
      .to eq File.read(FIXTURES.join('expected', 'nested_ulist.md'))
  end
end
