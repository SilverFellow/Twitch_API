# frozen_string_literal: true

require 'rake/testtask'

task :default do
  puts `rake -T`
end

# Configuration only -- not for direct calls
task :config do
  require_relative 'config/environment.rb' # load config info
  @app = LoyalFan::Api
  @config = @app.config
end

desc 'run tests once'
Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/api_spec.rb'
  t.warning = false
end

desc 'Keep running tests upon changes'
task :respec => :config do
  puts 'REMEMBER: need to run `rake run:[dev|test]:worker` in another process'
  sh "rerun -c 'rake spec' --ignore 'coverage/*'"
end

desc 'run application console (pry)'
task :console do
  sh 'pry -r ./spec/test_load_all'
end

namespace :api do
  namespace :run do
    desc 'Rerun the API server in development mode'
    task :dev => :config do
      puts 'REMEMBER: need to run `rake run:dev:worker` in another process'
      sh "rerun -c 'rackup -p 3030' --ignore 'coverage/*'"
    end

    desc 'Rerun the API server in test mode'
    task :test => :config do
      puts 'REMEMBER: need to run `rake run:test:worker` in another process'
      sh "rerun -c 'RACK_ENV=test rackup -p 3000' --ignore 'coverage/*'"
    end
  end
end

namespace :worker do
  namespace :run do
    desc 'Run the background worker in development mode'
    task :development => :config do
      sh 'RACK_ENV=development bundle exec shoryuken -r ./workers/worker.rb -C ./workers/shoryuken.yml'
    end

    desc 'Run the background worker in production mode'
    task :production => :config do
      sh 'RACK_ENV=production bundle exec shoryuken -r ./workers/worker.rb -C ./workers/shoryuken.yml'
    end
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

namespace :queue do
  require 'aws-sdk-sqs'

  desc "Create SQS queue for Shoryuken"
  task :create => :config do
    sqs = Aws::SQS::Client.new(region: @config.AWS_REGION)

    begin
      queue = sqs.create_queue(
        queue_name: @config.QUEUE,
        attributes: {
          FifoQueue: 'true',
          ContentBasedDeduplication: 'true'
        }
      )

      q_url = sqs.get_queue_url(queue_name: @config.QUEUE)
      puts "Queue created:"
      puts "Name: #{@config.QUEUE}"
      puts "Region: #{@config.AWS_REGION}"
      puts "URL: #{q_url.queue_url}"
      puts "Environment: #{@app.environment}"
    rescue => e
      puts "Error creating queue: #{e}"
    end
  end

  desc "Purge messages in SQS queue for Shoryuken"
  task :purge => :config do
    sqs = Aws::SQS::Client.new(
      access_key_id: @config.AWS_ACCESS_KEY_ID,
      secret_access_key: @config.AWS_SECRET_ACCESS_KEY,
      region: @config.AWS_REGION)

    begin
      queue = sqs.purge_queue(queue_url: @config.QUEUE_URL)
      puts "Queue #{@config.QUEUE} purged"
    rescue => e
      puts "Error purging queue: #{e}"
    end
  end
end