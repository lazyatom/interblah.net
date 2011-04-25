class Self < Dynasnip
  def handle(attribute)
    enclosing_snip.__send__ attribute
  end
  self
end