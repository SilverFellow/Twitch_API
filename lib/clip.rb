# frozen_string_literal: true

module Twitch
  # Model for Clip
  class Clip
    def initialize(query_item, clips_data, data_source)
      @query_item = query_item
      @clips_data = clips_data
      @data_source = data_source
    end

    def num
      @clips_data['clips'].count
    end

    def top_clips(num = 3)
      clips = {}
      num.times do |i|
        iter = @clips_data['clips'][i]
        clips[iter['title']] = iter['url']
      end
      clips
    end
  end
end
