require 'capistrano/setup'

set :stage, "production"

set :application, 'interblah.net'
server "interblah.net", roles: [:app], user: local_user

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

def apache_vhost_template(port)
  <<-EOS
<VirtualHost *:80>
  ServerName interblah.net
  ServerAlias www.interblah.net

  CustomLog /var/log/apache2/interblah.net.access.log combined

  <Location />
    Order deny,allow
    Allow from all
    Require all granted

    PassengerEnabled off
    ProxyPass http://127.0.0.1:#{port}/
    ProxyPassReverse http://127.0.0.1:#{port}/
  </Location>
</VirtualHost>
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

    def running_app_container_id
      capture "sudo docker ps | grep '#{fetch(:application_image_tag)}' | cut -d ' ' -f1"
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
      capture "sudo docker run -d -P #{fetch(:application_image_tag)}"
    end

    def stop_container(container_id)
      sudo "docker stop #{container_id}"
    end

    task :update_web_server do
      on roles(:app) do
        container_id = running_app_container_id
        new_port = get_host_port_for(container_id, application_exposed_port)
        log "Container running as #{Color.yellow new_container_id[0..12]}, on port #{Color.blue new_port}"
        log "Updating web server..."
        update_web_server_config(new_port)
        reload_web_server
        log "Web server refreshed"
      end

    end

    task :stop do
      on roles(:app) do
        container_id = running_app_container_id
        if container_id
          stop_container(container_id)
        else
          "No running container found"
        end
      end
    end

    task :start do
      on roles(:app) do
        log "Starting new container..."
        new_container_id = start_container
        new_port = get_host_port_for(new_container_id, application_exposed_port)
        log "New container #{Color.yellow new_container_id[0..12]}, on port #{Color.blue new_port}"
        log "Updating web server..."
        update_web_server_config(new_port)
        reload_web_server
        log "New container started and live"
      end
    end

    task :restart do
      on roles(:app) do
        if test("sudo docker ps | grep '#{fetch(:application_image_tag)}'")
          original_container_id = running_app_container_id
          log "Found running container #{Color.yellow original_container_id}"
        else
          log "No running containers exist"
        end
        invoke "docker:remote:start"
        if original_container_id
          log "Stopping old container #{Color.yellow original_container_id}"
          stop_container(original_container_id)
        end
      end
    end
  end
end
