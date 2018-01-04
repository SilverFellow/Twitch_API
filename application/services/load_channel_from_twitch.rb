# frozen_string_literal: true

require 'dry/transaction'

module LoyalFan
  # Helper class to serialize steps of loading channel information from twitch
  class LoadChannelFromTwitch
    include Dry::Transaction
    step :get_channel_from_twitch
    step :create_or_update

    def get_channel_from_twitch(input)
      channel = Twitch::ChannelMapper.new(input[:gateway])
                                     .load(input[:channel])
      input[:channel] = channel
      Right(input)
    rescue StandardError
      Left(Result.new(:bad_request, 'Channel not found on twitch'))
    end

    def create_or_update(input)
      stored_channel = Repository::For[Entity::Channel].update_or_create(input[:channel])
      channel_json = ChannelRepresenter.new(stored_channel).to_json
      notify_listeners(channel_json, input[:config])
      Right(Result.new(:created, stored_channel))
    rescue StandardError => e
      puts e.to_s
      Left(Result.new(:internal_error, 'Could not store(update) channel to database'))
    end

    private
    
    def notify_listeners(message, config)
      # ENV['AWS_REGION'] = config.AWS_REGION
      scheduled_queue = Messaging::Queue.new(config.SCHEDULED_QUEUE_URL)
      scheduled_queue.send(message)
    end
  end
end
