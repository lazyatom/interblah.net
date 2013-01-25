require "pygments"
class CodeHighlighter < Dynasnip
  def handle(language, part_to_render='content')
    text = enclosing_snip.__send__(part_to_render.to_sym)
    code = Pygments.highlight(text, :lexer => language, :options => {:encoding => 'utf-8'})
    %(<div class="code ) + language + %(">) + self.class.escape_curly_braces(code) + %(</div>)
  end
end
