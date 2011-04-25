require 'vanilla/dynasnip'

class LinkToCurrentSnip < Dynasnip
  def handle(attribute=nil)
    if attribute
      link_to app.request.snip.__send__(attribute), app.request.snip_name
    else
      link_to app.request.snip_name
    end
  end    

  self
end