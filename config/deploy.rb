# we are using multistage
set :default_stage, "production"

set :application, "test-data"

set :scm, :git
set :repository,  "git@github.com:juvomedia/test-data.git"
set :deploy_via, :remote_cache

set :user, 'ubuntu'
set(:deploy_to) { "/home/#{user}/#{application}" }

default_run_options[:pty] = true # required for password based sudo
set :ssh_options, {
  forward_agent:true  # github access, unless we decide to use a deploy key?
}

set :nginx_use_ssl, true
set :nginx_ssl_certificate,     "star.loveit.com.crt"
set :nginx_ssl_certificate_key, "star.loveit.com.key"

set :newrelic_engineyard_key, 'b92148772c1356d0aeeb6d7488dd3d9e73505de5'
set :newrelic_loveit_key,       'ce6708f18204f450c7750ae8b3fba5bf50007915'
set(:newrelic_license_key) { newrelic_loveit_key }

set :unicorn_env, 'unicorn'

set :bundle_flags,    '--deployment'
set :rvm_ruby_string, "ruby-1.9.3-p125@discovered"
set :rvm_type, :user

before 'deploy:setup',     'rvm:install_ruby'
before 'rvm:install_ruby', 'rvm:install_rvm'

# not sure why but this has to be loaded after other stuff.
require 'capistrano/ext/multistage'

require 'capistrano-nginx-unicorn'
# set with a block for lazy evaluation,  in the capistrano-nginx-unicorn gem
# they are set as strings
set(:unicorn_pid)    { "#{current_path}/tmp/pids/unicorn.pid" }
set(:unicorn_config) { "#{shared_path}/config/unicorn.rb" }
set(:unicorn_log)    { "#{shared_path}/log/unicorn.log" }
set(:unicorn_user)   { user }
reset! :deploy_to
reset! :current_path
reset! :shared_path


require 'rvm/capistrano'
require 'bundler/capistrano'

Dir['config/deploy/{lib,recipes}/**/*.rb'].each { |f| load f }

#_cset(:branch) { Capistrano::CLI.ui.ask "Branch to launch (or use -S branch=BRANCH): "}
_cset(:branch) { "master" }

after  'deploy',           'rvm:trust_rvmrc'  # https://rvm.io/integration/capistrano/
namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end
