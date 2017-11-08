# frozen_string_literal: true

require 'dry/transaction'

module API
  class LoadGameFromTwitch
    include Dry::Transaction

    step :get_game_from_twitch
    step :check_if_game_already_loaded
    step :store_game_in_repository

    def get_game_from_twitch(input)
      # p input[:config]
      # p input[:game_name]
      # p Twitch::GameMapper.new(input[:config]).load(input[:game_name])
      game = Twitch::GameMapper.new(input[:config])
                               .load(input[:game_name])
      Right(response: game)
    rescue StandardError
      Left(Result.new(:bad_request, 'Remote git repository not found'))
    end

    def check_if_game_already_loaded(input)
      if Repository::For[input[:game].class].find_unofficial_name(input[:game])
        Left(Result.new(:conflict, 'Game already loaded'))
      else
        Right(input)
      end
    end

    def store_game_in_repository(input)
      stored_game = Repository::For[input[:game].class].find_or_create(input[:game])
      Right(Result.new(:created, stored_game))
    rescue StandardError => e
      puts e.to_s
      Left(Result.new(:internal_error, 'Could not store game to remote repository'))
    end
  end
end