require 'spec_helper'
require_relative '../lib/asciidoctor/converter/mdpp'      # loads your gem

FIXTURES = Pathname.new(__dir__).join('fixtures')

def convert_sample(name)
  Asciidoctor.convert_file(
    FIXTURES.join('samples', name),
    backend: 'mdpp',
    safe: :safe,
    require: 'asciidoctor/converter/mdpp',
    attributes: {'outfilesuffix' => '.md'},
    header_footer: true,
    to_file: false
  )
end

RSpec.describe MarkdownPPConverter do
  it 'renders nested lists' do
    expect(convert_sample('nested_ulist.adoc'))
      .to eq File.read(FIXTURES.join('expected', 'nested_ulist.md')).chomp
  end
  
  it 'renders nested ordered lists' do
    expect(convert_sample('nested_olist.adoc'))
      .to eq File.read(FIXTURES.join('expected', 'nested_olist.md'))
  end
  
  it 'renders admonitions' do
    expect(convert_sample('admonitions.adoc'))
      .to eq File.read(FIXTURES.join('expected', 'admonitions.md'))
  end
  
  it 'renders section linking' do
    expect(convert_sample('section_linking.adoc'))
      .to eq File.read(FIXTURES.join('expected', 'section_linking.md'))
  end
  
  it 'renders images' do
    expect(convert_sample('images.adoc'))
      .to eq File.read(FIXTURES.join('expected', 'images.md'))
  end
  
  it 'renders nested blocks' do
    expect(convert_sample('nested_blocks.adoc'))
      .to eq File.read(FIXTURES.join('expected', 'nested_blocks.md'))
  end
  
  it 'renders simple tables' do
    expect(convert_sample('tables.adoc'))
      .to eq File.read(FIXTURES.join('expected', 'tables.md'))
  end
  
  it 'renders multiline tables' do
    expect(convert_sample('multiline-tables.adoc'))
      .to eq File.read(FIXTURES.join('expected', 'multiline-tables.md'))
  end
  
  it 'renders grid row tables' do
    expect(convert_sample('grid_rows.adoc'))
      .to eq File.read(FIXTURES.join('expected', 'grid_rows.md'))
  end
  
  it 'renders file includes' do
    expect(convert_sample('includes.adoc'))
      .to eq File.read(FIXTURES.join('expected', 'includes.md'))
  end
  
  it 'renders inline quoted text' do
    expect(convert_sample('inline_quoted.adoc'))
      .to eq File.read(FIXTURES.join('expected', 'inline_quoted.md'))
  end
  
  it 'renders inline breaks' do
    expect(convert_sample('line-break.adoc'))
      .to eq File.read(FIXTURES.join('expected', 'inline-break.md'))
  end
end
