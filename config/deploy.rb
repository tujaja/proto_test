set :application, "proto_test"

# Git Repository Settings
set :repository,  "git@github.com:tujaja/proto_test.git"
set :scm, "git"
set :branch, "master"

# tell cap to fetch submodules(plugins)
set :git_enable_submodules, 1


# SSH Settings
set :user, "tujaja"
set :use_sudo, false

# Deploy Settings
set :deploy_via, :copy
set :deploy_to, "/home/#{user}/www/3shimeji.co.cc/#{application}"

# Servers
role :web, "tujaja2.co.cc"
role :app, "tujaja2.co.cc"
role :db,  "tujaja2.co.cc", :primary => true



after 'deploy:setup', 'deploy:setup_configs'
after 'deploy:update_code', 'deploy:copy_configs'
namespace :deploy do
#   task :start {}
#   task :stop {}
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end

  task :copy_configs do
    run <<-CMD
      cd #{release_path} &&
      cp -f #{shared_path}/config/database.yml #{release_path}/config/database.yml &&
      cp -f #{shared_path}/config/config.yml #{release_path}/config/config.yml &&
      cp -f #{shared_path}/config/paypal.yml #{release_path}/config/paypal.yml &&
      cp -af #{shared_path}/config/certs #{release_path}/config
    CMD
  end

  task :setup_configs do
    home_config_path = "/home/tujaja/3shimeji.co.cc.config"
    run <<-CMD
      mkdir -p #{shared_path}/config &&
      cp -f #{home_config_path}/database.yml #{shared_path}/config/database.yml &&
      cp -f #{home_config_path}/config.yml #{shared_path}/config/config.yml &&
      cp -f #{home_config_path}/paypal.yml #{shared_path}/config/paypal.yml &&
      cp -af #{home_config_path}/certs #{shared_path}/config
    CMD
  end

  task :development_migration do
    run <<-CMD
      cd #{current_path} &&
      rake db:migrate VERSION='0' &&
      rake db:migrate
    CMD
  end


end



