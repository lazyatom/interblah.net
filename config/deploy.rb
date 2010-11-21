set :stages, %w(production)
set :default_stage, "production"

require 'freerange/deploy'
require 'freerange/puppet'
require 'lazyatom/deploy'

set :repository, 'git@github.com:lazyatom/interblah.net.git'
set :application, 'interblah.net'

namespace :deploy do
  task :migrate do ; end
end