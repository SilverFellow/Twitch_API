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
    end
  end
end
