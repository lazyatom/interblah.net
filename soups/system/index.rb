class Index < Vanilla::Dynasnip
  def get(*args)
    list = app.soup.all_snips.sort_by { |a| a.updated_at || Time.at(0) }.reverse.map { |snip|
      %{<li>{l "#{snip.name}"}</li>}
    }.join
    %{<ol id="index">#{list}</ol>}
  end

  self
end
