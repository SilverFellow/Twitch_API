# frozen_string_literal: true

require 'rake/testtask'

task :default do
  puts `rake -T`
end

# Configuration only -- not for direct calls
task :config do
  require_relative 'config/environment.rb' # load config info
  @app = LoyalFan::Api
end

desc 'run tests'
Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/api_spec.rb'
  t.warning = false
end

desc 'rerun tests'
task :respec => :config do
  sh "rerun -c 'rake spec' --ignore 'coverage/*'"
end

desc 'run application console (pry)'
task :console do
  sh 'pry -r ./spec/test_load_all'
end

namespace :run do
  task :dev => :config do
    sh "rerun -c 'RACK_ENV=test rackup -p 3030' --ignore 'coverage/*'"
  end

  task :test => :config do
    sh "rerun -c 'RACK_ENV=test rackup -p 3000' --ignore 'coverage/*'"
  end
end

desc 'delete cassette fixtures'
task :rmvcr do
  sh 'rm spec/fixtures/cassettes/*.yml' do |ok, _|
    puts(ok ? 'Cassettes deleted' : 'No cassettes found')
  end
end

namespace :quality do
  CODE = '**/*.rb'

  desc 'run all quality checks'
  task all: %i[rubocop reek flog]

  task :rubocop do
    sh "rubocop #{CODE}"
  end

  task :reek do
    sh "reek #{CODE}"
  end

  task :flog do
    sh "flog #{CODE}"
  end
end

namespace :db do
  require_relative 'config/environment.rb' # load config info
  require 'sequel' # TODO: remove after create orm

  Sequel.extension :migration
  app = LoyalFan::Api

  desc 'Run migrations'
  task :migrate do
    puts "Migrating #{app.environment} database to latest"
    Sequel::Migrator.run(app.DB, 'infrastructure/database/migrations')
  end

  desc 'Drop all tables'
  task :drop do
    require_relative 'config/environment.rb'
    # drop according to dependencies
    app.DB.drop_table :games_clips
    app.DB.drop_table :channels_clips
    app.DB.drop_table :games_channels
    app.DB.drop_table :clips
    app.DB.drop_table :channels
    app.DB.drop_table :games
    app.DB.drop_table :schema_info
  end

  desc 'Reset all database tables'
  task reset: %i[drop migrate]

  desc 'Delete dev or test database file'
  task :wipe do
    if app.environment == :production
      puts 'Cannot wipe production database!'
      return
    end

    FileUtils.rm(app.config.DB_FILENAME)
    puts "Deleted #{app.config.DB_FILENAME}"
  end
end
