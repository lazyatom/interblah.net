class TitleFor < Dynasnip
  def handle(snip_name=nil, tag="h1")
    snip = snip_name ? app.soup[snip_name] : app.request.snip
    text = snip.title || snip.name
    %{<#{tag}>#{text}</#{tag}>}
  end
  self
end
