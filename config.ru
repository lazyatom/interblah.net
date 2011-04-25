$:.unshift File.join(File.dirname(__FILE__), *%w[lib])
require "rubygems"
require "bundler/setup"
require 'vanilla'
require 'vanilla/static'

require 'redcarpet_renderer'

app = Vanilla::App.new({
  :soups => %w(
    soup
    soup/blog
    soup/dynasnips
    soup/site
    soup/wiki
    soup/tutorial
    soup/essays
    soup/system
    soup/system/dynasnips
  ),
  :extensions => {
    "markdown" => "Redcarpet"
  }
})

require 'compass'
require 'sass/plugin/rack'

Compass.add_project_configuration(File.expand_path("../config/compass.rb", __FILE__))
Compass.configure_sass_plugin!
use Sass::Plugin::Rack

use Vanilla::Static, File.expand_path("../public", __FILE__)
use Rack::ShowExceptions
run app