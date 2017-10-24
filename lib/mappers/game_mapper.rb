# frozen_string_literal: false

require_relative 'clip_mapper.rb'

module API
  module Twitch
    # Data Mapper for Twitch Game Category
    class GameMapper
      def initialize(gateway)
        @gateway = gateway
      end

      def load(game_name)
        game_data = @gateway.game_data(game_name)
        correct_name = @gateway.get_game_name(game_name)
        build_entity(correct_name, game_data)
      end

      def build_entity(game_name, game_data)
        DataMapper.new(game_name, game_data, @gateway).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(game_name, game_data, gateway)
          @game_name = game_name
          @game_data = game_data
          @clip_mapper = ClipMapper.new(gateway)
        end

        def build_entity
          API::Entity::Game.new(
            name: @game_name,
            number: number,
            clips: clips,
            streamers: top_streamers
          )
        end

        private

        def number
          @game_data['_total']
        end

        # TODO: popularity

        def clips
          @clip_mapper.load('game', @game_name)
        end

        def top_streamers(num = 3)
          streamers = {}
          num.times do |i|
            iter = @game_data['streams'][i]['channel']
            streamers[iter['display_name']] = iter['url']
          end
          streamers
        end
      end
    end
  end
end
