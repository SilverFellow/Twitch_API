# frozen_string_literal: true

module Twitch
  # Model for channel
  class Channel
    def initialize(name, channel_data, data_source)
      @name = name
      @channel_data = channel_data
      @data_source = data_source
    end

    def live?
      !@channel_data['stream'].nil?
    end

    def data
      @channel_data
    end

    # return most popular clips of this channel
    def clip
      @data_source.clip('channel', @name).top_clips
    end
  end
end
