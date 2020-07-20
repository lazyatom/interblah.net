require 'link_to'

class TitleFor < Vanilla::Dynasnip
  def handle(snip_name=nil, tag="h1")
    snip = snip_name ? app.soup[snip_name] : app.request.snip
    if snip
      text = snip.title || snip.name
    else
      text = "Missing snip '#{snip_name || app.request.snip_name}'"
    end
    "<#{tag}>" +
      %{<a class="u-url" href="#{url_to(snip.name)}">#{text}</a>} +
      "</#{tag}>"
  end
  self
end
