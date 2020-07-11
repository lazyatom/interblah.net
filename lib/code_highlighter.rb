require 'rouge'

class CodeHighlighter < Vanilla::Dynasnip
  def handle(part_to_render='content', language=nil, start_line=0, end_line=-1)
    text = enclosing_snip.__send__(part_to_render.to_sym)
    if text.nil?
        return "Unknown part to render '#{part_to_render}' for snip #{enclosing_snip.name}"
    end
    start_line = start_line.to_i
    end_line = end_line.to_i
    text = text.split("\n")[start_line..end_line].join("\n")
    # code = Pygments.highlight(text, :lexer => language, :options => {:encoding => 'utf-8'})
    lexer = Rouge::Lexer.find_fancy(language || 'guess', text)
    lexer = Rouge::Lexer.find_fancy('guess', text) unless lexer
    code = Rouge::Formatters::HTML.new.format(lexer.lex(text))
    %(<pre><div class="code ) + lexer.tag + %(">) + self.class.escape_curly_braces(code) + %(</div></pre>)
  rescue => e
    %{<p class="error">Error highlighting #{part_to_render}: #{e.message}</p><pre>#{e.backtrace.join("\n")}</pre>}
  end
end
