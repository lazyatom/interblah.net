require 'vanilla/dynasnip'

class LinkTo < Dynasnip
  usage %|
The link_to dyna lets you create links between snips: 

  {link_to blah} 

would insert a link to the blah snip.|

  def handle(name=nil, link_text=nil, part=nil)
    return usage if requesting_this_snip?
    return "You must provide a snip name" unless name
    snip = app.soup[name]
    if snip
      link_text ||= snip.title || name
      %{<a href="#{url_to(name, part)}">#{link_text}</a>}
    else
      %{<a class="missing" href="#{url_to(name, part)}">#{link_text}</a>}
    end
  end

  self
end
