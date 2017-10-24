# frozen_string_literal: false

module API
  module Twitch
    # Data Mapper for Twitch Game Category 
    class GameMapper
      def initialize(gateway)
        @gateway = gateway
      end

      def load(game_name)
        game_data = @gateway.game_data(game_name)
        game_name = @gateway.get_game_name(game_name)
        GameMapper.build_entity(game_name, game_data)
      end

      def self.build_entity(game_data)
        GameMapper.new(game_name, game_data).build_entity

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(game_name, game_data)
          @game_name = game_name
          @game_data = game_data
        end

        def build_entity
          Entity::Game.new(
            name: @game_name,
            number: number
          )
        end

        private

        def number
          @game_data['_total']
        end

        # TODO: popularity

        # return the most popular clips of specific game
        # def clips
        #   @data_source.clip('game', @name).top_clips
        # end

        # def top_streamers(num = 3)
        #   streamers = {}
        #   num.times do |i|
        #     iter = @streams_data['streams'][i]['channel']
        #     streamers[iter['display_name']] = iter['url']
        #   end
        #   streamers
        # end
      end
    end
  end
end