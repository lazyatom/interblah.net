require "delegate"

class BlogSoupBackend < SimpleDelegator
  def load_snip(name)
    load_snip_with_title_from_content(super)
  end

  def all_snips
    super.map { |s| load_snip_with_title_from_content(s) }
  end

  private

  def load_snip_with_title_from_content(snip)
    if snip && empty_title?(snip)
      if snip.content
        lines = snip.content.split("\n")
        if lines[1] =~ /^=+$/
          snip.title = lines[0]
          snip.content = lines[2..-1].join("\n")
        else
          snip.title = snip.name
        end
      else
        snip.title = snip.name
      end
    end
    snip
  end

  def empty_title?(snip)
    snip.title.nil?
  end
end
