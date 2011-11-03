require 'recap/deploy'

server "interblah.net", :app

set :application_user, "interblah"
set :repository, 'git@github.com:lazyatom/interblah.net.git'
set :application, 'interblah.net'
set :deploy_to, "/var/apps/#{application}"

namespace :deploy do
  task :restart do
    run "cd #{deploy_to} && mkdir -p tmp && touch tmp/restart.txt"
  end
end