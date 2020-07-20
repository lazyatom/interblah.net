class LinkToCurrentSnip < Vanilla::Dynasnip
  usage %|
    Renders a link to the current snip
  |

  def handle(*args)
    %{<a class="u-url" href="#{url_to(app.request.snip_name)}">#{app.request.snip_name}</a>}
  end

  self
end
