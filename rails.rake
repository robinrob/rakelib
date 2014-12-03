$LOAD_PATH << '.'
$LOAD_PATH << 'lib'
$LOAD_PATH << 'rake'
$LOAD_PATH << 'rake/lib'

require 'csv'
require 'colorize'


# Ruby on Rails development
if File.exists?("config/application.rb")
  require File.expand_path('../../config/application', __FILE__)
  Rails.application.load_tasks
end


namespace :rails do
  desc 'Start Rails server.'
	task :server => 'rails:kill' do
	  Rake::Task["kill"].execute()
	  system("rails server")
	end


  desc 'Kill Rails server.'
  task :kill do
   system("kill `cat tmp/pids/server.pid 2> /dev/null` 2> /dev/null")
  end


  desc 'Precompile Rails assets.'
  task :precompile do
    system("RAILS_ENV=production bundle exec rake assets:precompile")
  end


  desc 'Deploy the Rails project to Heroku, pre-compiling assets first.'
  task :deploy, [:environment] => ['rails:precompile', :install, :save] do |t, args|
    environment = args[:environment] || 'production'
    puts "Deploying to: ".green << "#{environment}".yellow

    system("git push #{environment} master")
    system("heroku run rake db:migrate")
  end
end
