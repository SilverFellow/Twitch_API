# frozen_string_literal: true

require 'dry-monads'

module LoyalFan
  #   result = FindDatabaseChannel.call(channel_name: 'xxx')
  #   result.success?
  module FindDatabaseChannel
    extend Dry::Monads::Either::Mixin

    def self.call(input)
      # Note: response is an channel entity object.
      response = Repository::For[Entity::Channel].find_url(input[:channel])
      if response
        msg = { token: input[:token], id: input[:id],
                channel: response.name.to_s, game: response.game.to_s }
        StreamerSuggestWorker.perform_async(msg.to_json)

        channel_with_id = LoyalFan::Entity::Channel.new(
          id: input[:id],
          url: response.url,
          user_id: response.user_id,
          name: response.name,
          live: response.live,
          title: response.title,
          game: response.game,
          viewer: response.viewer,
          logo: response.logo,
          clips: response.clips
        )

        Right(Result.new(:processing, channel_with_id))
      else
        Left(Result.new(:not_found, 'Could not find stored channel data'))
      end
    end
  end
end
