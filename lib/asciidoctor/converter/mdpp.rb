require 'asciidoctor'
require 'asciidoctor/converter'

class MarkdownPPConverter < Asciidoctor::Converter::Base
  register_for 'mdpp', filetype: 'md', outfilesuffix: '.md'

  def convert(node, transform = node.node_name)
    method = "convert_#{transform}"
    respond_to?(method) ? send(method, node) : "<!-- TODO: #{transform} -->"
  end

  # Render the document title (from = Title) as a Markdown++ setext header
  def convert_header(header)
    title = header.title
    underline = '=' * title.length
    "#{title}\n#{underline}"
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

  # Render the document: title and top-level blocks (preamble, sections, etc.)
  def convert_document(doc)
    parts = []
    # Render document title (level-0 header)
    parts << convert(doc.header, 'header')
    # Render each top-level block (includes preamble and sections)
    doc.blocks.each do |blk|
      parts << convert(blk)
    end
    parts.compact.join("\n\n")
  end

  # Render the document preamble (blocks before the first section)
  def convert_preamble(preamble)
    # Convert each child block in the preamble
    preamble.blocks.map { |blk| convert(blk) }.compact.join("\n\n")
  end

  # Render a section header, and include an explicit anchor comment if an id was set via a block anchor
  def convert_section(sec)
    # Build the Markdown header line
    header_line = '#' * sec.level + ' ' + sec.title
    # Start with optional anchor comment
    output = ''
    if sec.attributes.key?('id')
      output << "<!-- ##{sec.id} -->\n"
    end
    # Add the header
    output << header_line
    # Append child blocks, separated by a blank line
    sec.blocks.each do |b|
      output << "\n\n" << convert(b)
    end
    output
  end
  # Render a paragraph. Handle inline image macros specially, otherwise process inline macros.
  def convert_paragraph(par)
    # If the paragraph contains an inline image macro, convert it manually
    if par.lines.any? { |line| line.include? 'image:' } && par.lines.any? { |line| line.match(/image:[^\[]+\[[^\]]+\]/) }
      text = par.lines.join("\n")
      # Replace inline image macros: image:src[alt,width,height]
      text.gsub(/image:(\S+?)\[([^,\]]+),(\d+),(\d+)\]/) do
        src, alt, w, h = $1, $2, $3, $4
        "![#{alt}](#{src}){width=#{w} height=#{h}}"
      end
    else
      # Process inline macros (anchors, xrefs, etc.)
      par.content
    end
  end
  
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
      # node.target may include a leading '#', so do not add an extra
      "[#{text}](#{node.target})"
    when :ref
      # Render an explicit anchor id as a comment
      "<!-- ##{node.id} -->"
    else
      # Unknown inline anchor, omit
      ""
    end
  end
  
  # Render a block-level image as a Markdown image with optional dimensions
  def convert_image(node)
    # alt text or title (fallback to first positional attribute)
    alt = node.attr('alt') || node.attr('title') || node.attributes[1] || ''
    # image source URL or path: use node.target for inline images, block images store in attribute
    src = node.inline? ? node.target : node.attr('target')
    # dimensions (fallback to positional attributes if named not present)
    width = node.attr('width') || node.attributes[2]
    height = node.attr('height') || node.attributes[3]
    dims = []
    dims << "width=#{width}" if width
    dims << "height=#{height}" if height
    attr_str = dims.empty? ? '' : "{#{dims.join ' '}}"
    "![#{alt}](#{src})#{attr_str}"
  end

  # Render an inline image using the same logic as block-level image
  alias convert_inline_image convert_image
  
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
