# frozen_string_literal: true

require 'dry-monads'

module API
  #   result = FindDatabaseRepo.call(ownername: 'soumyaray', reponame: 'YPBT-app')
  #   result.success?
  module FindDatabaseChannel
    extend Dry::Monads::Either::Mixin

    def self.call(input)
      response = Repository::For[Entity::Channel].find_url(input[:channel_name])
      
      if response
        Right(Result.new(:ok, response))
      else
        Left(Result.new(:not_found, 'Could not find stored git repository'))
      end
    end
  end
end