# puma-dev is launched by launchd without LANG/LC_* set, so Ruby's default
# external encoding is US-ASCII and reading UTF-8 snip files fails with
# Encoding::CompatibilityError. Force UTF-8 here so launch environment doesn't matter.
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

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
use Rack::CommonLogger

run Application.new
