require 'vanilla/dynasnip'
require 'vanilla/dynasnips/login'

class Delete < Dynasnip
  include Login::Helper

  def handle
    return login_required unless logged_in?
    name = app.request.params[:snip_to_delete]
    snip_to_delete = app.soup[name]
    snip_to_delete.destroy if snip_to_delete
    "Snip #{name} has been deleted."
  end
  self
end