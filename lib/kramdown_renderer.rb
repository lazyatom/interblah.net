require 'kramdown/document'

class Vanilla::Renderers::Kramdown < ::Vanilla::Renderers::Base
  def process_text(content)
    puts "processing"
    Kramdown::Document.new(content).to_html
  end
end