dynasnip do |arguments|
  snips = app.soup[:kind => arguments[:kind]].sort_by { |s| s.created_at || -1 }.reverse
  offset = (arguments[:offset] || 0).to_i
  limit = offset + (arguments[:count].to_i-1)
  snips[offset..limit].map { |s| "{in-template snip:#{s.name}, template:#{arguments[:template]}}" }.join("")
end
