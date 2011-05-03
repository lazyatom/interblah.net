class MostRecent < Dynasnip
  def handle(arguments)
    snips = app.soup[:kind => arguments[:kind]].sort_by { |s| s.created_at || -1 }.reverse
    snips[0..(arguments[:limit].to_i-1)].map { |s| "{in-template snip:#{s.name}, template:#{arguments[:template]}}" }.join("")
  end
  self
end