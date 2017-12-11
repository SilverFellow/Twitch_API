# frozen_string_literal: true

require_relative 'load_all'

require 'econfig'
require 'shoryuken'

# Shoryuken worker class
class StreamerSuggestWorker
  extend Econfig::Shortcut
  Econfig.env = ENV['RACK_ENV'] || 'development'
  Econfig.root = File.expand_path('..', File.dirname(__FILE__))

  Shoryuken.sqs_client = Aws::SQS::Client.new(
    access_key_id: config.AWS_ACCESS_KEY_ID,
    secret_access_key: config.AWS_SECRET_ACCESS_KEY,
    region: config.AWS_REGION
  )

  include Shoryuken::Worker
  shoryuken_options queue: config.QUEUE_URL, auto_delete: true

  def perform(_sqs_msg, worker_request)
    request = JSON.parse(worker_request)
    puts request.class
    puts "Token = #{request['token']}"
    puts "Name = #{request['name']}"
    puts '==============================='
    gw = LoyalFan::Twitch::TwitchGateway.new(request['token'])
    game = LoyalFan::Twitch::GameMapper.new(gw).load(request['name'])
    puts "Worker job finished."
    # puts game

  end
end
