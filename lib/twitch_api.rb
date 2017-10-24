# frozen_string_literal: true

require 'http'
require 'yaml'
require_relative '../init.rb'

module API
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
        @tw_token = token
      end

      def channel_data(name)
        id = get_user_id(name)
        twitch_url = TwitchGateway.path('streams/' + id)
        call_twitch_url(twitch_url).parse
      end

      def game_data(name)
        name = get_game_name(name).split(' ').join('%20')
        twitch_url = TwitchGateway.path('search/streams?query=' + name)
        call_twitch_url(twitch_url).parse
      end

      # query_item: game, channel, language, trending ...
      def clip_data(query_item, name)
        name = name.split(' ').join('%20') if query_item == 'game'
        twitch_url = TwitchGateway.path("/clips/top?#{query_item}=" + name)
        call_twitch_url(twitch_url).parse
      end

      def self.path(path)
        'https://api.twitch.tv/kraken/' + path
      end

      # get correct(accepted by twitch) name, return NULL if game doesn't exist
      def get_game_name(name)
        twitch_url = TwitchGateway.path('search/games?query=' + name)
        data = call_twitch_url(twitch_url).parse

        !data['games'].nil? ? data['games'][0]['name'] : name
      end

      private

      def call_twitch_url(url)
        response = HTTP.headers('Accept' => 'application/vnd.twitchtv.v5+json',
                                'Client-ID' => @tw_token).get(url)
        Response.new(response).response_or_error
      end

      # get userid by given name, return NULL if user doesn't exist
      def get_user_id(name)
        twitch_url = TwitchGateway.path('users?login=' + name)
        data = call_twitch_url(twitch_url).parse

        data['_total'].positive? ? data['users'][0]['_id'] : NULL
      end

      # def top_game
      #   twitch_url = TwitchGateway.path('games/top')
      #   data = call_twitch_url(twitch_url).parse

      #   top_games = []
      #   10.times { |i| top_games << data['top'][i]['game']['name'] }
      #   top_games
      # end
    end
  end
end
