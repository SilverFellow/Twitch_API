# frozen_string_literal: true

module Twitch
  # Model for channel
  class Channel
    attr_reader :name

    def initialize(name, channel_data, data_source)
      @name = name
      @channel_data = channel_data
      @data_source = data_source
    end

    def live?
      !@channel_data['stream'].nil?
    end

    def title
      live? ? @channel_data['stream']['channel']['status'] : offline_message
    end

    def game
      live? ? @channel_data['stream']['game'] : offline_message
    end

    def viewers
      live? ? @channel_data['stream']['viewers'] : offline_message
    end

    # return most popular clips of this channel
    def clips
      @data_source.clip('channel', @name).top_clips
    end

    private

    def offline_message
      "#{name} is currently offline"
    end
  end
end
