
namespace :poke do
  task :vars do
    [
      :deploy_to,
      :shared_path,
      :current_path,
      :unicorn_user,
      :user
    ].each {|v|  puts "#{v}: #{send v}"}
  end
end
