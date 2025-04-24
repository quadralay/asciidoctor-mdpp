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

  def convert_section(sec)
    (['#' * sec.level + ' ' + sec.title] + sec.blocks.map { |b| convert b }).compact.join("\n\n")
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
