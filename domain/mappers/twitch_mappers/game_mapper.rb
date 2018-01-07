# frozen_string_literal: false

require_relative 'clip_mapper.rb'

module LoyalFan
  module Twitch
    # Data Mapper for Twitch Game Category
    class GameMapper
      def initialize(gateway)
        @gateway = gateway
      end

      def load(name)
        data = @gateway.game_data(name)
        build_entity(name, data)
      end

      def build_entity(name, game_data)
        DataMapper.new(name, game_data, @gateway).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(name, game_data, gateway)
          @name = name
          @game_data = game_data
          @clip_mapper = ClipMapper.new(gateway)
          @channel_mapper = ChannelMapper.new(gateway)
        end

        def build_entity
          LoyalFan::Entity::Game.new(
            id: nil,
            name: @name,
            clips: clips,
            channels: channels
          )
        end

        private

        def clips
          @clip_mapper.load('game', @name)
        end

        def channels
          channels = []
          5.times do |i|
            break unless @game_data['streams'][i]
            name = @game_data['streams'][i]['channel']['name']
            channels << @channel_mapper.load(name)
          end
          channels
        end
      end
    end
  end
end
