# frozen_string_literal: false

require 'dry-struct'
require_relative 'clip.rb'
require_relative 'channel.rb'

module LoyalFan
  module Entity
    # entity for twitch game category
    class Game < Dry::Struct
      attribute :id, Types::Int.optional
      attribute :name, Types::Strict::String
      attribute :clips, Types::Strict::Array.member(Clip).optional
      attribute :channels, Types::Strict::Array.member(Channel).optional

      def build_dedup_game(exc)
        ret = LoyalFan::Entity::Game.new(
          id: nil,
          name: self.name,
          clips: self.clips,
          channels: dedup_channel(self.channels, exc)
        )
      end
  
      def dedup_channel(channels, exc)
        new_channels = []
        channels.each do |channel|
          new_channels << channel if !channel.name.eql?(exc)
        end
        new_channels
      end
    end
  end
end
