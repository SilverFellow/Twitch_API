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
                                     .load(input[:channel_name])
      Right(channel)
    rescue StandardError
      Left(Result.new(:bad_request, 'Channel not found'))
    end

    def create_or_update(input)
      stored_channel = Repository::For[Entity::Channel].update_or_create(input)
      Right(Result.new(:created, stored_channel))
    rescue StandardError => e
      puts e.to_s
      Left(Result.new(:internal_error, 'Could not store(update) channel to database'))
    end
  end
end
