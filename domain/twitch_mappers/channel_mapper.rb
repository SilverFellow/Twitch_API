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
        channel_data = @gateway.channel_data(channel_name)
        user_id = @gateway.get_user_id(channel_name)
        build_entity(channel_name, user_id, channel_data)
      end

      def build_entity(channel_name, user_id, channel_data)
        DataMapper.new(channel_name, user_id, channel_data, @gateway).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(channel_name, user_id, channel_data, gateway)
          @channel_name = channel_name
          @user_id = user_id
          @channel_data = channel_data
          @clip_mapper = ClipMapper.new(gateway)
        end

        def build_entity
          LoyalFan::Entity::Channel.new(
            id: nil,
            url: 'https://go.twitch.tv/' + @channel_name,
            user_id: @user_id,
            live: live,
            title: title,
            game: game,
            viewer: viewer,
            clips: clips
          )
        end

        private

        def live
          !@channel_data['stream'].nil?
        end

        def title
          live ? @channel_data['stream']['channel']['status'] : 'offline'
        end

        def game
          live ? @channel_data['stream']['game'] : 'offline'
        end

        def viewer
          live ? @channel_data['stream']['viewers'] : 0
        end

        def clips
          @clip_mapper.load('channel', @channel_name)
        end
      end
    end
  end
end
