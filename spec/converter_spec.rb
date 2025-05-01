require 'spec_helper'
require_relative '../lib/asciidoctor/converter/mdpp'      # loads your gem

FIXTURES = Pathname.new(__dir__).join('fixtures')

def convert_sample(name)
  # Load document with sourcemap support, then convert using MarkdownPPConverter
  doc = Asciidoctor.load_file(
    FIXTURES.join('samples', name),
    safe: :safe,
    sourcemap: true,
    require: 'asciidoctor/converter/mdpp',
    backend: 'mdpp',
    attributes: {'outfilesuffix' => '.md'},
    header_footer: true
  )
  doc.convert
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
      .to eq File.read(FIXTURES.join('expected', 'line-break.md'))
  end
  
  it 'renders anchors' do
    expect(convert_sample('anchors.adoc'))
      .to eq File.read(FIXTURES.join('expected', 'anchors.md'))
  end
  
  it 'renders code blocks' do
    expect(convert_sample('code-blocks.adoc'))
      .to eq File.read(FIXTURES.join('expected', 'code-blocks.md'))
  end
  
  it 'renders page breaks' do
    expect(convert_sample('page-break.adoc'))
      .to eq File.read(FIXTURES.join('expected', 'page-break.md'))
  end
  
  it 'renders thematic breaks' do
    expect(convert_sample('thematic-break.adoc'))
      .to eq File.read(FIXTURES.join('expected', 'thematic-break.md'))
  end
  
  it 'renders videos' do
    expect(convert_sample('videos.adoc'))
      .to eq File.read(FIXTURES.join('expected', 'videos.md'))
  end
end
