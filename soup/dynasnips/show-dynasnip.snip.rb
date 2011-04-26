class ShowDynasnip < Dynasnip
  def handle(name = nil)
    name ||= app.request.params[:name]
    snip = app.soup[name]
    "<h1>#{name}</h1>
<p>Usage: #{snip.usage || '(no details)'}</p>
{code #{snip.render_as.downcase},#{name}}
<p>(If the dynasnip only contains a class name, it's probably loaded from the Vanilla application directly. This is typical of the basic dynasnips like link_to, etc)</p>"
  end
  self
end