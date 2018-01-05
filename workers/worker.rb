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
    # puts "Token = #{request['token']}"
    publish(request['id'], 'Worker activating....\n')

    puts "Name = #{request['name']}"
    puts '==============================='
    gw = LoyalFan::Twitch::TwitchGateway.new(request['token'])
    game = LoyalFan::Twitch::GameMapper.new(gw).load(request['name'])
    game_json = LoyalFan::GameRepresenter.new(game).to_json
    puts game_json
    publish(request['id'], game_json)
    puts '==============================='
    puts 'Worker job finished.'
  end

  private

  def publish(channel, message)
    puts 'Posting message: '
    HTTP.headers(content_type: 'application/json')
        .post(
          "#{StreamerSuggestWorker.config.API_URL}/faye",
          body: {
            channel: "/#{channel}",
            data: message
          }.to_json
        )
  end
end
