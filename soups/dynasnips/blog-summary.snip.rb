class BlogSummary < Dynasnip
  def handle(snip_name)
    snip = app.soup[snip_name]
    if snip.summary
      "<aside>#{snip.summary}</aside>"
    end
  end
  self
end
