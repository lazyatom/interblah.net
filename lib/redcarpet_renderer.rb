require "redcarpet"

class Vanilla::Renderers::Redcarpet < Vanilla::Renderers::Base
  def process_text(content)
    Redcarpet.new(content, :smart, :autolink).to_html
  end
end
