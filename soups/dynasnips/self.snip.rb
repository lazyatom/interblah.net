dynasnip do |attribute|
  enclosing_snip.__send__ attribute
end
