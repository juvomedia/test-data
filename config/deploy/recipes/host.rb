before 'rvm:install_rvm',  'host:packages'
after  'rvm:install_ruby', 'host:gems'

namespace :host do

  namespace :packages do
    def ubuntu_packages
      %w{
        autoconf
        automake
        bison
        build-essential
        curl
        git
        libc6-dev
        libreadline-dev
        libsqlite3-dev
        libssl-dev
        libtool
        libxml2-dev
        libxslt-dev
        libyaml-dev
        ncurses-dev
        nginx
        openjdk-6-jre
        openssl
        pkg-config
        sqlite3
        zlib1g-dev
        collectd
      }
    end

    task :default do
      # which came first rvm-shell or the egg.
      with_temporary_settings rvm_ruby_string: nil, default_shell: nil do
        packages = ubuntu_packages.join(' ')
        update
        # use apt-get returns better exit codes for packages that
        # fail to fectch from the repository
        sudo "apt-get -y install #{packages}", pty: true
      end
    end

    task :update do
      sudo "apt-get -q=2 update"
    end

  end

  task :gems do
    run "ruby -r bundler -e '' >/dev/null 2>&1 || gem install bundler"
  end

end


