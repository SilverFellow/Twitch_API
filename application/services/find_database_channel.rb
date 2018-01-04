# frozen_string_literal: true

require 'dry-monads'

module LoyalFan
  #   result = FindDatabaseChannel.call(channel_name: 'xxx')
  #   result.success?
  module FindDatabaseChannel
    extend Dry::Monads::Either::Mixin

    def self.call(input)
      # Note: response is an entity object.
      response = Repository::For[Entity::Channel].find_url(input[:channel])
      if response
        msg = { token: input[:token], name: response.game }
        StreamerSuggestWorker.perform_async(msg.to_json)
        Right(Result.new(:processing, { response: response, id: input[:id] }))
      else
        Left(Result.new(:not_found, 'Could not find stored channel data'))
      end
    end
  end
end
