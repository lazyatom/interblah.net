$:.unshift File.join(File.dirname(__FILE__), *%w[lib])
require 'vanilla'

app = Vanilla::App.new
use Rack::Session::Cookie, :key => 'vanilla.session',
                           :path => '/',
                           :expire_after => 2592000,
                           :secret => app.config[:secret]
use Rack::Static, :urls => ["/public"]
run app