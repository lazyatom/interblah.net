$:.unshift File.expand_path("../lib", __FILE__)
require 'rubygems'
require 'bundler/setup'
require 'vanilla'

require 'redcarpet_renderer'
require 'kramdown_renderer'

# This is your application subclass.
class Application < Vanilla::App
end

Application.configure do |config|
  # The root directory of the application; normally the directory this 
  # file is in.
  config.root = File.dirname(File.expand_path(__FILE__))

  # You can partition your snips into subdirectories to keep things tidy.
  # This doesn't affect their URL structure on the site (everything is 
  # flat).
  #
  # You should ensure that the system soup is at the bottom of this list
  # unless you really know what you are doing.
  config.soups = %w(
    soups
    soups/blog
    soups/dynasnips
    soups/site
    soups/wiki
    soups/essays
    soups/system
  )

  # If you don't want the tutorial on your site, remove this and delete the directory
  config.soups << "soups/tutorial"

  config.renderers["markdown"] = Vanilla::Renderers::Kramdown
end