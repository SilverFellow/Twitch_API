# frozen_string_literal: false

require 'dry-struct'
require_relative 'clip.rb'

module LoyalFan
  module Entity
    # entity for twitch channel
    class Channel < Dry::Struct
      attribute :id, Types::Int.optional
      attribute :url, Types::Strict::String
      attribute :user_id, Types::Coercible::Int
      attribute :live, Types::Strict::Bool
      attribute :title, Types::Strict::String
      attribute :game, Types::Strict::String
      attribute :viewer, Types::Coercible::Int
      attribute :clips, Types::Strict::Array.member(Clip).optional
    end
  end
end
