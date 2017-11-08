# frozen_string_literal: true

require 'dry/transaction'

module API
  class LoadChannelFromTwitch
    include Dry::Transaction
    step :get_channel_from_github
    step :check_if_channel_already_loaded
    step :store_channel_in_repository

    def get_channel_from_twitch(input)
      channel = Twitch::ChannelMapper.new(input[:config])
                               .load(input[:channel_name])
      Right(response: channel)
    rescue StandardError
      Left(Result.new(:bad_request, 'Remote git repository not found'))
    end

    def check_if_channel_already_loaded(input)
      if Repository::For[input[:channel].class].find_url(input[:channel])
        Left(Result.new(:conflict, 'Channel already loaded'))
      else
        Right(input)
      end
    end

    def store_channel_in_repository(input)
      stored_channel = Repository::For[input[:channel].class].find_or_create(input[:channel])
      Right(Result.new(:created, stored_channel))
    rescue StandardError => e
      puts e.to_s
      Left(Result.new(:internal_error, 'Could not store channel to remote repository'))
    end
  end
end