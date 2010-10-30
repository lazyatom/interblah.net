set :stages, %w(production)
set :default_stage, "production"

require 'freerange/deploy'
require 'freerange/puppet'

set :repository, 'git@github.com:lazyatom/interblah.net.git'
set :application, 'interblah.net'

set :user, `whoami`.strip
set :group, 'application'

set :puppet_user, 'root'
set :puppet_os, 'ubuntu'

namespace :deploy do
  task :migrate do ; end
end

namespace :host do
  task :setup do ; end
  task :create do ; end
end

namespace :redis do
  task :setup do ; end
end

namespace :monit do
  task :setup do ; end
end