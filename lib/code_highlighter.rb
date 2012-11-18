require 'syntax/convertors/html'
class CodeHighlighter < Dynasnip
  def handle(language, part_to_render='content')
    text = enclosing_snip.__send__(part_to_render.to_sym)
    convertor = Syntax::Convertors::HTML.for_syntax(language)
    code = convertor.convert(text, false)
    %(<pre class="code ) + language + %("><code>) + self.class.escape_curly_braces(code) + %(</code></pre>)
  end
end
