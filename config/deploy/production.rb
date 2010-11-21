server "178.79.132.137", :app, :web, :db, :primary => true

set :environment, 'production'

manifest :app, %{
  lazyatom::app {"interblah.net":
    deploy_to => "<%= deploy_to %>",
    vhost_additions => [
      'Alias /assets "<%= deploy_to %>/shared/assets"',
      'RedirectMatch 301 ^/2006/\d+/\d+/(.+) "/$1"',
      'RedirectMatch 301 ^/2007/\d+/\d+/(.+) "/$1"',
      'RedirectMatch 301 ^/2008/\d+/\d+/(.+) "/$1"'
    ]
  }
}