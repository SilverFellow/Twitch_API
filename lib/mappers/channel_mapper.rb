# frozen_string_literal: false

module API
  module Twitch
    # Data Mapper for Twitch channel 
    class ChannelMapper
      def initialize(gateway)
        @gateway = gateway
      end

      def load(name)
        channel_data = @gateway.channel_data(name)
        channel_data.map do |data|
          DataMapper.build_entity(data)
        end
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(channel_data)
          @channel_data = channel_data
        end

        def build_entity
          Entity::Channel.new(
            live: live,
            title: title,
            game: game,
            viewer: viewer,
          )
        end

        private

        def live
          !@channel_data['streams'].nil?
        end

        def title
          live? ? @channel_data['stream']['channel']['status'] : offline_message
        end

        def game
          live? ? @channel_data['stream']['game'] : offline_message
        end

        def viewer
          live? ? @channel_data['stream']['viewers'] : offline_message
        end

        # return most popular clips of this channel
        # def clips
        #   @data_source.clip('channel', @name).top_clips
        # end
      end
    end
  end
end