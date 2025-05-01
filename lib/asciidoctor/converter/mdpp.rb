require 'asciidoctor'
require 'asciidoctor/converter'
require 'asciidoctor/extensions'

# Extension: intercept AsciiDoc include directives and convert to Markdown++ include tags
Asciidoctor::Extensions.register do
  include_processor do
    # Handle all include targets
    process do |doc, reader, target, attributes|
      # Convert file extension to .md
      md_path = target.sub(/\.[^.]+$/, '.md')
      include_tag = "<!--include:#{md_path}-->"
      # Push include tag into reader as literal content
      reader.push_include include_tag + "\n", nil, target, reader.lineno, {}
    end
  end
end

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
    # indent nested ordered lists (two spaces per nested level) only when under another list item
    if olist.parent.respond_to?(:node_name) && olist.parent.node_name == 'list_item'
      indent = '  ' * (olist.level - 1)
    else
      indent = ''
    end
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
    # Prepare document title or fallback to first section title
    parts = []
    # Copy blocks to avoid mutating original
    blocks = doc.blocks.dup
    if doc.header && doc.header.title && !doc.header.title.empty?
      # Use document title
      parts << convert(doc.header, 'header')
      rest_blocks = blocks
    elsif blocks.first && blocks.first.node_name == 'section'
      # Promote first section title as document title
      first_sec = blocks.shift
      title = first_sec.title
      parts << "#{title}\n#{'=' * title.length}"
      # Render child blocks of that first section, then any remaining top-level blocks
      rest_blocks = first_sec.blocks + blocks
    else
      rest_blocks = blocks
    end
    # Render each remaining block
    rest_blocks.each do |blk|
      parts << convert(blk)
    end
    # Join parts with blank lines
    result = parts.compact.join("\n\n")
    # Append trailing newline if last document block is a standalone image macro paragraph
    if doc.blocks.any? && doc.blocks.last.node_name == 'paragraph' && doc.blocks.last.lines.size == 1 && doc.blocks.last.lines.first.strip.start_with?('image:')
      result << "\n"
    end
    result
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
    # Start with optional anchor comment for explicit anchors
    output = ''
    # Include comment only when section id was explicitly set (does not begin with auto-generated prefix)
    id = sec.id.to_s
    # Default id prefix as defined by document (defaults to '_')
    prefix = sec.document.attributes['idprefix'] || '_'
    if !id.empty? && !id.start_with?(prefix)
      output << "<!-- ##{id} -->\n"
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
    # If this paragraph is a Markdown++ include tag, emit it raw
    if par.lines.size == 1 && par.lines.first.strip =~ /<!--\s*include:[^>]+-->/
      return par.lines.first.strip
    end
    # Convert any inline image macros in this paragraph
    if par.lines.any? { |line| line.include? 'image:' }
      text = par.lines.join("\n")
      text.gsub(/image:(\S+?)\[([^\]]*)\]/) do
        src = Regexp.last_match(1)
        positional = []
        named = {}
        Regexp.last_match(2).split(',').map(&:strip).each do |param|
          next if param.empty?
          if param.include?('=')
            k, v = param.split('=', 2)
            v = v.gsub(/^"|"$|^'|'$/, '')
            named[k] = v
          else
            positional << param
          end
        end
        alt = positional[0] || ''
        width = named['width'] || positional[1]
        height = named['height'] || positional[2]
        style_parts = []
        if width && !width.empty?
          w = width.to_s
          style_parts << (w.end_with?('%') ? "w#{w.chomp('%')}percent" : "w#{w}")
        end
        if height && !height.empty?
          h = height.to_s
          style_parts << (h.end_with?('%') ? "h#{h.chomp('%')}percent" : "h#{h}")
        end
        style = style_parts.join
        img = "![#{alt}](#{src})"
        style.empty? ? img : "<!-- style:#{style} -->#{img}"
      end
    else
      # No inline image macros: render paragraph content normally
      par.content
    end
  end
  
  # Render an unordered list with proper indentation for nested levels
  def convert_ulist(ulist)
    # indent nested unordered lists (two spaces per nested level) only when under another list item
    if ulist.parent.respond_to?(:node_name) && ulist.parent.node_name == 'list_item'
      indent = '  ' * (ulist.level - 1)
    else
      indent = ''
    end
    # Render unordered list items, indenting nested lines, and ensure trailing newline
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
  
  # Render a page break directive (<<<) as blank space (skip into next page)
  def convert_page_break(node)
    ''
  end
  
  # Render a thematic break (''' delimited) as a horizontal rule
  def convert_thematic_break(node)
    '---'
  end
  
  # Render a video macro as a YouTube iframe embed
  def convert_video(node)
    # Extract video id and dimensions
    id = node.attr('target')
    width = node.attr('width')
    height = node.attr('height')
    # Build iframe embed
    lines = []
    lines << '<iframe '
    lines << "  width=\"#{width}\""
    lines << "  height=\"#{height}\""
    lines << "  src=\"https://www.youtube.com/embed/#{id}\""
    lines << '  frameborder="0"'
    lines << '  allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"'
    lines << '  allowfullscreen>'
    lines << '</iframe>'
    lines.join("\n")
  end
  
  # Render a block-level or inline image as a Markdown image with optional dimensions
  def convert_image(node)
    # Determine alternate text: use explicit first positional attribute if provided; otherwise, no alt text
    alt = node.attributes.key?(1) ? node.attributes[1].to_s : ''
    # Determine source URL or path
    src = node.inline? ? node.target : node.attr('target')
    # Extract width and height (may include percentage units)
    width = node.attr('width') || node.attributes[2]
    height = node.attr('height') || node.attributes[3]
    # Build style name: handle numeric and percentage dimensions
    style_parts = []
    if width
      w = width.to_s
      style_parts << (w.end_with?('%') ? "w#{w.chomp('%')}percent" : "w#{w}")
    end
    if height
      h = height.to_s
      style_parts << (h.end_with?('%') ? "h#{h.chomp('%')}percent" : "h#{h}")
    end
    style = style_parts.join
    # Assemble Markdown image
    img = "![#{alt}](#{src})"
    # Prepend style comment only if dimensions were specified
    style.empty? ? img : "<!-- style:#{style} -->#{img}"
  end

  # Render an inline image using the same logic as block-level image
  alias convert_inline_image convert_image

  # Render inline quoted text (e.g., *text*) as Markdown++ strong syntax
  def convert_inline_quoted(node)
    # Always use double asterisks to denote quoted text
    "**#{node.text}**"
  end
  
  # Render an admonition block as a Markdown++ styled block
  # Emit a style comment and a blockquote for each content line
  def convert_admonition(node)
    # Build style tag (e.g., AdmonitionNote, AdmonitionTip)
    style = "Admonition#{node.caption}"
    # Gather content lines: use nested blocks if present, else raw lines
    if node.blocks.any?
      # convert each child block and accumulate its lines
      content = node.blocks.map { |b| convert(b) }.join("\n")
      lines = content.lines.map(&:chomp)
      suffix = ''
    else
      # fallback to raw source lines for short-form admonition
      lines = node.lines.map(&:chomp)
      suffix = "\n"
    end
    # Quote each line
    quoted = lines.map { |line| "> #{line}" }.join("\n")
    # Prepend style comment and content, with optional suffix
    "<!-- style:#{style} -->\n" + quoted + suffix
  end

  # Render an example block (==== delimited) as nested blockquote lines
  def convert_example(node)
    # indent level for example block
    indent_str = '>'
    prefix_str = indent_str + ' '
    lines = []
    node.blocks.each_with_index do |b, idx|
      if b.node_name == 'listing'
        # nested listing block: increase indent
        content = convert_listing(b)
        nested_indent = '>' * 2
        nested_prefix = nested_indent + ' '
        content.split("\n", -1).each do |line|
          if line.empty?
            lines << nested_prefix
          else
            lines << nested_prefix + line
          end
        end
      else
        content = convert(b)
        content.split("\n", -1).each do |line|
          if line.empty?
            lines << indent_str
          else
            lines << prefix_str + line
          end
        end
      end
      # separator blank line between blocks
      if idx < node.blocks.size - 1
        # first separator without space, subsequent with space
        if idx == 0
          lines << indent_str
        else
          lines << prefix_str
        end
      end
    end
    lines.join("\n")
  end

  # Render a literal block (.... delimited) as a code fence
  def convert_literal(node)
    lines = node.lines
    # Wrap literal block in Markdown++ code fence
    "```\n" + lines.join("\n") + "\n```"
  end

  # Render a listing block (---- delimited) or source blocks as Markdown++ code fences
  def convert_listing(node)
    # Simple listing blocks outside of example context: no language code fence
    if node.style == 'listing' && node.parent.node_name != 'example'
      return "```\n" + node.lines.join("\n") + "\n```"
    end
    # Named source code fence outside of example context: include language
    if node.style == 'source' && node.parent.node_name != 'example'
      lang = node.attr('language') || node.attributes[2]
      return "```#{lang}\n" + node.lines.join("\n") + "\n```"
    end
    # Fallback: convert content groups into paragraphs or headings
    lines = node.lines
    groups = []
    current = []
    lines.each do |line|
      if line.strip.empty?
        groups << current unless current.empty?
        current = []
      else
        current << line
      end
    end
    groups << current unless current.empty?
    parts = groups.map do |group|
      if group.size == 1 && (m = group[0].match(/^(=+)\s*(.*)/))
        level = m[1].length
        "#{'#' * level} #{m[2]}"
      else
        group.join(' ')
      end
    end
    parts.join("\n\n")
  end
  
  # Render a table as a Markdown++ table, handling both simple and multiline cases
  def convert_table(node)
    # Determine Markdown++ style tag
    style = node.attr('role')
    # Fallback: simple table conversion via AST for tables with more than 2 columns
    ast_rows = node.rows
    if (ast_rows.respond_to?(:head) && ast_rows.respond_to?(:body) ? (ast_rows.head.first || []).size > 2 : (node.attr('cols') || '').split(',').size > 2)
      # AST-based simple table: pad columns to equal width
      header_cells = ast_rows.respond_to?(:head) ? (ast_rows.head.first || []) : []
      body_ast = ast_rows.respond_to?(:body) ? ast_rows.body : (begin arr = []; node.rows.each { |r| arr << r.cells }; arr.drop(1) end)
      # Extract texts
      header_texts = header_cells.map(&:text)
      body_texts   = body_ast.map { |cells| cells.map(&:text) }
      # Compute max length per column, defaulting missing entries to 0
      max_lens = header_texts.map(&:length)
      body_texts.each do |row|
        row.each_with_index do |text, idx|
          current = max_lens[idx] || 0
          max_lens[idx] = text.length if text.length > current
        end
      end
      # Column widths with padding
      widths = max_lens.map { |l| l + 2 }
      # Build header line
      hdr_cells = header_texts.each_with_index.map { |h, i| h.ljust(widths[i] - 2) }
      header_line = "| " + hdr_cells.join(' | ') + " |"
      # Build alignment line
      align_line = '|' + widths.map { |w| '-' * w }.join('|') + '|' 
      # Build body lines
      body_lines = body_texts.map do |row|
        cells = row.each_with_index.map { |text, i| text.ljust(widths[i] - 2) }
        "| " + cells.join(' | ') + " |"
      end
      # Style comment
      comment = style ? "<!-- style:#{style} -->" : ''
      return [comment, header_line, align_line, *body_lines].reject(&:empty?).join("\n")
    end
    # Locate raw source file and read lines; if file unreadable, fallback to simple AST conversion
    src_file = node.document.attr('docfile')
    begin
      src_lines = File.readlines(src_file)
    rescue
      # Fallback to simple AST-based table conversion
      header_cells = ast_rows.respond_to?(:head) ? (ast_rows.head.first || []) : []
      body_ast = ast_rows.respond_to?(:body) ? ast_rows.body : (begin arr = []; node.rows.each { |r| arr << r.cells }; arr.drop(1) end)
      header_texts = header_cells.map(&:text)
      body_texts = body_ast.map { |cells| cells.map(&:text) }
      max_lens = header_texts.map(&:length)
      body_texts.each do |row|
        row.each_with_index { |text, idx| max_lens[idx] = text.length if text.length > max_lens[idx] }
      end
      widths = max_lens.map { |l| l + 2 }
      hdr_cells = header_texts.each_with_index.map { |h, i| h.ljust(widths[i] - 2) }
      header_line = "| " + hdr_cells.join(' | ') + " |"
      align_line = '|' + widths.map { |w| '-' * w }.join('|') + '|'
      body_lines = body_texts.map do |row|
        cells = row.each_with_index.map { |text, i| text.ljust(widths[i] - 2) }
        "| " + cells.join(' | ') + " |"
      end
      comment = style ? "<!-- style:#{style} -->" : ''
      return [comment, header_line, align_line, *body_lines].reject(&:empty?).join("\n")
    end
    # If table is not fenced with grid markers, fallback to simple AST conversion
    unless src_lines.any? { |l| l.strip == '|===' }
      header_cells = ast_rows.respond_to?(:head) ? (ast_rows.head.first || []) : []
      body_ast = ast_rows.respond_to?(:body) ? ast_rows.body : (begin arr = []; node.rows.each { |r| arr << r.cells }; arr.drop(1) end)
      header_texts = header_cells.map(&:text)
      body_texts = body_ast.map { |cells| cells.map(&:text) }
      # Safe AST-based fallback: compute column widths
      max_lens = header_texts.map(&:length)
      body_texts.each do |row|
        row.each_with_index do |text, idx|
          current = max_lens[idx] || 0
          max_lens[idx] = text.length if text.length > current
        end
      end
      widths = max_lens.map { |l| (l || 0) + 2 }
      hdr_cells = header_texts.each_with_index.map { |h, i| h.ljust(widths[i] - 2) }
      header_line = "| " + hdr_cells.join(' | ') + " |"
      align_line = '|' + widths.map { |w| '-' * w }.join('|') + '|'
      body_lines = body_texts.map do |row|
        cells = row.each_with_index.map { |text, i| text.ljust(widths[i] - 2) }
        "| " + cells.join(' | ') + " |"
      end
      comment = style ? "<!-- style:#{style} -->" : ''
      return [comment, header_line, align_line, *body_lines].reject(&:empty?).join("\n")
    end
    # Identify table boundaries (fenced with |===)
    start_idx = src_lines.index { |l| l.strip == '|===' }
    end_rel = src_lines[(start_idx + 1)..-1].index { |l| l.strip == '|===' }
    end_idx = start_idx + 1 + (end_rel || 0)
    raw = src_lines[(start_idx + 1)...end_idx]
    # Parse header row
    hdr_line = raw.find { |l| l.strip.start_with?('|') }
    hdr_cols = hdr_line.strip.sub(/^\|/, '').split('|').map(&:strip)
    # Parse body rows: each '| ' marks a new row; details follow until next '|' or end
    rows = []
    body = raw.drop_while { |l| l != hdr_line }[1..] || []
    i = 0
    while i < body.size
      line = body[i]
      if line.strip.start_with?('|')
        # New row header
        header_text = line.strip.sub(/^\|/, '').chomp('+').strip
        # Collect detail lines until next row or table end
        details = []
        i += 1
        while i < body.size && !body[i].strip.start_with?('|')
          txt = body[i].rstrip
          details << txt unless txt.strip.empty?
          i += 1
        end
        rows << { header: header_text, details: details }
      else
        i += 1
      end
    end
    # Post-process details for code and admonition rows
    rows.each do |row|
      details = row[:details]
      # Code block detection
      if details.first =~ /^\[source,.*\]$/
        # Extract lines between '----' fences
        start_idx = details.index('----')
        if start_idx
          end_idx = details[(start_idx + 1)..].index('----')
          code_lines = if end_idx
                         details[(start_idx + 1)...(start_idx + 1 + end_idx)]
                       else
                         details[(start_idx + 1)..]
                       end
        else
          code_lines = details.drop(1)
        end
        row[:details] = ['```'] + code_lines + ['```']
      elsif details.first == '===='
        # Admonition block detection
        detail = details[1] || ''
        cap = detail.split(':', 2).first
        style_name = cap.downcase.capitalize
        row[:details] = ["<!-- style:Admonition#{style_name} -->", "> #{detail}"]
      end
    end
    # Compute column widths: column1 based on headers and row headers; column2 based on header and details
    col1_max = ([hdr_cols[0].length] + rows.map { |r| r[:header].length }).max
    col2_max = ([hdr_cols[1].length] + rows.flat_map { |r| r[:details].map(&:length) }).max
    widths = [col1_max + 2, col2_max + 2]
    # Build style comment: add 'multiline' if any detail contains more than one line
    tags = []
    tags << "style:#{style}" if style
    tags << 'multiline' if rows.any? { |r| r[:details].size > 1 }
    comment = tags.empty? ? '' : "<!-- #{tags.join('; ')} -->"
    # Build header and alignment rows
    header_md = "| " + hdr_cols.each_with_index.map { |h, j| h.ljust(widths[j] - 2) }.join(' | ') + " |"
    # Alignment line: adjust second column width for multiline tables
    align_parts = widths.map.with_index do |w, idx|
      '-' * (idx.zero? ? w : w + 1)
    end
    align_md = '|' + align_parts.join('|') + '|'
    # Assemble table lines
    md = []
    md << comment
    md << header_md
    md << align_md
    rows.each_with_index do |row, idx|
      # First line: header and first detail (or blank)
      md << '|' + ' ' + row[:header].ljust(widths[0] - 2) + ' | ' + (row[:details][0] || '').ljust(widths[1] - 2) + ' |'
      # Additional detail lines
      row[:details][1..].to_a.each do |det|
        md << '|' + ' ' * widths[0] + '|' + ' ' + det.ljust(widths[1] - 2) + ' |'
      end
      # Separator blank row between logical row groups
      unless idx == rows.size - 1
        # Blank separator row: adjust second column width as alignment line
        blank_parts = widths.map.with_index do |w, idx|
          ' ' * (idx.zero? ? w : w + 1)
        end
        md << '|' + blank_parts.join('|') + '|'
      end
    end
    md.join("\n")
  end
end
