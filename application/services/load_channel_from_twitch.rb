# frozen_string_literal: true

require 'dry/transaction'

module LoyalFan
  # Helper class to serialize steps of loading channel information from twitch
  class LoadChannelFromTwitch
    include Dry::Transaction
    step :get_channel_from_twitch
    step :create_or_update
    # step :check_if_channel_already_loaded
    # step :store_channel_in_repository

    def get_channel_from_twitch(input)
      channel = Twitch::ChannelMapper.new(input[:config])
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
      Left(Result.new(:internal_error, 'Could not store channel to remote repository'))
    end

    # def check_if_channel_already_loaded(input)
    #   name = input.url[21..-1]
    #   if Repository::For[Entity::Channel].find_url(name)
    #     Left(Result.new(:conflict, 'Channel already loaded'))
    #   else
    #     Right(input)
    #   end
    # end

    # def store_channel_in_repository(input)
    #   stored_channel = Repository::For[Entity::Channel].find_or_create(input)
    #   Right(Result.new(:created, stored_channel))
    # rescue StandardError => e
    #   puts e.to_s
    #   Left(Result.new(:internal_error, 'Could not store channel to remote repository'))
    # end
  end
end
