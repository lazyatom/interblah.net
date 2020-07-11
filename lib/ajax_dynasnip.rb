require 'vanilla/dynasnip'

class AjaxDynasnip < Vanilla::Dynasnip
  def handle(*args)
    if app.request.instance_eval { @rack_request }.xhr?
      __normal_handle
    else
      url = url_to(__snip_name)
      %{<a class="vanilla_ajax" href="#{url}">#{__snip_name}</a>}
    end
  end

  private
  
  def __snip_name
    # borrowed from ActiveSupport
    self.class.name.split("::").last.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end

  # When subclasses define 'handle', we actually want to move that out of
  # the way, so that the parent definition is called; it will decide whether
  # or not to generate the Ajax javascript, or actually run the dynasnip
  def self.method_added(method)
    unless method.to_s =~ /^__normal_/
      alias_method :"__normal_#{method}", method
      remove_method method
    end
  end
end
