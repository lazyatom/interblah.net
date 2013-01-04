$:.unshift File.expand_path("../lib", __FILE__)
require 'rubygems'
require 'bundler/setup'
require 'vanilla'

require 'redcarpet_renderer'
require 'kramdown_renderer'
require 'blog_soup_backend'

# This is your application subclass.
class Application < Vanilla::App
end

Application.configure do |config|
  # The root directory of the application; normally the directory this
  # file is in.
  config.root = File.dirname(File.expand_path(__FILE__))

  config.site_soups = %w(
    soups/blog
    soups/wiki
    soups/essays
    soups/tutorial
    soups/drafts
  )
  site_backends = config.site_soups.map do |path|
    BlogSoupBackend.new(::Soup::Backends::FileBackend.new(File.expand_path(path, config.root)))
  end

  config.indexable_soup = ::Soup::Backends::MultiSoup.new(*site_backends)

  system_backends = %w(
    soups
    soups/dynasnips
    soups/site
    soups/system
  ).map do |path|
    ::Soup::Backends::FileBackend.new(File.expand_path(path, config.root))
  end

  config.soup = ::Soup.new(::Soup::Backends::MultiSoup.new(*([config.indexable_soup] + system_backends)))

  config.renderers["markdown"] = Vanilla::Renderers::Kramdown
end
