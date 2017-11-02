# frozen_string_literal: false

require 'dry-struct'
require_relative 'clip.rb'

module API
  module Entity
    # entity for twitch channel
    class Channel < Dry::Struct
      attribute :id, Types::Int.optional
      attribute :url, Types::Strict::String
      attribute :user_id, Types::Coercible::Int
      attribute :live, Types::Strict::Bool.optional
      attribute :title, Types::Strict::String.optional
      attribute :game, Types::Strict::String.optional
      attribute :viewer, Types::Coercible::Int.optional
      attribute :clips, Types::Strict::Array.member(Clip).optional
    end
  end
end
