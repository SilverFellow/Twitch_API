# frozen_string_literal: false

module API
  module Twitch
    # Data Mapper for Twitch Game Category 
    class ClipMapper
      def initialize(gateway)
        @gateway = gateway
      end

      def load(type, name)
        clips_data = @gateway.clip_data(type, name)['clips']
        clips_data.map do |clip_data|
          ClipMapper.build_entity(clip_data)
        end
      end

      def self.build_entity(clip_data)
        DataMapper.new(clip_data).build_entity
      end
      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(clip_data)
          @clip_data = clip_data
        end

        def build_entity
          Entity::Game.new(
            title: title,
            url: url
          )
        end

        private

        def title
          @clip_data['title']
        end

        def url
          @clip_data['url']
        end
      end
    end
  end
end