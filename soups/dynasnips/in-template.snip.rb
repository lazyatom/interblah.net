dynasnip do |arguments|
  template_snip = app.soup[arguments[:template]]
  template_snip.content.gsub("SNIP", arguments[:snip])
end
