dynasnip do |snip_name, lines = 3|
  snip = app.soup[snip_name]
  all_lines = app.render(snip).split("\n").reject { |l| l.strip == '' }
  lines_to_show = if (index = all_lines.index('<!-- excerpt -->')) != nil
    all_lines[0..index]
  else
    all_lines[0..lines.to_i]
  end
  lines_to_show.join("\n")
end
