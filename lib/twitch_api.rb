# frozen_string_literal: false

require 'http'

module TwitchPraise
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

    def live?(channel_name)
      twitch_url = twitch_api_path('users?login=' + channel_name)
      streamer_data = call_twitch_url(twitch_url).parse
      # TODO: check data is valid or not.
      id = streamer_data['users'][0]['_id']

      twitch_url = twitch_api_path('streams/' + id)
      stream_data = call_twitch_url(twitch_url).parse

      !stream_data['stream'].nil?
    end

    def get_top3(channel_name)
      twitch_url = twitch_api_path('/clips/top?channel=' + channel_name + '&limit=3')
      streamer_data = call_twitch_url(twitch_url).parse
      # TODO: check data is valid or not.
      3.times { |i| puts streamer_data['clips'][i]['url'] }
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