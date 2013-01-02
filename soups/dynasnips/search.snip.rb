class Search < Dynasnip
  def search_form
    %{
      <form method="post" action="" class="search">
      <label for="q">Search</label>
      <input type="text" name="q" />
      <button>Search</button>
      </form>
    }
  end

  def get(*args)
    if app.request.params[:q]
      search
    else
      search_form
    end
  end

  def post(*args)
    search
  end

  private

  def search
    term = app.request.params[:q]
    if term =~ /[^\w\s\-_\.]/
      "<p>Please only use characters, spaces, hyphens, underscores and periods in your search term</p>"
    else
      matches = `fgrep -r "#{term}" {#{app.config.site_soups.join(",")}}`.split("\n")
      search_form + "<h2>Results</h2>" + if matches.any?
        grouped_matches = {}
        matches.each do |match|
          next if match =~ /::/
          parts = match.split(":")
          snip = File.basename(parts.shift.split(".").first)
          context = parts.join
          grouped_matches[snip] ||= []
          grouped_matches[snip] << context
        end
        snips = grouped_matches.keys.sort_by { |s| grouped_matches[s].length }.reverse
        "<ol>" + snips.map do |snip|
          contexts = grouped_matches[snip].map! do |context|
            start = context.index(term)
            context.gsub("{", "&#123;").gsub("}", "&#125;").
              insert(start + term.length, "</span>").
              insert(start, %{<span class="match">}).strip
          end
          %{<li class="search_result">{l #{snip}} &rarr; <i>#{contexts.join(" &hellip; ")}</i></li>}
        end.join + "</ol>"
      else
        %{<p>No matches for "#{term}"</p>}
      end
    end
  end

  self
end
