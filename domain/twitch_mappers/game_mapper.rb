# frozen_string_literal: false

require_relative 'clip_mapper.rb'

module LoyalFan
  module Twitch
    # Data Mapper for Twitch Game Category
    class GameMapper
      def initialize(gateway)
        @gateway = gateway
      end

      def load(unofficial_name)
        game_data = @gateway.game_data(unofficial_name)
        # puts game_data['_total']
        official_name = @gateway.get_game_name(unofficial_name)
        build_entity(unofficial_name, official_name, game_data)
      end

      def build_entity(unofficial_name, official_name, game_data)
        DataMapper.new(unofficial_name, official_name, game_data, @gateway).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(unofficial_name, official_name, game_data, gateway)
          @unofficial_name = unofficial_name
          @official_name = official_name
          @game_data = game_data
          @clip_mapper = ClipMapper.new(gateway)
          @channel_mapper = ChannelMapper.new(gateway)
        end

        def build_entity
          LoyalFan::Entity::Game.new(
            id: nil,
            unofficial_name: @unofficial_name,
            official_name: @official_name,
            clips: clips,
            channels: channels
          )
        end

        private

        def clips
          @clip_mapper.load('game', @official_name)
        end

        def channels
          # print @game_data['_total']
          channels = []
          10.times do |i|
            # puts @game_data['streams'][i]['channel']['name']
            name = @game_data['streams'][i]['channel']['name']
            channels << @channel_mapper.load(name)
          end

          channels
        end
      end
    end
  end
end
