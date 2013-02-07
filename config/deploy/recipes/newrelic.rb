
_cset(:newrelic_enabled, false)
_cset(:newrelic_app_name) { "#{stage} / #{application} (#{rails_env})" }

namespace :newrelic do
  def shared_newrelic_yml
    "#{shared_path}/config/newrelic.yml"
  end
  def symlink_newrelic_yml
    "#{current_release}/config/newrelic.yml"
  end

  after  'deploy:setup', 'newrelic:setup'
  namespace :setup do

    task :default, roles: :app do
      run "mkdir -p #{File.dirname(shared_newrelic_yml)}"
      template("newrelic.yml.erb", shared_newrelic_yml)
    end


    task :sysmond do
      def sysmond_url
        "http://download.newrelic.com/debian/dists/newrelic/non-free/binary-${DEB_HOST_ARCH}/newrelic-sysmond_1.2.0.257_${DEB_HOST_ARCH}.deb"
      end
      with_temporary_settings default_shell: nil do
        run "
          dpkg-query -s newrelic-sysmond >/dev/null 2>&1 || {
            DEB_HOST_ARCH=$(dpkg --print-architecture)
            temp=$(mktemp);
            wget -qO \"$temp\" \"#{sysmond_url}\" &&
              #{sudo} dpkg -i \"$temp\";
          }
        "
        run "#{sudo} nrsysmond-config --set license_key=#{newrelic_license_key}"
        run "#{sudo} /etc/init.d/newrelic-sysmond restart"
      end
    end
  end

  before 'deploy:finalize_update', 'newrelic:symlink'
  task :symlink, roles: :app do
    run "ln -sf '#{shared_newrelic_yml}' '#{symlink_newrelic_yml}'"
  end


end
