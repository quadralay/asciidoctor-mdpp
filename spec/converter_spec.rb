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
      .to eq File.read(FIXTURES.join('expected', 'nested_ulist.md'))
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
end
