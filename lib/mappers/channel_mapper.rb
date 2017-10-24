# frozen_string_literal: false

module API
  module Twitch
    # Data Mapper for Twitch channel 
    class ChannelMapper
      def initialize(gateway)
        @gateway = gateway
      end

      def load(channel_name)
        channel_data = @gateway.channel_data(channel_name)
        ChannelMapper.build_entity(channel_name, channel_data)
      end

      def self.build_entity(channel_name, channel_data)
        DataMapper.new(channel_name, channel_data).build_entity

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(channel_name, channel_data)
          @channel_name = channel_name
          @channel_data = channel_data
        end

        def build_entity
          Entity::Channel.new(
            live: live,
            name: name,
            title: title,
            game: game,
            viewer: viewer,
          )
        end

        private

        def live
          !@channel_data['streams'].nil?
        end     
        
        def name
          live? ? @channel_data['stream']['channel']['display_name'] : @channel_name
        end

        def title
          live? ? @channel_data['stream']['channel']['status'] : 'offline'
        end

        def game
          live? ? @channel_data['stream']['game'] : 'offline'
        end

        def viewer
          live? ? @channel_data['stream']['viewers'] : 0
        end

        # return most popular clips of this channel
        # def clips
        #   @data_source.clip('channel', @name).top_clips
        # end
      end
    end
  end
end