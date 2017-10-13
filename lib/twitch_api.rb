require 'http'
require_relative 'clip.rb'
require_relative 'game.rb'

module Twitch
  # Library for Twitch API
  class TwitchAPI
    module Errors
      class NotFound < StandardError; end
      class Unauthorized < StandardError; end
    end

    HTTP_ERROR = {
      401 => Errors::Unauthorized,
      404 => Errors::NotFound
    }.freeze

    def initialize(token, cache: {})
      @tw_token = token
      @cache = cache
    end

    def user_exist?(name)
      twitch_url = twitch_api_path('users?login=' + name)
      temp_data = call_twitch_url(twitch_url).parse
      temp_data['_total'] > 0
    end

    def live?(name)
      twitch_url = twitch_api_path('users?login=' + name)
      streamer_data = call_twitch_url(twitch_url).parse
      if streamer_data['_total'].zero?
        # raise ArgumentError.new("User does not exist!")
        puts 'User does not exist!'
        return
      end

      id = streamer_data['users'][0]['_id']
      twitch_url = twitch_api_path('streams/' + id)
      stream_data = call_twitch_url(twitch_url).parse

      !stream_data['stream'].nil?
    end

    def clip(channel_name)
      twitch_url = twitch_api_path('/clips/top?channel=' + channel_name)
      streamer_data = call_twitch_url(twitch_url).parse

      Clip.new(streamer_data, self)
    end

    def game(game_name)
      twitch_url = twitch_api_path('search/streams?query=' + game_name)
      streams_data = call_twitch_url(twitch_url).parse

      Game.new(streams_data, self)
    end

    private

    def twitch_api_path(path)
      'https://api.twitch.tv/kraken/' + path
    end

    def call_twitch_url(url)
      result = @cache.fetch(url) do
        HTTP.headers('Accept' => 'application/vnd.twitchtv.v5+json',
                     'Client-ID' => @tw_token).get(url)
      end

      successful?(result) ? result : raise_error(result)
    end

    def successful?(result)
      HTTP_ERROR.keys.include?(result.code) ? false : true
    end

    def raise_error(result)
      raise(HTTP_ERROR[result.code])
    end
  end
end
