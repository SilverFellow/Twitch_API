# frozen_string_literal: true

require 'http'
require_relative 'clip.rb'
require_relative 'game.rb'
require_relative 'channel.rb'
require 'yaml'

module Twitch
  # Library for Twitch API
  module Errors
    class NotFound < StandardError; end
    class Unauthorized < StandardError; end
    class BadRequest < StandardError; end
  end

  # Library for Twitch Web API
  class TwitchAPI
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

    def user_exist?(name)
      twitch_url = TwitchAPI.path('users?login=' + name)
      temp_data = call_twitch_url(twitch_url).parse
      temp_data['_total'].positive?
    end

    def get_user_id(name)
      twitch_url = TwitchAPI.path('users?login=' + name)
      streamer_data = call_twitch_url(twitch_url).parse

      streamer_data['users'][0]['_id']
    end

    def channel(name)
      return 'User doesn\'t exist!' unless user_exist?(name)
      id = get_user_id(name)
      twitch_url = TwitchAPI.path('streams/' + id)
      data = call_twitch_url(twitch_url).parse

      Channel.new(name, data, self)
    end

    def game(name)
      name = correct_game_name(name).split(' ').join('%20')
      twitch_url = TwitchAPI.path('search/streams?query=' + name)
      data = call_twitch_url(twitch_url).parse

      Game.new(name, data, self)
    end

    # query_item: game, channel, language, trending ...
    def clip(query_item, name)
      twitch_url = TwitchAPI.path("/clips/top?#{query_item}=" + name)
      data = call_twitch_url(twitch_url).parse

      Clip.new(query_item, data, self)
    end

    def correct_game_name(name)
      twitch_url = TwitchAPI.path('search/games?query=' + name)
      data = call_twitch_url(twitch_url).parse

      data['games'][0]['name']
    end

    def top_game
      twitch_url = TwitchAPI.path('games/top')
      data = call_twitch_url(twitch_url).parse

      top_games = []
      10.times { |i| top_games << data['top'][i]['game']['name'] }
      top_games
    end

    def self.path(path)
      'https://api.twitch.tv/kraken/' + path
    end

    private

    def call_twitch_url(url)
      response = HTTP.headers('Accept' => 'application/vnd.twitchtv.v5+json',
                              'Client-ID' => @tw_token).get(url)
      Response.new(response).response_or_error
    end
  end
end
