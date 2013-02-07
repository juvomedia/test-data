

namespace :deploy do

  # override task from capistrano.  add the chown.
  task :setup, :except => { :no_release => true } do
    dirs = [deploy_to, releases_path, shared_path]
    dirs += shared_children.map { |d| File.join(shared_path, d.split('/').last) }
    dirs = dirs.join(' ')
    run "#{try_sudo} mkdir -p #{dirs}"
    run "#{try_sudo} chown -R #{user} #{dirs} "
    run "#{try_sudo} chmod g+w #{dirs}" if fetch(:group_writable, true)
  end

end
