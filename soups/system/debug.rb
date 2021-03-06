require 'cgi'

# If the dynasnip is a subclass of Vanilla::Dynasnip, it has access to the request hash
# (or whatever - access to some object outside of the snip itself.)
class Debug < Vanilla::Dynasnip
  def get(*args)
    CGI.escapeHTML(app.request.inspect)
  end

  def post(*args)
    "You posted! " + CGI.escapeHTML(app.request.inspect)
  end
  self
end
