dynasnip do |snip_name, lines = 3|
  snip = app.soup[snip_name]
  lines = app.render(snip).split("\n").reject { |l| l.strip == '' }[0..lines.to_i]
  lines.join("\n")
end
