class SnipDetails < Dynasnip
  def handle(snip_name=nil)
    if snip = snip_name ? app.soup[snip_name] : app.request.snip
      details = %{<time datetime="#{snip.created_at.strftime("%Y-%m-%dT%H:%M:%S")}">#{snip.created_at.strftime("%B %d %Y")}</time>}
      details += %{; updated <time datetime="#{snip.updated_at.strftime("%Y-%m-%dT%H:%M:%S")}">#{snip.updated_at.strftime("%B %d %Y")}</time>} unless snip.updated_at == snip.created_at
      details
    end
  end
  self
end
