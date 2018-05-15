$:.unshift File.join(File.dirname(__FILE__), "lib")
$:.unshift File.join(File.dirname(__FILE__))
require "rubygems"
require "bundler/setup"
require 'vanilla'
require 'vanilla/static'

require "application"

use Vanilla::Static, File.expand_path("../public", __FILE__)

# Setup Raygun and add it to the middleware
require 'raygun'
Raygun.setup do |config|
  config.api_key = ENV["RAYGUN_API_KEY"]
end
use Raygun::Middleware::RackExceptionInterceptor

# Raygun will re-raise the exception, so catch it with something else
use Rack::ShowExceptions

run Application.new
