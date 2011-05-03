class DetailsForCurrentSnip < Dynasnip
  def handle(*args)
    if snip = app.request.snip
      details = %{#{link_to snip.name} was originally written on #{snip.created_at.strftime("%B %d, %Y")}}
      details += %{ and updated on #{snip.updated_at.strftime("%B %d, %Y")}} unless snip.updated_at == snip.created_at
      details + "."
    end
  end
  self
end