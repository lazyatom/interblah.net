class DetailsForCurrentSnip < Dynasnip
  def handle(*args)
    if snip = app.request.snip
      created = snip.created_at.strftime("%B %d, %Y")
      updated = snip.updated_at.strftime("%B %d, %Y")
      details = %{Written on #{created}}
      details += %{ / updated on #{updated}} unless updated == created
      details
    end
  end
  self
end
