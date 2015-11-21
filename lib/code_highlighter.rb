require "pygments"
class CodeHighlighter < Dynasnip
  def handle(part_to_render='content', language='ruby', start_line=0, end_line=-1)
    text = enclosing_snip.__send__(part_to_render.to_sym)
    start_line = start_line.to_i
    end_line = end_line.to_i
    text = text.split("\n")[start_line..end_line].join("\n")
    code = Pygments.highlight(text, :lexer => language, :options => {:encoding => 'utf-8'})
    %(<div class="code ) + language + %(">) + self.class.escape_curly_braces(code) + %(</div>)
  rescue
    %{<p class="error">Error highlighting #{part_to_render}</p>}
  end
end
