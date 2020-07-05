class Excerpt < Dynasnip
  def handle(snip_name, lines = 3)
    snip = app.soup[snip_name]
    lines = app.render(snip).split("\n")[0..lines.to_i]
    lines.join("\n") +
      "{link_to #{snip_name}, 'Read more&hellip;'}"
  end
  self
end
