module Twitch
  # Model for Clip
  class Clip
    def initialize(streamer_data, data_source)
      @streamer_data = streamer_data
      @data_source = data_source
    end

    def data
      @streamer_data
    end

    def size
      @streamer_data['clips'].count
    end

    def get_top(num = 3)
      clips = Hash.new
      num.times do |i|
        title = @streamer_data['clips'][i]['title']
        url = @streamer_data['clips'][i]['url']
        clips[title] = url
      end
      clips
    end
  end
end
