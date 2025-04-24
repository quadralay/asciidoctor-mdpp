require 'asciidoctor'
require 'asciidoctor/converter'

class MarkdownPPConverter < Asciidoctor::Converter::Base
  register_for 'mdpp', filetype: 'md', outfilesuffix: '.md'

  def convert(node, transform = node.node_name)
    method = "convert_#{transform}"
    respond_to?(method) ? send(method, node) : "<!-- TODO: #{transform} -->"
  end

  # Render an ordered list with proper indentation for nested levels
  def convert_olist(olist)
    # indent list items based on nesting level (two spaces per level)
    indent = '  ' * (olist.level - 1)
    olist.items.each_with_index.map do |li, idx|
      index = idx + 1
      prefix = "#{indent}#{index}. "
      # convert item and indent subsequent lines to align under the text
      converted = convert(li, 'list_item')
      body = converted.gsub(/\n/, "\n" + ' ' * prefix.length)
      "#{prefix}#{body}"
    end.join("\n")
  end

  def convert_document(doc)
    ([convert(doc.header, 'header')] +
     doc.blocks.map { |b| convert b }).compact.join("\n\n")
  end

  # Render a section header, and include an explicit anchor comment if an id was set via a block anchor
  def convert_section(sec)
    # Build the Markdown header line
    header = '#' * sec.level + ' ' + sec.title
    parts = []
    # If the section has an explicit id attribute (e.g., via [[id]]), emit it as a comment
    if sec.attributes.key?('id')
      parts << "<!-- ##{sec.id} -->"
    end
    parts << header
    # Convert child blocks of the section
    sec.blocks.each do |b|
      parts << convert(b)
    end
    parts.compact.join("\n\n")
  end
  def convert_paragraph(par) ; par.lines.join "\n"                   ; end
  
  # Render an unordered list with proper indentation for nested levels
  def convert_ulist(ulist)
    # indent list items based on nesting level (two spaces per level)
    indent = '  ' * (ulist.level - 1)
    ulist.items.map do |li|
      # render item and indent subsequent lines
      body = convert(li, 'list_item').gsub(/\n/, "\n#{indent}  ")
      "#{indent}- #{body}"
    end.join("\n")
  end
  
  # Render a list item: include its text and any nested blocks
  def convert_list_item(node)
    parts = [node.text]
    node.blocks.each do |b|
      parts << convert(b)
    end
    parts.join("\n")
  end
  
  # Render inline anchor macros: xrefs and explicit anchors
  def convert_inline_anchor(node)
    case node.type
    when :xref
      # Render cross-reference as a Markdown++ link
      text = node.text || node.target
      "[#{text}](##{node.target})"
    when :ref
      # Render an explicit anchor id as a comment
      "<!-- ##{node.id} -->"
    else
      # Unknown inline anchor, omit
      ""
    end
  end
  
  # Render an admonition block as a Markdown++ styled block
  # Emit a style comment and a blockquote for each content line
  def convert_admonition(node)
    # Build style tag (e.g., AdmonitionNote, AdmonitionTip)
    style = "Admonition#{node.caption}"
    # Render child blocks and join their content lines
    content = node.blocks.map { |b| convert(b) }.join("\n")
    # Quote each line of the content
    quoted = content.lines.map { |line| "> #{line.chomp}" }.join("\n")
    # Prepend style comment
    "<!-- style:#{style} -->\n" + quoted
  end
end
