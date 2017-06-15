require 'figaro'
require 'byebug'
# require 'whenever/capistrano'

Figaro.application = Figaro::Application.new environment: 'development',
                                             path: "#{`pwd`.strip}/config/application.yml"
Figaro.load

server ENV['host'], roles: [:web, :app, :db], primary: true

set :repo_url,        ENV['repo_url']
set :application,     ENV['app_name']
set :user,            ENV['deploy_user']

set :rvm_ruby_version, '2.3.1@eComm'
set :bundle_binstubs, nil
set :pty,             true
set :use_sudo,        true
set :stages,          [:production, :staging]
set :default_stage,   :staging
set :deploy_via,      :remote_cache
set :puma_bind,       ->{"unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"}
set :puma_state,      ->{"#{shared_path}/tmp/pids/puma.state"}
set :puma_pid,        ->{"#{shared_path}/tmp/pids/puma.pid"}
set :puma_access_log, '/logs/puma/puma.error.log'
set :puma_error_log,  '/logs/puma/puma.access.log'
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord

set :nginx_log_path,  "/logs/nginx/#{fetch(:application)}_#{fetch(:stage)}"

# set :whenever_cron,   -> { "#{fetch(:application)}_#{fetch(:stage)}" }

## Defaults:
# set :scm,           :git
# set :branch,        :master
# set :format,        :pretty
# set :log_level,     :debug
# set :keep_releases, 5

## Linked Files & Directories (Default None):
set :linked_files, %w{config/database.yml config/application.yml config/secrets.yml}
set :linked_dirs, %w(public/spree)
set :linked_dirs, %w{tmp/pids}
# set :linked_dirs,  %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
end

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'delayed_job:restart'
  end
end
