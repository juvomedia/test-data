# overriding stuff from capistrano-nginx-unicorn gem
namespace :unicorn do
  task :restart, roles: :app do
    run "service unicorn_#{application} reload"
  end

  task :force_restart, roles: :app  do
    run "service unicorn_#{application} restart"
  end
end
