# frozen_string_literal: true

require 'http'

module LoyalFan
  module Twitch
    # Gateway class to talk to Twitch API
    class TwitchGateway
      module Errors
        # Not allowed to access resource
        Unauthorized = Class.new(StandardError)
        # Requested resource not found
        NotFound = Class.new(StandardError)
        # Bad Request
        BadRequest = Class.new(StandardError)
      end

      # Encapsulates API response success and errors
      class Response
        HTTP_ERROR = {
          400 => Errors::BadRequest,
          401 => Errors::Unauthorized,
          404 => Errors::NotFound
        }.freeze

        def initialize(response)
          @response = response
        end

        def successful?
          HTTP_ERROR.keys.include?(@response.code) ? false : true
        end

        def response_or_error
          successful? ? @response : raise(HTTP_ERROR[@response.code])
        end
      end

      def initialize(token)
        @TWITCH_TOKEN = token
      end

      def channel_data(id)
        # id = get_user_id(name)
        twitch_url = TwitchGateway.path('streams/' + id)
        call_twitch_url(twitch_url).parse
      end

      def game_data(name)
        name = get_game_name(name).split(' ').join('%20')
        twitch_url = TwitchGateway.path('search/streams?query=' + name)
        call_twitch_url(twitch_url).parse
      end

      def clip_data(query_item, name)
        name = name.split(' ').join('%20') if query_item == 'game'
        twitch_url = TwitchGateway.path("/clips/top?#{query_item}=" + name)
        call_twitch_url(twitch_url).parse
      end

      def self.path(path)
        'https://api.twitch.tv/kraken/' + path
      end

      # try to get correct(accepted by twitch) name
      def get_game_name(name)
        twitch_url = TwitchGateway.path('search/games?query=' + name)
        data = call_twitch_url(twitch_url).parse
        game = data['games']

        game.nil? ? game[0]['name'] : name
      end

      # get some information about streamer: [id, name, logo_url]
      def get_channel_property(name)
        ret = []
        twitch_url = TwitchGateway.path('users?login=' + name)
        data = call_twitch_url(twitch_url).parse
        # Assume user know what they're doing.
        # exist = data['_total'].positive?
        user = data['users'][0]

        ret << user['_id'] << user['display_name'] << user['logo']
      end

      private

      def call_twitch_url(url)
        response = HTTP.headers('Accept' => 'application/vnd.twitchtv.v5+json',
                                'Client-ID' => @TWITCH_TOKEN).get(url)
        Response.new(response).response_or_error
      end
    end
  end
end
