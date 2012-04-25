require "vanilla/dynasnip"

class Feed < Dynasnip
  def handle(*args)
    app.atom_feed({
      :domain => "interblah.net",
      :title => "interblah.net",
      :matching => {:kind => "blog"},
    })
  end
  self
end