$:.unshift File.join(File.dirname(__FILE__), *%w[lib])
require "rubygems"
require "bundler/setup"
require 'vanilla'
require 'vanilla/static'

require "application"

require 'compass'
require 'sass/plugin/rack'

Compass.add_project_configuration(File.expand_path("../config/compass.rb", __FILE__))
Compass.configure_sass_plugin!
use Sass::Plugin::Rack

use Vanilla::Static, File.expand_path("../public", __FILE__)
use Rack::ShowExceptions
run Application.new