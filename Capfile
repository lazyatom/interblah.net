require 'recap/tasks/deploy'
require 'recap/tasks/bundler'

set :application_user, "interblah"
set :application, 'interblah.net'
set :repository, 'git@github.com:lazyatom/interblah.net.git'

server "interblah.net", :app

set :deploy_to, '/home/interblah/apps/interblah.net'

namespace :deploy do
  task :restart do
    as_app "mkdir -p tmp && touch tmp/restart.txt"
  end
end
