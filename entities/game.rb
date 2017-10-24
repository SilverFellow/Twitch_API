# frozen_string_literal: false

require 'dry-struct'

module API
  module Entity
    # entity for twitch channel
    class Game < Dry::Struct
      attribute :name, Types::Strict::String.optional
      attribute :number, Types::Coercible::Int.optional
      attribute :clips, Types::Strict::Array.member(Clip).optional
      # attribute :top_streamers, Types::Strict::Hash.optional
    end
  end
end