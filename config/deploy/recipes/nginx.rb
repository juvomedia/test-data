
def nginx_ssl_enabled?
  exists?(:nginx_ssl_certificate_key) && exists(:nginx_ssl_certificate)
end

_cset(:nginx_force_ssl, false)

set(:nginx_ssl_certificate_local_path)     { "config/ssl/#{nginx_ssl_certificate}" }
set(:nginx_ssl_certificate_key_local_path) { "config/ssl/#{nginx_ssl_certificate_key}" }

# override/add to namespace supplied by capistrano-nginx-unicorn gem
namespace :nginx do

  desc "Setup nginx configuration for this application"
  task :setup, roles: :web do
    template("nginx_conf.erb", "/tmp/#{application}")
    run "#{sudo} mv /tmp/#{application} /etc/nginx/sites-available/#{application}"
    run "#{sudo} ln -fs /etc/nginx/sites-available/#{application} /etc/nginx/sites-enabled/#{application}"
  end

  # make this task separate so we can resetup without being asked to decrypt key all the time.
  task :setup_ssl do
    if nginx_use_ssl
      keydata = %x( openssl rsa -in #{nginx_ssl_certificate_key_local_path} )
      throw "failed to ready ssl key" unless $? == 0
      put keydata, "/tmp/#{nginx_ssl_certificate_key}"
      put File.read(nginx_ssl_certificate_local_path), "/tmp/#{nginx_ssl_certificate}"

      with_temporary_settings rvm_ruby_string: nil, default_shell: nil do
        run "#{sudo} mv /tmp/#{nginx_ssl_certificate_key} /etc/ssl/private/#{nginx_ssl_certificate_key}"
        run "#{sudo} mv /tmp/#{nginx_ssl_certificate} /etc/ssl/certs/#{nginx_ssl_certificate}"

        run "#{sudo} chown root:root /etc/ssl/certs/#{nginx_ssl_certificate}"
        run "#{sudo} chown root:root /etc/ssl/private/#{nginx_ssl_certificate_key}"
      end
    end
  end

end
