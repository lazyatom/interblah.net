require 'capistrano/setup'

set :stage, "production"

set :application, 'interblah.net'
server "interblah.net", roles: [:app], user: local_user
# server "localdocker", roles: [:app], user: local_user

set :local_docker, "localdocker:2375"
set :index, "docker.lazyatom.com"

set :application_image_tag, "#{fetch(:index)}/#{fetch(:application)}"

set :web_server_vhost_conf, "/etc/apache2/sites-available/#{fetch(:application)}.conf"

def application_exposed_port
  File.readlines("Dockerfile").select { |l| l =~ /EXPOSE/ }.first.split(" ").last
end

def ldocker(command)
  execute "docker -H #{fetch(:local_docker)} #{command}"
end

def apache_vhost_template(ports)
  balancers = ports.map { |port| "BalancerMember http://127.0.0.1:#{port}" }.join("\n")
  <<-EOS
<VirtualHost *:80>
  ServerName interblah.net
  ServerAlias www.interblah.net

  CustomLog /var/log/apache2/interblah.net.access.log combined

  <Proxy balancer://interblah.net>
    #{balancers}
    ProxySet lbmethod=byrequests
  </Proxy>

  <Location />
    Order deny,allow
    Allow from all
    Require all granted

    PassengerEnabled off
    ProxyPass balancer://interblah.net/
    ProxyPassReverse balancer://interblah.net/
  </Location>
</VirtualHost>
  EOS
end

def nginx_vhost_template(ports)
  balancers = ports.map { |port| "server 127.0.0.1:#{port};" }.join("\n")
  <<-EOS
upstream interblah.net {
  #{balancers}
}

server {
  gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;

  server_name interblah.net;

  location / {
    proxy_pass http://interblah.net;
    include /etc/nginx/proxy_params;
  }
}
  EOS
end

task :deploy do
  invoke "docker:update_code:using_registry"
  invoke "docker:remote:restart"
end

namespace :docker do
  namespace :update_code do
    task :using_registry do
      invoke "docker:local:build"
      invoke "docker:local:push"
      invoke "docker:remote:pull"
    end

    task :using_remote_docker do
      run_locally do
        execute "docker -H docker.lazyatom.com:2375 build -t #{fetch(:application_image_tag)} ."
      end
    end
  end

  namespace :local do
    task :build do
      run_locally do
        log "Building local image. This may take a few minutes..."
        ldocker "build -t #{fetch(:application_image_tag)} ."
      end
    end

    task :push do
      run_locally do
        log "Pushing image to registry"
        ldocker "push #{fetch(:application_image_tag)}"
      end
    end
  end

  namespace :remote do
    task :pull do
      on roles(:app) do
        sudo "docker pull #{fetch(:application_image_tag)}"
      end
    end

    def running_app_container_ids
      capture("sudo docker ps | grep '#{fetch(:application_image_tag)}' | cut -d ' ' -f1").split("\n").map(&:strip)
    end

    def get_host_port_for(container_id, container_port)
      host_and_port = capture "sudo docker port #{container_id} #{container_port}"
      host_and_port.split(":").last
    end

    def update_web_server_config(new_port)
      upload! StringIO.new(apache_vhost_template(new_port)), "/tmp/docker_vhost"
      sudo "cp #{fetch(:web_server_vhost_conf)} /tmp/#{File.basename(fetch(:web_server_vhost_conf))}.backup"
      sudo "mv /tmp/docker_vhost #{fetch(:web_server_vhost_conf)}"
    end

    def reload_web_server
      sudo "service apache2 reload"
    end

    def start_container
      sudo "docker run -d -P #{fetch(:application_image_tag)}"
    end

    def stop_container(container_id)
      sudo "docker stop #{container_id}"
    end

    task :update_web_server do
      on roles(:app) do
        container_ids = running_app_container_ids
        containers_to_ports = container_ids.inject({}) { |h, id| h[id] = get_host_port_for(id, application_exposed_port); h }
        container_ports = containers_to_ports.values
        info_string = containers_to_ports.map { |k,v| "#{Color.yellow(k[0..12])} (port #{Color.blue(v)})" }.join(", ")
        log "Containers running: #{info_string}"
        log "Updating web server..."
        update_web_server_config(container_ports)
        reload_web_server
        log "Web server refreshed"
      end

    end

    task :stop do
      on roles(:app) do
        container_ids = running_app_container_ids
        if container_ids.any?
          container_ids.each { |id| stop_container(id) }
        else
          "No running container found"
        end
      end
    end

    task :start do
      on roles(:app) do
        log "Starting new container..."
        start_container
        invoke "docker:remote:update_web_server"
        log "New container started and live"
      end
    end

    task :restart do
      on roles(:app) do
        original_container_ids = running_app_container_ids
        if original_container_ids.any?
          log "Found running containers #{original_container_ids.map { |id| Color.yellow id }.join(', ')}"
        else
          log "No running containers exist"
        end
        start_container
        if original_container_ids.any?
          log "Stopping old containers #{original_container_ids.map { |id| Color.yellow id }.join(', ')}"
          original_container_ids.each { |id| stop_container(id) }
        end
        invoke "docker:remote:update_web_server"
      end
    end
  end
end
