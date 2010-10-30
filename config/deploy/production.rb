server "178.79.132.137", :app, :web, :db, :primary => true

set :environment, 'production'

manifest :app, %{
  interblah::app {"interblah.net":
    deploy_to => "<%= deploy_to %>"
  }
}
