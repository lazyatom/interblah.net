require 'vanilla/dynasnip'

class PageTitle < Dynasnip
  def handle
    if app.request.snip
      app.request.snip.page_title ||
        app.request.snip.title ||
        app.request.snip.name
    end
  end

  self
end
