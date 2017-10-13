module Twitch
  # Model for Game
  class Game
    def initialize(streams_data, data_source)
      @streams_data = streams_data
      @data_source = data_source
    end

    def data
      @streams_data
    end

    def size
      @streams_data['_total']
    end

    def get_top(num = 3)
      streamers = Hash.new
      num.times do |i|
        name = @streams_data['streams'][i]['channel']['display_name']
        url = @streams_data['streams'][i]['channel']['url']
        streamers[name] = url
      end
      streamers
    end
  end
end
