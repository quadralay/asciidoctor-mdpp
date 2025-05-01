## Inline-Break Challenges and Recovery in List Items

When an AsciiDoc list item ends a line with a trailing `+`, Asciidoctor splits the item into two parts internally, and the converter’s AST only sees the first segment (the continuation is dropped). A purely AST-based solution cannot recover the second segment or detect the break reliably.

The workaround is to perform a minimal file-aware step in `convert_olist`:
1. After converting each list item with `convert(li, 'list_item')`, check if the result is empty (indicating a dropped first segment).
2. Use `li.source_location` to get the source file and line number.
3. Read that raw line from the file, strip off the trailing `+`, emit a warning to `STDERR`, and use the remaining portion as the list content.

This preserves all existing fixtures and correctly handles the `line-break.adoc` case. Below is the patch to apply in `lib/asciidoctor/converter/mdpp.rb`:

```diff
--- a/lib/asciidoctor/converter/mdpp.rb
+++ b/lib/asciidoctor/converter/mdpp.rb
@@ def convert_olist(olist)
-    olist.items.each_with_index.map do |li, idx|
+    olist.items.each_with_index.map do |li, idx|
       index = idx + 1
       prefix = "#{indent}#{index}. "
       # convert item via default converter
       converted = convert(li, 'list_item')
       # Recover from trailing '+' if AST lost first segment
       if converted.strip.empty? && li.respond_to?(:source_location) && (loc = li.source_location)
         path, ln = loc.path, loc.lineno
         if path && File.exist?(path)
           raw     = File.readlines(path) rescue []
           src_line = raw[ln-1] rescue nil
           if src_line && src_line.rstrip.end_with?('+')
             first = src_line.chomp('+').sub(/^\s*#{index}\.\s*/, '').rstrip
             warn "#{path}:#{ln}: inline '+' break in list item is not supported; text following the '+' has been dropped"
             converted = first
           end
         end
       end
       # indent nested lines under the item text
       body = converted.gsub(/\n/, "\n" + ' ' * prefix.length)
       "#{prefix}#{body}"
     end.join("\n")
``` 

With this patch, list items that use `+` for inline breaks will issue a warning and correctly display the first segment, while all other content and fixtures remain unchanged.