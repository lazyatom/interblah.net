require 'tomafro/deploy'

server "interblah.net", :app

set :application_user, "interblah"
set :repository, 'git@github.com:lazyatom/interblah.net.git'
set :application, 'interblah.net'

namespace :deploy do
  task :restart do
    run "cd #{deploy_to} && mkdir -p tmp && touch tmp/restart.txt"
  end
end