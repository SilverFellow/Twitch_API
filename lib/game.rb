# frozen_string_literal: true

module Twitch
  # Model for Game
  class Game
    attr_reader :name

    def initialize(name, streams_data, data_source)
      @name = name
      @streams_data = streams_data
      @data_source = data_source
    end

    def data
      @streams_data
    end

    def size
      @streams_data['_total']
    end

    # return the most popular clips of specific game
    def clips
      @data_source.clip('game', @name).top_clips
    end

    def top_streamers(num = 3)
      streamers = {}
      num.times do |i|
        iter = @streams_data['streams'][i]['channel']
        streamers[iter['display_name']] = iter['url']
      end
      streamers
    end
  end
end
