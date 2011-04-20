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
use Vanilla::Static, File.join(File.dirname(__FILE__), 'public')
run app