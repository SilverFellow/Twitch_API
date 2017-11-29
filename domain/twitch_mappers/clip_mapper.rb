# frozen_string_literal: false

module LoyalFan
  module Twitch
    # Data Mapper for Twitch Clips
    class ClipMapper
      def initialize(gateway)
        @gateway = gateway
      end

      def load(type, name)
        clips_data = @gateway.clip_data(type, name)['clips']
        clips_data.map do |clip_data|
          ClipMapper.build_entity(type, name, clip_data)
        end
      end

      def self.build_entity(type, name, clip_data)
        DataMapper.new(type, name, clip_data).build_entity
      end
      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(type, name, clip_data)
          @type = type
          @name = name
          @clip_data = clip_data
        end

        def build_entity
          LoyalFan::Entity::Clip.new(
            id: nil,
            title: title,
            url: url,
            view: view,
            preview: preview,
            source: @type,
            name: @name
          )
        end

        private

        def title
          @clip_data['title']
        end

        def url
          @clip_data['url']
        end

        def view
          @clip_data['views']
        end

        def preview
          @clip_data['thumbnails']['small']
        end
      end
    end
  end
end
