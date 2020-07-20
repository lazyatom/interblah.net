class SnipDetails < Vanilla::Dynasnip
  def handle(snip_name=nil)
    if snip = snip_name ? app.soup[snip_name] : app.request.snip
      created_at_string = display(snip.created_at)
      updated_at_string = display(snip.updated_at)
      details = %{<time class="dt-published" datetime="#{machine_readable snip.created_at}">#{created_at_string}</time>}
      details += %{; updated <time datetime="#{machine_readable snip.updated_at}">#{updated_at_string}</time>} unless updated_at_string == created_at_string
      details += %{ <a rel="author" class="p-author h-card" href="/">James Adam</a>}
      details
    end
  end

  private

  def machine_readable(time)
    time.strftime("%Y-%m-%dT%H:%M:%S")
  end

  def display(time)
    time.strftime("%B %e, %Y")
  end

  self
end
