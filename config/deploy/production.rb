
set :user, "deploy"
set :unicorn_workers, 6
set :nginx_server_name, 'test-data.loveit.com'
set :newrelic_enabled, true
set :rails_env, "production"

server "redoubt.omste.com", :web, :app
