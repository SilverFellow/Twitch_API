# frozen_string_literal: true

require 'dry-monads'

module API
  #   result = FindDatabaseRepo.call(ownername: 'soumyaray', reponame: 'YPBT-app')
  #   result.success?
  module FindDatabaseGame
    extend Dry::Monads::Either::Mixin

    def self.call(input)
      response = Repository::For[Entity::Game].find_unofficial_name(input[:game_name])
      if response
        Right(Result.new(:ok, response))
      else
        Left(Result.new(:not_found, 'Could not find stored git repository'))
      end
    end
  end
end