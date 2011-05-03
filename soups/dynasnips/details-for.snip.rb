class DetailsFor < Dynasnip
  def handle(snip_name)
    if snip = app.soup[snip_name]
      details = %{#{link_to snip.name} was originally written on #{snip.created_at.strftime("%B %d, %Y")} at #{snip.created_at.strftime("%H:%M")}}
      details += %{ and updated on #{snip.updated_at.strftime("%B %d, %Y")} at #{snip.updated_at.strftime("%H:%M")}} unless snip.updated_at == snip.created_at
      details + "."
    end
  end
  self
end