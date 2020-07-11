dynasnip do |*args|
  app.atom_feed(
    domain: "interblah.net",
    title: "interblah.net",
    matching: {kind: "blog"},
    count: 10
  )
end
