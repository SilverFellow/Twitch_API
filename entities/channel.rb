# frozen_string_literal: false

require 'dry-struct'

module API
  module Entity
    # entity for twitch channel
    class Channel < Dry::Struct
      attribute :live, Types::Strict::Bool
      attribute :title, Types::Strict::String.optional
      attribute :game, Types::Strict::String.optional
      attribute :viewer, Types::Coercible::Int.optional
      attribute :clips, Types::Strict::Hash.optional
    end
  end
end