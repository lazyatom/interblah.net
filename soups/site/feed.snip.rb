require "vanilla/dynasnip"

class Feed < Dynasnip
  def handle(*args)
    app.atom_feed({
      :domain => "interblah.net",
      :title => "interblah.net",
      :matching => {:kind => "blog"},
      :count => 10
    })
  end
  self
end
