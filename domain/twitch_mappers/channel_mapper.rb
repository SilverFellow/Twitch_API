# frozen_string_literal: false

require_relative 'clip_mapper.rb'

module LoyalFan
  module Twitch
    # Data Mapper for Twitch Channel
    class ChannelMapper
      def initialize(gateway)
        @gateway = gateway
      end

      def load(channel_name)
        channel_property = @gateway.get_channel_property(channel_name)
        channel_data = @gateway.channel_data(channel_property.first)
        build_entity(channel_name, channel_property, channel_data)
      end

      def build_entity(channel_name, channel_property, channel_data)
        DataMapper.new(channel_name, channel_property, channel_data, @gateway).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(channel_name, channel_property, channel_data, gateway)
          @channel_name = channel_name
          @channel_property = channel_property
          @channel_data = channel_data
          @clip_mapper = ClipMapper.new(gateway)
        end

        def build_entity
          LoyalFan::Entity::Channel.new(
            id: nil,
            url: 'https://go.twitch.tv/' + @channel_name,
            user_id: @channel_property.first,
            name: @channel_property[1],
            #live: live,
            #title: title,
            #game: game,
            #viewer: viewer,
            logo: @channel_property[2],
            clips: clips
          )
        end

        private

        def stream
          @channel_data['stream']
        end

        def live
          !stream.nil?
        end

        def title
          live ? stream['channel']['status'] : 'offline'
        end

        def game
          live ? stream['game'] : 'offline'
        end

        def viewer
          live ? stream['viewers'] : 0
        end

        def clips
          @clip_mapper.load('channel', @channel_name)
        end
      end
    end
  end
end
