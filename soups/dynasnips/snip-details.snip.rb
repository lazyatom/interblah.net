class SnipDetails < Dynasnip
  def handle(snip_name=nil)
    if snip = snip_name ? app.soup[snip_name] : app.request.snip
      details = %{Written on #{snip.created_at.strftime("%B %d %Y")} at #{snip.created_at.strftime("%H:%M")}}
      details += %{ and updated on #{snip.updated_at.strftime("%B %d %Y")} at #{snip.updated_at.strftime("%H:%M")}} unless snip.updated_at == snip.created_at
      details
    end
  end
  self
end
